import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_buddy/model/chat_notification.dart';
import 'package:my_buddy/utills/shared_pre.dart';
import 'package:http/http.dart' as http;

const String channelName = 'MyBuddy';
const String channelId = "com.example.my_buddy";
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  channelId, channelName,
  importance: Importance.max,
  //sound: RawResourceAndroidNotificationSound('notification'),
);

class FBNotification {
  static final FBNotification instance = FBNotification._internal();

  factory FBNotification() => instance;

  FBNotification._internal();

  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) {
        //FBNotification.showNotification(title, body);
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) {
      if (notification.payload?.isNotEmpty ?? false) {
        _payloadParse(notification.payload!);
      }
    });
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    try {
      FirebaseMessaging.instance.getToken().then((token) {
        SharedPre.instance.setValue(SharedPre.deviceToken, token ?? '');
        debugPrint('_____ onToken $token');
      });
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        SharedPre.instance.setValue(SharedPre.deviceToken, token);
        debugPrint('_____ onTokenRefresh $token');
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('___ data ${message.data.toString()}');
      debugPrint(
          '___ notification ${message.notification?.toMap().toString()}');
      String title = message.notification?.title ?? '';
      String body = message.notification?.body ?? '';
      if (title.isNotEmpty && body.isNotEmpty) {
        showNotification(
          title,
          body,
          payload: message.data.toString(),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      if (msg.data.containsKey('notification_type')) {
        Future.delayed(const Duration(seconds: 1), () {
          actionNotification(
            data: msg.data,
            type: msg.data['notification_type'],
          );
        });
      }
    });
  }

  void _payloadParse(String payload) {
    /*try {
      var kv = payload.substring(0, payload.length - 1).substring(1).split(",");
      final Map<String, String> pairs = {};
      for (int i = 0; i < kv.length; i++) {
        var thisKV = kv[i].split(":");
        pairs[thisKV[0].trim()] = thisKV[1].trim();
      }
      final data = Payload.fromJson(jsonDecode(json.encode(pairs)));
      actionNotification(
        data: data.toJson(),
        type: data.notificationType!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }*/
  }

  static void actionNotification({
    required String type,
    required Map<String, dynamic> data,
  }) {
    /*switch (data['notification_type'].toString()) {
      case NotificationType.orderRating:
        if (data.containsKey('order_id')) {
          var find = AppBaseController();
          find.gotoPastOrderDetails(orderId: data['order_id'].toString());
        }
        break;
      default:
        break;
    }*/
  }

  void showNotification(String title, String body, {String? payload}) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId, channelName,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'app_icon',
        playSound: true,
        showWhen: true,
        enableVibration: true,
        channelShowBadge: true,
        visibility: NotificationVisibility.public,
        //sound: RawResourceAndroidNotificationSound('notification'),
        autoCancel: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    await localNotificationsPlugin.show(
      Random().nextInt(4),
      title,
      body,
      platformChannelSpecifics,
      payload: payload ?? '',
    );
  }

  Future<void> sendNotification({
    required ChatNotification notification,
  }) async {
    if (notification.token.isNotEmpty) {
      String url = "https://fcm.googleapis.com/fcm/send";
      final body = jsonEncode({
        "to": notification.token,
        "data": "[{}]",
        "notification": {
          "title": notification.title,
          "body": notification.body,
        },
        "priority": "high",
      });
      final response = await http.post(Uri.parse(url), body: body, headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAArYkNTyk:APA91bHdUToMlAbH0W8TFXzdLu8RUuCWZZMdmassoCg0RLntXlubkq2hflgM9o_sVYLUj2yPdoccZYgM18_gglXhAvfWz4Nqn9sUbOJKpHFRMQVQ31gQG_XiUAfqOcmeeyFSqAzESq5J",
      });
      debugPrint('___ sendNotification ${response.body}');
      debugPrint('___ sendNotification statusCode ${response.statusCode}');
    }
  }
}
