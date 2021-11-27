import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class NotesModel {

  final String noteId;
  final String documentUrl;
  final String title;
  final String description;
  final DateTime uploadedOn;
  final String uploadedBy;
  final double rating;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;

  NotesModel({
    required this.noteId,
    required this.documentUrl,
    required this.title,
    required this.description,
    required this.uploadedOn,
    required this.uploadedBy,
    required this.rating,
    required this.userEmail,
    required this.userProfilePhotoUrl,
    required this.userUid,
  });

  static final String documentUrlFieldKey = "document_url";

  static Map<String, dynamic> toFirestoreMap({
    required String? documentUrl, required UserModel user,
    required String title, required String description,
  }) {
    return {
      documentUrlFieldKey: documentUrl,
      "uploaded_by": user.displayName,
      "title": title,
      "description": description,
      "uploaded_on": DateTime.now(),
      "user_email": user.email,
      "user_profile_photo_url": user.photoUrl,
      "user_uid": user.uid,
    };
  }

  factory NotesModel.fromFirestoreMap({required Map<String, dynamic> map, required String notesId, required double avgRating}) {
    return NotesModel(
      noteId: notesId,
      documentUrl: map[documentUrlFieldKey] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
      uploadedBy: map['uploaded_by'] as String,
      rating: avgRating,
      userEmail: map["user_email"] as String,
      userProfilePhotoUrl: map["user_profile_photo_url"] as String?,
      userUid: map['user_uid'] as String,
    );
  }
}