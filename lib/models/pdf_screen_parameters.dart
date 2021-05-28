// todo change names of classes

class PDFScreenSimpleBottomSheet {
  String title;
  int nVariant;
  String uploadedBy;

  PDFScreenSimpleBottomSheet({this.nVariant, this.uploadedBy, this.title});

}

class PDFScreenSyllabusCopy {
  String year;
  String uploadedBy;

  PDFScreenSyllabusCopy({this.uploadedBy, this.year});
}

// todo delete
// class PDFScreenJournal {
//   String subject;
//   int nVariant;
//   String uploadedBy;
//
//   PDFScreenJournal({this.uploadedBy, this.nVariant, this.subject});
// }

class PDFScreenNotes {
  String title;
  String description;
  String uploadedBy;
  double rating;

  PDFScreenNotes({this.uploadedBy, this.description, this.title, this.rating});
}