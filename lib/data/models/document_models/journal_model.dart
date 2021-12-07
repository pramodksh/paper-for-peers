import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class JournalSubjectModel {
  String subject;
  List<JournalModel> journalModels;

  JournalSubjectModel({
    required this.subject,
    required this.journalModels,
  });
}

class JournalModel {
  final int version;
  final String documentUrl;
  final String uploadedBy;
  final DateTime uploadedOn;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;

  static final String documentUrlFieldKey = "document_url";

  const JournalModel({
    required this.version,
    required this.documentUrl,
    required this.uploadedBy,
    required this.uploadedOn,
    required this.userEmail,
    required this.userProfilePhotoUrl,
    required this.userUid,
  });

  factory JournalModel.fromFirestoreMap({required Map<String, dynamic> map, required int version}) {
    return JournalModel(
      version: version,
      documentUrl: map['document_url'] as String,
      uploadedBy: map['uploaded_by'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
      userEmail: map["user_email"] as String,
      userProfilePhotoUrl: map["user_profile_photo_url"] as String?,
      userUid: map["user_uid"] as String,
    );
  }

  static Map<String, dynamic> toFirestoreMap({required UserModel user, String? documentUrl}) {
    return {
      "uploaded_by": user.displayName,
      "user_uid": user.uid,
      "user_profile_photo_url": user.photoUrl,
      "user_email": user.email,
      "document_url": documentUrl,
      "uploaded_on": DateTime.now(),
    };
  }
}