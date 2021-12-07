import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart' as firebaseMessaging;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingRepository {
  final firebaseMessaging.FirebaseMessaging _fcm;

  FirebaseMessagingRepository({firebaseMessaging.FirebaseMessaging? fcm})
      : _fcm = fcm ?? firebaseMessaging.FirebaseMessaging.instance;

  Future<bool> sendNotification({
    required DocumentType documentType,
    required UserModel userModel,
    required String token,
    required Function getFireBaseKey,
    required String course,
    required int semester,
  }) async {
    String url = "https://fcm.googleapis.com/fcm/send";
    String _firebaseKey = await getFireBaseKey();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$_firebaseKey"
    };

    Map body = {
      "to": token,
      "notification": {
          "body": "${userModel.displayName} has uploaded a new ${DocumentType.JOURNAL.capitalized}",
          "priority": "high",
          "title": "New ${DocumentType.JOURNAL.capitalized} of $course $semester",
      },
      "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "document_type": DocumentType.JOURNAL.toUpper,
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