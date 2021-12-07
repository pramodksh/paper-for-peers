import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart' as firebaseMessaging;
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingRepository {
  final firebaseMessaging.FirebaseMessaging _fcm;

  FirebaseMessagingRepository({firebaseMessaging.FirebaseMessaging? fcm})
      : _fcm = fcm ?? firebaseMessaging.FirebaseMessaging.instance;

  Future<bool> sendNotification({
    // required Map<String, dynamic> messageMap,
    required UserModel userModel,
    required String token
  }) async {
    String url = "https://fcm.googleapis.com/fcm/send";

    // todo move to remote config
    String _firebaseKey ="AAAAEMnf14U:APA91bEPULQ8nChBfZ2jdtpO1rlB2NKyTusWFQUv_Q_4ysrgUcqW1BVmNC0jalx7kxLUbyIvjb5YOYmpRH2CUfnBfuTF8UeDuT3vxgie8oc2FuMp5wPqmbzozeZk7HvJaKZ5j20o3O6y";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$_firebaseKey"
    };


    Map body = {
      "to": token,
      "notification": {
          "body": "YOUR_MESSAGE",
          // "OrganizationId": "2",
          // "content_available": true,
          "priority": "high",
          // "subtitle": "Elementary School",
          "title": "YOUR_TITLE"
      },
      "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
    return true;
  }

}