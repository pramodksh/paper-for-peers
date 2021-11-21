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
}