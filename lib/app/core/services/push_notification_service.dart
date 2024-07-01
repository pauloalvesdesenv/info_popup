import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

String? urlAfterAppOen;

final _menssaging = FirebaseMessaging.instance;

String? deviceToken;

Future<void> initFirebaseMessaging() async {
  await _menssaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  deviceToken = await getDeviceToken();
  await onOpenNotification();
  await setupFlutterNotifications();
  // await _menssaging.subscribeToTopic(kDebugMode ? 'debug' : 'release');
  // FirebaseMessaging.onBackgroundMessage(
  //     (message) async => showFlutterNotification(message));
  FirebaseMessaging.onMessage.listen((message) {
    showFlutterNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleClickNotification(jsonEncode(message.data));
  });
}

Future<String?> getDeviceToken() async {
  if (kIsWeb) {
    return await _menssaging.getToken(
        vapidKey: kIsWeb
            ? 'BOp4Fx_efcGMjerqT1aNM-VwixbtTg-3k_XkESpq3961o59HCh-743r2Iqf_bQ04uUwd39VZszhngi8GhR9CjNA'
            : null);
  } else if (Platform.isAndroid) {
    return await _menssaging.getToken();
  } else {
    try {
      final apn = await _menssaging.getAPNSToken();
      if (apn == null) throw Exception();
      return await _menssaging.getToken();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
      return await getDeviceToken();
    }
  }
}

Future<void> setupFlutterNotifications() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: IOSInitializationSettings()),
    onSelectNotification: selectNotification,
  );
}

void showFlutterNotification(RemoteMessage message) {
  try {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? ios = message.notification?.apple;

    if ((notification == null || (android != null || ios != null))) {
      flutterLocalNotificationsPlugin.show(
        math.Random().nextInt(1000000000),
        notification!.title,
        notification.body,
        NotificationDetails(
          android: android == null
              ? null
              : AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: 'ic_notification',
                ),
          iOS: ios == null
              ? null
              : const IOSNotificationDetails(
                  presentSound: true,
                  presentAlert: true,
                  presentBadge: true,
                  attachments: <IOSNotificationAttachment>[],
                ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  } catch (_) {}
}

Future<void> onOpenNotification() async {
  try {
    final message = await _menssaging.getInitialMessage();
    if (message == null) return;
    _handleClickNotification(jsonEncode(message.data));
  } catch (_) {}
}

Future selectNotificationIOS(
    int id, String? title, String? body, String? payload) async {
  if (payload == null) return;
}

Future selectNotification(String? payload) async {
  if (payload == null) return;
  _handleClickNotification(payload);
}

void _handleClickNotification(String payload) {
  final data = jsonDecode(payload);
}
