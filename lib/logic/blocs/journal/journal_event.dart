part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();
}

// class JournalAdd extends JournalEvent {
//   final String uploadedBy;
//   final int year;
//   final String course;
//   final String subject;
//   final int semester;
//   final int nVersion;
//   final UserModel user;
//
//
//
// }

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