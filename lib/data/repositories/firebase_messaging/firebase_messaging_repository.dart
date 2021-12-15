import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart' as firebaseMessaging;
import 'package:http/http.dart' as http;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/user_model/subject.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

class FirebaseMessagingRepository {
  final firebaseMessaging.FirebaseMessaging _fcm;

  FirebaseMessagingRepository({firebaseMessaging.FirebaseMessaging? fcm})
      : _fcm = fcm ?? firebaseMessaging.FirebaseMessaging.instance;

  Future<bool> sendNotificationIfTokenExists({
    required DocumentType documentType,
    required UserModel userModel,
    required String? token,
    required Function getFireBaseKey,
    required String course,
    required int semester,
    Subject? subject,
  }) async {
    if (token == null) return true;

    String url = "https://fcm.googleapis.com/fcm/send";
    String _firebaseKey = await getFireBaseKey();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$_firebaseKey"
    };

    Map body = {
      "to": token,
      "notification": {
          "body": "${userModel.displayName} has uploaded a new ${documentType.capitalized}",
          "priority": "high",
          "title": "New ${documentType.capitalized} of ${course.toUpperCase()} $semester ${subject != null ? subject.label : ""}",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "document_type": documentType.toUpper,
          "type": "UPLOAD",
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