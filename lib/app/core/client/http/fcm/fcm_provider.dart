import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/services/push_notification_service.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:dio/dio.dart';

class FCMProvider {
  static Future<void> putToken() async {
    final token = await getDeviceToken();
    if (token != null && usuario.deviceTokens.contains(token)) return;
    usuario.deviceTokens.add(token!);
    FirestoreClient.usuarios.update(usuario);
  }

  static Future<void> postSend(Map<String, dynamic> body) async {
    try {
      await Dio().post('POST https://fcm.googleapis.com/v1/projects/pcp-m2/messages:send',
          options: Options(headers: {
            'Authorization':
                'key=AAAAT4lspio:APA91bFQF6Uvo9aSQaPF13wf59p0orEus4tIf0LEOh511Q7_cw7IvZwCB2FjzI_l8Jj3brMISWvJPHa4SvAg1EOzlyPHMwaOAUCUcYRKMKExmqza7L83cRB3weuon7tqq5orw3Wdbn-a',
            'Content-Type': 'application/json'
          }),
          data: body);
    } catch (_) {
      return;
    }
  }
}
