part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

class JournalFetch extends JournalEvent {

  final String course;
  final int semester;
  final String subject;

  @override
  List<Object?> get props => [course, semester, subject];

  const JournalFetch({
    required this.course,
    required this.semester,
    required this.subject,
  });

  @override
  String toString() {
    return 'JournalFetch{course: $course, semester: $semester, subject: $subject}';
  }
}