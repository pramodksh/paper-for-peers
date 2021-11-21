class NotesModel {
  String title;
  String description;
  DateTime uploadedOn;
  String uploadedBy;
  double rating;

  NotesModel({
    required this.title,
    required this.description,
    required this.uploadedOn,
    required this.uploadedBy,
    required this.rating,
  });
}