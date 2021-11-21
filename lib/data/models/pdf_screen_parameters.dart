class PDFScreenSimpleBottomSheet {
  String? title;
  int? nVariant;
  String? uploadedBy;

  PDFScreenSimpleBottomSheet({this.nVariant, this.uploadedBy, this.title});

}

class PDFScreenSyllabusCopy {
  int? nVariant;
  String? uploadedBy;

  PDFScreenSyllabusCopy({this.uploadedBy, this.nVariant,});
}

class PDFScreenNotesBottomSheet {
  String? title;
  String? description;
  String? uploadedBy;
  double? rating;

  PDFScreenNotesBottomSheet({this.uploadedBy, this.description, this.title, this.rating});
}