import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart' as firebaseRemoteConfig;
import 'package:papers_for_peers/config/firebase_remote_config_configuration.dart';

class FirebaseRemoteConfigRepository {

  firebaseRemoteConfig.RemoteConfig _remoteConfig;

  FirebaseRemoteConfigRepository({firebaseRemoteConfig.RemoteConfig? remoteConfig}) :
      _remoteConfig = remoteConfig ?? firebaseRemoteConfig.RemoteConfig.instance {
    _remoteConfig.setConfigSettings(firebaseRemoteConfig.RemoteConfigSettings(
      fetchTimeout: Duration(minutes: 1),
      minimumFetchInterval: Duration.zero,
    ));
  }

  Future<int> getMaxSyllabusCopy() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.MAX_SYLLABUS_COPY).asInt();
  }

  Future<int> getMaxNotes() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.MAX_NOTES).asInt();
  }

  Future<int> getMaxTextBooks() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.MAX_TEXT_BOOKS).asInt();
  }

  Future<int> getMaxJournals() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.MAX_JOURNALS).asInt();
  }

  Future<int> getMaxQuestionPapers() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.MAX_QUESTION_PAPERS).asInt();
  }

  Future<String> getFirebaseKey() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.FIREBASE_KEY).asString();
  }

  Future<String> getRazorPayApiKey() async {

    bool updated = await _remoteConfig.fetchAndActivate();
    if (updated) {
      print("UPDATED");
      return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.RAZORPAY_API_KEY).asString();
    } else {
      print("NOT UPDATED");
      return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.RAZORPAY_API_KEY).asString();
    }
  }

  Future<int> getMaxSizeOfJournal() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.SIZE_JOURNAL).asInt();
  }

  Future<int> getMaxSizeOfQuestionPaper() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.SIZE_QUESTION_PAPER).asInt();
  }

  Future<int> getMaxSizeOfNotes() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.SIZE_NOTES).asInt();
  }

  Future<int> getMaxSizeOfSyllabusCopy() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.SIZE_SYLLABUS_COPY).asInt();
  }

  Future<int> getMaxSizeOfTextBook() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getValue(FirebaseRemoteConfigConfiguration.SIZE_TEXT_BOOK).asInt();
  }

  Future<List<String>> getReportsAndWeights() async {
    await _remoteConfig.fetchAndActivate();
    Map<String, dynamic> reportWeights = json.decode(_remoteConfig.getValue(FirebaseRemoteConfigConfiguration.REPORT_WEIGHTS).asString());
    return reportWeights.keys.toList();
  }

}