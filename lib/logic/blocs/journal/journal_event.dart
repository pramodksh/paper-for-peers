part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

class JournalAdd extends JournalEvent {

  final List<JournalSubjectModel> journalSubjects;
  final String uploadedBy;
  final String course;
  final String subject;
  final int semester;
  final UserModel user;

  @override
  List<Object?> get props => [uploadedBy, course, subject, semester, user, journalSubjects];

  const JournalAdd({
    required this.journalSubjects,
    required this.uploadedBy,
    required this.course,
    required this.subject,
    required this.semester,
    required this.user,
  });

}

class JournalFetch extends JournalEvent {

  final String course;
  final int semester;

  @override
  List<Object?> get props => [course, semester];

  const JournalFetch({
    required this.course,
    required this.semester,
  });

  @override
  String toString() {
    return 'JournalFetch{course: $course, semester: $semester,}';
  }
}

class JournalReportAdd extends JournalEvent {
  final List<String> reportValues;
  final List<JournalSubjectModel> journalSubjects;
  final String uploadedBy;
  final String course;
  final String subject;
  final int semester;
  final int nVersion;
  final UserModel user;

  @override
  List<Object?> get props => [uploadedBy, course, subject, semester, nVersion, user, journalSubjects, reportValues];

  const JournalReportAdd({
    required this.reportValues,
    required this.journalSubjects,
    required this.uploadedBy,
    required this.course,
    required this.subject,
    required this.semester,
    required this.nVersion,
    required this.user,
  });

  @override
  String toString() {
    return 'JournalReportAdd{reportValues: $reportValues, journalSubjects: $journalSubjects, uploadedBy: $uploadedBy, course: $course, subject: $subject, semester: $semester, nVersion: $nVersion, user: $user}';
  }
}