class PDFScreenSimpleBottomSheet {
  final String? title;
  final int? nVariant;
  final String? uploadedBy;
  final String? profilePhotoUrl;


  PDFScreenSimpleBottomSheet({required this.nVariant, required this.uploadedBy, required this.title, required this.profilePhotoUrl});

}

class PDFScreenSyllabusCopy {
  final int? nVariant;
  final String? uploadedBy;
  final String? profilePhotoUrl;

  PDFScreenSyllabusCopy({required this.uploadedBy, required this.nVariant, required this.profilePhotoUrl});
}

class PDFScreenNotesBottomSheet {
  final String? title;
  final String? description;
  final String? uploadedBy;
  final double? rating;
  final String? profilePhotoUrl;

  PDFScreenNotesBottomSheet({required this.uploadedBy, required this.description, required this.title, required this.rating, required this.profilePhotoUrl});
}