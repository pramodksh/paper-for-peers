class QuestionPaperYearModel {
  int year;
  List<QuestionPaperModel> questionPaperModels;

  QuestionPaperYearModel({
    required this.year,
    required this.questionPaperModels,
  });
}

class QuestionPaperModel {

  final int version;
  final String documentUrl;
  final String uploadedBy;
  final String? userProfilePhotoUrl;
  final String userEmail;
  final String userUid;

  const QuestionPaperModel({
    required this.version,
    required this.documentUrl,
    required this.uploadedBy,
    required this.userUid,
    required this.userProfilePhotoUrl,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'version': this.version,
      'documentUrl': this.documentUrl,
      'uploadedBy': this.uploadedBy,
      'userProfilePhotoUrl': this.userProfilePhotoUrl,
      'userEmail': this.userEmail,
      'userUid': this.userUid,
    };
  }

  factory QuestionPaperModel.fromFirestoreMap({required Map<String, dynamic> map, required int version}) {
    return QuestionPaperModel(
      version: version,
      documentUrl: map['document_url'] as String,
      uploadedBy: map['uploaded_by'] as String,
      userProfilePhotoUrl: map['user_profile_photo_url'] as String?,
      userEmail: map['user_email'] as String,
      userUid: map['user_uid'] as String,
    );
  }
}