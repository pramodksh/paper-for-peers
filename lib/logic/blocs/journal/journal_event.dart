part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
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