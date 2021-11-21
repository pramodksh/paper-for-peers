import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {

  String url;
  String title;
  String description;
  DateTime uploadedOn;
  String uploadedBy;
  double rating;

  NotesModel({
    required this.url,
    required this.title,
    required this.description,
    required this.uploadedOn,
    required this.uploadedBy,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': this.url,
      'title': this.title,
      'description': this.description,
      'uploadedOn': this.uploadedOn,
      'uploadedBy': this.uploadedBy,
      'rating': this.rating,
    };
  }

  factory NotesModel.fromFirestoreMap(Map<String, dynamic> map) {
    return NotesModel(
      url: map['url'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      uploadedOn: (map['uploaded_on'] as Timestamp).toDate(),
      uploadedBy: map['uploaded_by'] as String,
      rating: map['rating'] as double,
    );
  }
}