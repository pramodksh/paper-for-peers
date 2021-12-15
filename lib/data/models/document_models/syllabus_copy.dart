import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class SyllabusCopyModel {

  final String id;
  final String documentUrl;
  final String uploadedBy;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;
  final DateTime uploadedOn;

  static final String documentUrlFieldKey = "document_url";

  const SyllabusCopyModel({
    required this.id,
    required this.documentUrl,
    required this.uploadedBy,
    required this.userUid,
    required this.userProfilePhotoUrl,
    required this.userEmail,
    required this.uploadedOn,
  });

  factory SyllabusCopyModel.fromFirestoreMap({required Map<String, dynamic> map, required String id}) {
    return SyllabusCopyModel(
      id: id,
      documentUrl: map['document_url'] as String,
      uploadedBy: map['uploaded_by'] as String,
      userUid: map['user_uid'] as String,
      userProfilePhotoUrl: map['user_profile_photo_url'] as String?,
      userEmail: map['user_email'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestoreMap({String? documentUrl, required UserModel user}) {
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