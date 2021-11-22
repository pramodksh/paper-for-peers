import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

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

  static Map<String, dynamic> toFirestoreMap({required String documentUrl, required UserModel user}) {
    return {
      "uploaded_by": user.displayName,
      "document_url": documentUrl,
      "uploaded_on": DateTime.now(),
      "user_profile_photo_url": user.photoUrl,
      "user_email": user.email,
      "user_uid": user.uid,
    };
  }

}