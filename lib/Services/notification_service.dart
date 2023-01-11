
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      // _fcm.requestPermission(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    FirebaseMessaging.instance.getInitialMessage().then(( message) {
      print('getInitialMessage data: ${message?.data}');

    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
      if (Platform.isAndroid) {
       var notification = PushNotificationMessage(
          title: message.data['notification']['title'],
          body: message.data['notification']['body'],
        );
      }
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');

    });
  }
}

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    required this.title,
    required this.body,
  });
}