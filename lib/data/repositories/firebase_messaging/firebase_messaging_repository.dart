import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart' as firebaseMessaging;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:http/http.dart' as http;

extension ToSubjectExtension on String {

  String toTitleCase() {

    if (this.length <= 1) {
      return this.toUpperCase();
    }
    final List<String> words = this.split(' ');

    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(' ');
  }

  String toSubject() {
    return this.replaceAll("_", " ").toTitleCase();
  }
}

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
    String? subject,
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
          "body": "${userModel.displayName} has uploaded a new ${documentType.capitalized}",
          "priority": "high",
          "title": "New ${documentType.capitalized} of ${course.toUpperCase()} $semester ${subject?.toSubject() ?? ""}",
      },
      "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "document_type": documentType.toUpper,
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