class Subject {
  final String label;
  final String value;
  final bool isShowJournal;

  const Subject({
    required this.label,
    required this.value,
    required this.isShowJournal,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': this.label,
      'value': this.value,
      'isShowJournal': this.isShowJournal,
    };
  }

  factory Subject.fromFirestoreMap({required Map<String, dynamic> subjectData, required String id}) {
    return Subject(
        label: subjectData["subject_title"] ?? id,
        value: id,
        isShowJournal: subjectData["isShowJournal"] ?? false
    );
  }
}