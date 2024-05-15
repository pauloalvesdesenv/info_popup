import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import '';
import 'package:aco_plus/app/modules/relatorio/ui/ordem/relatorio_ordem_pdf_ordem_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/ordem/relatorio_ordem_pdf_status_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/pedido/relatorio_pedido_pdf_page.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_ordem_view_model.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_web.dart'
    if (dart.library.io) 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_mobile.dart';

final relatorioCtrl = PedidoController();

class PedidoController {
  static final PedidoController _instance = PedidoController._();

  PedidoController._();

  factory PedidoController() => _instance;

  final AppStream<RelatorioPedidoViewModel> pedidoViewModelStream =
      AppStream<RelatorioPedidoViewModel>();
  RelatorioPedidoViewModel get pedidoViewModel => pedidoViewModelStream.value;

  void onCreateRelatorioPedido() {
    final model = RelatorioPedidoModel(
      pedidoViewModel.cliente!,
      pedidoViewModel.status!,
      FirestoreClient.pedidos.data
          .map((e) => e.copyWith())
          .toList()
          .where((e) =>
              pedidoViewModel.status == RelatorioPedidoStatus.produzindo
                  ? e.statusess.last.status != PedidoStatus.pronto
                  : e.statusess.last.status == PedidoStatus.pronto)
          .toList(),
    );
    pedidoViewModel.relatorio = model;
    pedidoViewModelStream.update();
  }

  Future<void> onExportRelatorioPedidoPDF() async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) =>
            RelatorioPedidoPdfPage(pedidoViewModel.relatorio!)
                .build(imageBytes)));

    await downloadPDF(
        "m2_relatorio_cliente_${pedidoViewModel.cliente?.nome.toLowerCase().replaceAll(' ', '_')}_status_${pedidoViewModel.status!.label.toLowerCase()}${DateTime.now().toFileName()}.pdf",
        '/relatorio/pedido/',
        await pdf.save());
  }

  final AppStream<RelatorioOrdemViewModel> ordemViewModelStream =
      AppStream<RelatorioOrdemViewModel>();
  RelatorioOrdemViewModel get ordemViewModel => ordemViewModelStream.value;

  void onCreateRelatorio() {
    if (ordemViewModel.type == RelatorioOrdemType.STATUS) {
      onCreateRelatorioOrdemStatus();
    } else {
      onCreateRelatorioOrdem();
    }
  }

  void onCreateRelatorioOrdemStatus() {
    List<OrdemModel> ordens =
        FirestoreClient.ordens.data.map((e) => e.copyWith()).toList();
    for (final ordem in ordens) {
      ordem.produtos = ordem.produtos
          .where((e) => _whereProductStatus(e, ordemViewModel.status!))
          .toList();
    }
    ordens.removeWhere((e) => e.produtos.isEmpty);
    if (ordemViewModel.dates != null) {
      ordens = ordens
          .where((e) =>
              e.createdAt.isAfter(ordemViewModel.dates!.start) &&
              e.createdAt.isBefore(ordemViewModel.dates!.end))
          .toList();
    }
    final model = RelatorioOrdemModel.status(
      ordemViewModel.status!,
      ordens,
      dates: ordemViewModel.dates,
    );

    ordemViewModel.relatorio = model;
    ordemViewModelStream.update();
  }

  void onCreateRelatorioOrdem() {
    final model = RelatorioOrdemModel.ordem(
      ordemViewModel.ordem!,
    );

    ordemViewModel.relatorio = model;
    ordemViewModelStream.update();
  }

  bool _whereProductStatus(
      PedidoProdutoModel produto, RelatorioOrdemStatus status) {
    final productStatus = produto.statusess.last.status;
    switch (status) {
      case RelatorioOrdemStatus.AGUARDANDO_PRODUCAO:
        return [
          PedidoProdutoStatus.separado,
          PedidoProdutoStatus.aguardandoProducao
        ].contains(productStatus);
      case RelatorioOrdemStatus.EM_PRODUCAO:
        return productStatus == PedidoProdutoStatus.produzindo;
      case RelatorioOrdemStatus.PRODUZIDAS:
        return productStatus == PedidoProdutoStatus.pronto;
    }
  }

  double getOrdemTotal() {
    double qtde = 0;
    for (var orden in ordemViewModel.relatorio!.ordens) {
      for (var produto in orden.produtos) {
        qtde = qtde + produto.qtde;
      }
    }
    return double.parse(qtde.toStringAsFixed(2));
  }

  List<ProdutoModel> getTiposProdutosId() {
    List<ProdutoModel> produtos = [];
    for (var ordem in ordemViewModel.relatorio!.ordens) {
      for (var produto in ordem.produtos) {
        if (produtos.map((e) => e.id).contains(produto.produto.id) == false) {
          produtos.add(produto.produto);
        }
      }
    }
    return produtos.toList();
  }

  List<PedidoProdutoModel> getOrdemTotalProduto() {
    List<PedidoProdutoModel> pedidoProdutos = [];
    final types = getTiposProdutosId();
    for (var type in types) {
      double qtde = 0;
      for (var ordem in ordemViewModel.relatorio!.ordens) {
        for (var produto in ordem.produtos) {
          if (produto.produto.id == type.id) {
            qtde = qtde + produto.qtde;
          }
        }
      }
      pedidoProdutos.add(PedidoProdutoModel(
          id: 'total',
          produto: type,
          qtde: qtde,
          statusess: [],
          clienteId: '',
          obraId: '',
          pedidoId: ''));
    }
    pedidoProdutos.sort((a, b) => a.produto.number.compareTo(b.produto.number));
    return pedidoProdutos;
  }

  Future<void> onExportRelatorioOrdemPDF() async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();

    var isOrdemType = ordemViewModel.type == RelatorioOrdemType.ORDEM;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return (isOrdemType
              ? RelatorioOrdemPdfOrdemPage(ordemViewModel.relatorio!)
                  .build(imageBytes)
              : RelatorioOrdemPdfStatusPage(ordemViewModel.relatorio!)
                  .build(imageBytes));
        }));

    final name = isOrdemType
        ? "m2_relatorio_ordem_${ordemViewModel.relatorio!.ordem.id.toLowerCase()}${DateTime.now().toFileName()}.pdf"
        : "m2_relatorio_bitola_status_${ordemViewModel.status!.label.toLowerCase()}${DateTime.now().toFileName()}.pdf";

    await downloadPDF(name, '/relatorio/ordem/', await pdf.save());
  }

  Future<void> onSearchRelatorio() async {
    try {
      final ordem = FirestoreClient.ordens.data
          .map((e) => e.copyWith())
          .firstWhere((e) =>
              e.id.toCompare.contains(ordemViewModel.ordemEC.text.toCompare));
      ordemViewModel.ordem = ordem;
      ordemViewModelStream.update();
      onCreateRelatorio();
    } catch (e) {
      NotificationService.showNegative(
          'Não foi encontrado ordem com esse filtro',
          'Verifique o filtro informado');
    }
  }
}
