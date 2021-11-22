import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class SyllabusCopyModel {

  final String documentUrl;
  final int version;
  final String uploadedBy;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;
  final DateTime uploadedOn;

  const SyllabusCopyModel({
    required this.documentUrl,
    required this.version,
    required this.uploadedBy,
    required this.userUid,
    required this.userProfilePhotoUrl,
    required this.userEmail,
    required this.uploadedOn,
  });

  factory SyllabusCopyModel.fromFirestoreMap({required Map<String, dynamic> map, required int version}) {
    return SyllabusCopyModel(
      documentUrl: map['document_url'] as String,
      version: version,
      uploadedBy: map['uploaded_by'] as String,
      userUid: map['user_uid'] as String,
      userProfilePhotoUrl: map['user_profile_photo_url'] as String?,
      userEmail: map['user_email'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestoreMap({required String documentUrl, required UserModel user}) {
    return {
      "uploaded_by": user.displayName,
      "document_url": documentUrl,
      "user_uid": user.uid,
      "user_profile_photo_url": user.photoUrl,
      "user_email": user.email,
      "uploaded_on": DateTime.now(),
    };
  }

}