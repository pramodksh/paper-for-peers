import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {

  final String url;
  final String title;
  final String description;
  final DateTime uploadedOn;
  final String uploadedBy;
  final double rating;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;

  NotesModel({
    required this.url,
    required this.title,
    required this.description,
    required this.uploadedOn,
    required this.uploadedBy,
    required this.rating,
    required this.userEmail,
    required this.userProfilePhotoUrl,
    required this.userUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'document_url': this.url,
      'title': this.title,
      'description': this.description,
      'uploadedOn': this.uploadedOn,
      'uploadedBy': this.uploadedBy,
      'rating': this.rating,
    };
  }

  factory NotesModel.fromFirestoreMap(Map<String, dynamic> map) {
    return NotesModel(
      url: map['document_url'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
      uploadedBy: map['uploaded_by'] as String,
      rating: map['rating'] as double,
      userEmail: map["user_email"] as String,
      userProfilePhotoUrl: map["user_profile_photo_url"] as String?,
      userUid: map['user_uid'] as String,
    );
  }
}