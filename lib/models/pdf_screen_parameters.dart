// todo change names of classes

class PDFScreenSimpleBottomSheet {
  String title;
  int nVariant;
  String uploadedBy;

  PDFScreenSimpleBottomSheet({this.nVariant, this.uploadedBy, this.title});

}

class PDFScreenSyllabusCopy {
  int nVariant;
  int totalVariants;
  String uploadedBy;

  PDFScreenSyllabusCopy({this.uploadedBy, this.nVariant, this.totalVariants}) {
    assert(totalVariants <= 2);
  }
}

// todo delete
// class PDFScreenJournal {
//   String subject;
//   int nVariant;
//   String uploadedBy;
//
//   PDFScreenJournal({this.uploadedBy, this.nVariant, this.subject});
// }

class PDFScreenNotesBottomSheet {
  String title;
  String description;
  String uploadedBy;
  double rating;

  PDFScreenNotesBottomSheet({this.uploadedBy, this.description, this.title, this.rating});
}