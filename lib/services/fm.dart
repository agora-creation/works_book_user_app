import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:works_book_user_app/models/user.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/user.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';

const key =
    'AAAAzKh2Ww4:APA91bGoEG1VVrDNjpLzij6YhLAflNrAgBPJq6UNWeOKKjGblCwT5t8QYpedZzaleTRVe6HWOS69NB81srKzt0SaFl02r-eAHY_mFnovti5sKO-zgbeBNqzlq4R7bKinoOpinGG21aCZ';

class FmService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();
  UserService userService = UserService();
  UserInApplyService userInApplyService = UserInApplyService();

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        _handleMessage(message);
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    messaging.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initNotifications() async {
    await messaging.requestPermission();
    await initPushNotifications();
    await initLocalNotifications();
  }

  Future<String?> getToken() async {
    return await messaging.getToken();
  }

  void send({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$key',
        },
        body: jsonEncode({
          'to': token,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
          },
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future sendToAdmin({
    required String? groupId,
    required String? sectionId,
    required String title,
    required String body,
  }) async {
    List<UserInApplyModel> userInApples = await userInApplyService.selectList(
      groupId: groupId,
      sectionId: sectionId,
    );
    if (userInApples.isEmpty) return;
    List<String> userIds = [];
    for (UserInApplyModel userInApply in userInApples) {
      if (userInApply.admin) {
        userIds.add(userInApply.userId);
      }
    }
    List<UserModel> users = await userService.selectList(
      userIds: userIds,
    );
    if (users.isEmpty) return;
    for (UserModel user in users) {
      send(
        token: user.token,
        title: title,
        body: body,
      );
    }
  }
}

Future _handleBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}
