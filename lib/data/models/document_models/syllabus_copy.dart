import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'url': this.documentUrl,
      'version': this.version,
      'uploadedBy': this.uploadedBy,
    };
  }

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
}