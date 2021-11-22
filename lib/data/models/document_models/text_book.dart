import 'package:cloud_firestore/cloud_firestore.dart';

class TextBookSubjectModel {
  String subject;
  List<TextBookModel> textBookModels;


  TextBookSubjectModel({
    required this.subject,
    required this.textBookModels,
  });
}

class TextBookModel {
  final int version;
  final String url;
  final String uploadedBy;
  final DateTime uploadedOn;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;

  const TextBookModel({
    required this.version,
    required this.url,
    required this.uploadedBy,
    required this.uploadedOn,
    required this.userEmail,
    required this.userProfilePhotoUrl,
    required this.userUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'version': this.version,
      'url': this.url,
      'uploadedBy': this.uploadedBy,
      'uploadedOn': this.uploadedOn,
      'userProfilePhotoUrl': this.userProfilePhotoUrl,
      'userEmail': this.userEmail,
      'userUid': this.userUid,
    };
  }

  factory TextBookModel.fromFirestoreMap({required Map<String, dynamic> map, required int version}) {
    return TextBookModel(
      version: version,
      url: map['document_url'] as String,
      uploadedBy: map['uploaded_by'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
      userProfilePhotoUrl: map['user_profile_photo_url'] as String?,
      userEmail: map['user_email'] as String,
      userUid: map['user_uid'] as String,
    );
  }
}