import 'dart:typed_data';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/pdf_divisor.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// class RelatorioPedidoPdfPage {
//   final RelatorioPedidoModel? model;
//   final List<PedidoModel> pedidos;
//   RelatorioPedidoPdfPage({this.model, required this.pedidos});

//   pw.Widget build(Uint8List bytes) => pw.Column(
//         children: [
//           if (model != null) ...[
//             pw.Image(pw.MemoryImage(bytes), width: 60, height: 60),
//             pw.SizedBox(height: 24),
//             pw.Text('RELATÓRIO DE PEDIDOS POR CLIENTE E STATUS'),
//             pw.SizedBox(height: 16),
//             _itemHeader(model!),
//             pw.SizedBox(height: 24),
//           ],
//           for (final pedido in pedidos) _itemRelatorio(pedido),
//         ],
//       );

class RelatorioPedidoPdfPage {
  final RelatorioPedidoModel model;
  RelatorioPedidoPdfPage(this.model);

  pw.Page build(Uint8List bytes) => pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        build: (pw.Context context) => [
          pw.Image(pw.MemoryImage(bytes), width: 60, height: 60),
          pw.SizedBox(height: 24),
          pw.Text('RELATÓRIO DE PEDIDOS POR CLIENTE E STATUS'),
          pw.SizedBox(height: 16),
          _itemHeader(model),
          pw.SizedBox(height: 24),
          for (final pedido in model.pedidos) _itemRelatorio(pedido),
        ],
      );

  pw.Widget _itemRelatorio(PedidoModel pedido) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(Colors.white.value),
        border: pw.Border.all(
            color: PdfColor.fromInt(Colors.grey[700]!.value), width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  pedido.localizador,
                  style: pw.TextStyle(
                      fontSize: 14,
                      font: pw.Font.times(),
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(AppColors.black.value)),
                ),
              ),
              pw.Text(
                  DateFormat("'Criado 'dd/MM/yyyy' às 'HH:mm")
                      .format(pedido.createdAt),
                  style: pw.TextStyle(
                      fontSize: 11,
                      font: pw.Font.times(),
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColor.fromInt(AppColors.black.value))),
            ],
          ),
          pw.SizedBox(height: 8),
          _itemInfo('Cliente', pedido.cliente.nome),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo('Descrição', pedido.obra.descricao),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo(
              'Data de Entrega',
              pedido.deliveryAt != null
                  ? pedido.deliveryAt!.text()
                  : 'Não definida'),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo('Tipo', pedido.tipo.label),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo('Bitolas (mm)',
              '${pedido.produtos.map((e) => e.produto.descricaoReplaced).join(', ')}.'),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          for (final produto in pedido.produtos)
            pw.Column(
              children: [
                _itemInfo(
                    produto.produto.descricaoReplaced, '${produto.qtde} kg'),
                PdfDivisor.build(
                  color: Colors.grey[200],
                ),
                if (produto.produto.id != pedido.produtos.last.produto.id)
                  PdfDivisor.build(
                    color: Colors.grey[200],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  pw.Widget _itemHeader(RelatorioPedidoModel relatorio) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(Colors.white.value),
        border: pw.Border.all(
            color: PdfColor.fromInt(Colors.grey[700]!.value), width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  relatorio.cliente?.nome ?? 'Todos os clientes',
                  style: pw.TextStyle(
                      fontSize: 14,
                      font: pw.Font.times(),
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(AppColors.black.value)),
                ),
              ),
              pw.Text(relatorio.status?.label ?? 'Todos os status',
                  style: pw.TextStyle(
                      fontSize: 11,
                      font: pw.Font.times(),
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColor.fromInt(AppColors.black.value))),
            ],
          ),
          pw.SizedBox(height: 8),
          _itemInfo(
              'Data Criação Relatório',
              DateFormat("dd/MM/yyyy' ás 'HH:mm")
                  .format(relatorio.createdAt)
                  .toString()),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo(
              'Quantidade de Pedidos', relatorio.pedidos.length.toString()),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
          _itemInfo('Quantidade Total de Bitolas',
              "${relatorio.pedidos.fold<double>(0, (a, b) => a + (b.produtos.fold(0, (c, d) => c + d.qtde))).toStringAsFixed(2)} kg"),
          PdfDivisor.build(
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  pw.Widget _itemInfo(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(label,
                style: pw.TextStyle(
                    font: pw.Font.times(),
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(Colors.grey[800]!.value))),
          ),
          pw.Expanded(
              flex: 2,
              child: pw.Text(
                value,
                style: pw.TextStyle(
                    font: pw.Font.times(),
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColor.fromInt(Colors.grey[800]!.value)),
                textAlign: pw.TextAlign.end,
              ))
        ],
      ),
    );
  }
}
