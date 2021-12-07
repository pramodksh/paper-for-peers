import 'package:firebase_messaging/firebase_messaging.dart' as firebaseMessaging;

class FirebaseMessagingRepository {
  final firebaseMessaging.FirebaseMessaging _fcm;

  FirebaseMessagingRepository({firebaseMessaging.FirebaseMessaging? fcm})
      : _fcm = fcm ?? firebaseMessaging.FirebaseMessaging.instance;
}