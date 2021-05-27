// todo change names of classes

class PDFScreenQuestionPaper {
  String year;
  int nVariant;
  String uploadedBy;

  PDFScreenQuestionPaper({this.nVariant, this.uploadedBy, this.year});

}

class PDFScreenSyllabusCopy {
  String year;
  String uploadedBy;

  PDFScreenSyllabusCopy({this.uploadedBy, this.year});
}

class PDFScreenJournal {
  String subject;
  int nVariant;
  String uploadedBy;

  PDFScreenJournal({this.uploadedBy, this.nVariant, this.subject});
}

class PDFScreenNotes {
  String title;
  String description;
  String uploadedBy;
  double rating;

  PDFScreenNotes({this.uploadedBy, this.description, this.title, this.rating});
}