import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';


final FirebaseMessaging fcm = FirebaseMessaging();
final Firestore _db = Firestore.instance;
//final FirebaseAuth auth = FirebaseAuth.instance;
StreamSubscription iosSubscription;


//Initialize Firebase cloud messaging
Future initialiseFCM() async {
  //Listens to order collection changes
  fcm.subscribeToTopic('order');

  if (Platform.isIOS) {
    iosSubscription = fcm.onIosSettingsRegistered.listen((data) { 
      _saveDeviceToken();
    });
    fcm.requestNotificationPermissions(IosNotificationSettings());
  } else {
    _saveDeviceToken();
  }

  fcm.configure(
    onMessage: (Map<String, dynamic> message) async {
    },
    onLaunch: (Map<String, dynamic> message) async {
    },
    onResume: (Map<String, dynamic> message) async {
    },
  );
}

Future _saveDeviceToken() async {
  //get the uid of the current user
  final FirebaseUser user = await auth.currentUser();
  if (user != null) {
    final uid = user.uid;
    //print('Debug ----->' + uid);
    //Get the token of the users device
    //( this token is used like an adress to send on the push notifications)
    String fcmToken = await fcm.getToken();

    //Save the token into firebase for later use
    if (fcmToken != null) {
      var tokenRef = _db
          .collection('user')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);
      await tokenRef.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }
}
