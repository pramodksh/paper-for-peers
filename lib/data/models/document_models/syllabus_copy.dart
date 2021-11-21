class SyllabusCopyModel {

  final String url;
  final int version;
  final String uploadedBy;

  const SyllabusCopyModel({
    required this.url,
    required this.version,
    required this.uploadedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': this.url,
      'version': this.version,
      'uploadedBy': this.uploadedBy,
    };
  }

  factory SyllabusCopyModel.fromFirestoreMap({required Map<String, dynamic> map, required int version}) {
    return SyllabusCopyModel(
      url: map['url'] as String,
      version: version,
      uploadedBy: map['uploaded_by'] as String,
    );
  }
}