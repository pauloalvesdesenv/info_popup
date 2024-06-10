import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/services/push_notification_service.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class FCMProvider {
  static Future<void> putToken() async {
    final token = await getDeviceToken();
    if (token != null && usuario.deviceTokens.contains(token)) return;
    usuario.deviceTokens.add(token!);
    FirestoreClient.usuarios.update(usuario);
  }

  static Future<void> postSend(Map<String, dynamic> body) async {
    try {
      await Dio().post(
          'https://fcm.googleapis.com/v1/projects/pcp-m2/messages:send',
          options: Options(headers: {
            'Authorization': 'Bearer ${await _getAccessToken()}',
            'Content-Type': 'application/json'
          }),
          data: body);

    } catch (_) {

      return;
    }
  }

  static Future<String> _getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "pcp-m2",
      "private_key_id": "48dd9a1849c882a9c5a7859de8a9ac7b5f39cd73",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCS4nIyInIrpg4r\nDgzmsUeiVbedXbjKrfF1ZRX5gfUtKP46ST8Yx1sve4Yj5eFmdtdERlMdF+7uPp4K\nCJtiVrna5E6ASa51ut9LZWXTNDmlKPReil2z93FWDTZxIG8t7tGhWrJfZt1WzLDE\ngNyMe4EPr74RudjMx8nLhg0ocoSSD1ygdAEr10tXkeHX4XgS7w0ny339ddHHSAm+\ntrbOpQtGA75/GbOx/qpRzMjLfbak2Mnxb+4ftovHs4aMmrWsGVWQCy4GzK6M00F7\n46zGqi/RMrUhuf7T7gmOG9z63gQl0H1nhjHkmjldEinuuYCG93HEi98nawiacqJA\nmYR3kfnnAgMBAAECggEALOy2ia/wZHo+9hsvhfVt1/BInwh1xwPJiKLYxD3jy6Kw\nkwopEr6SnKS2o88hD/JEJ90seYcC7HpZYu87+ylUYecXPXSLt/Vma0yBhsX/5Yxv\npWTDgRIq52tWHeaSKqXTFvtC+BvhkbU8UXWqPwtdL3uMciZ58TQf+7At4ROZiYRT\nkTihZHqy7YLAmMKxbeY436+b2c6a1tTC+pc2/dwcq2Tss1LgEA773rwavlq41qzG\nw4QB1EslrKU/c4NN9lZaffJXFn/SWx+XoXAZwEFhavoIfc24k8mAvAYrFKoGEWds\n+G69KD1cL9eyyCat+qXI9+DhzVHE9HxgwwkIZC59VQKBgQDKcK4mmnxZNJ6Wx2bS\nlRH9TCmZgG3cbRintl/eoSr8SMON2u43oUFAyGVId5SR/XrJN5aH+IafaRDATxx9\n33mDQITwKwR7RwepXbHJHAwtS1gGdsgusM+DralcIsodJSzV88EUDxTFbgvBbRV2\nACZvcGG/tg4IjQRtHh/07bStewKBgQC5vvjChh128g72I7qCIeFyDAsV0DaFkD1R\ntLvmBwhy1L6VMFSke16G1PsAJXRbe8a8qzqKq2llVp9mxPBVFtEYsogmiidTK508\ni5mFnKtCFr+bYNw8qeJKuY17X6JNc190mPvUL9+nMjypCwta7QsPk8M2pxEe58Ts\nZs/TyYG7hQKBgQC9E89kmOfJfb8dvvJHfxoFRcyY5X424eKkSk9ypX97kQ6tAK18\nYe2Lb2BB9gZa8LBtHbFIIBTE8SHHLFzFKCPbNji0BMmzxpzeUHeMCdlJuNRnfSvt\niBDZwSqstoWmASHGV1ufu5I/8E+kgpkH1I4RiZqSr5yd2fAnZnqcjiQx3wKBgQC1\ns5lJQUUljFkSc5UJo/cUR6+4YPxU3+r8OJ7uwMaE/pSJAMRsOrsXjtUTKZCPxZ9+\nBMq5yEDL/1bjg5fOxQk67bq+aLtbYvjnt3AxAjeN6Q77Al+vgEh77NP4cm8k8M3a\nE6WVxlc1CbHJc6JiCiydymBW4EuhPfynfVOkzCR6uQKBgAQoTg4ksQOuAC6HMU29\nloGeINmo/OsleJ5HmO25Z6gftQux96pE0dZVHIzZD+BDpVsszB3F3wvQMWUAY2by\nlGGiGw3EQ6nVXJek53tt2CDVkzaqSK8VqWvBzSiBOucpZ+2S5BNt/HCsinCkTaIm\n8Eveo5ChYR/0K8gMgy+Gj9B7\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-e43q4@pcp-m2.iam.gserviceaccount.com",
      "client_id": "105843347493626791938",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-e43q4%40pcp-m2.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }
}
