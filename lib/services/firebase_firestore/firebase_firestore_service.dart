 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class FirebaseFireStoreService {
  static final String usersCollectionLabel = "users";
  // static String documentsCollectionLabel = "";

  // static final String coursesCollectionLabel = "courses";
  static final String coursesCollectionLabel = "courses_new";
  static final String semestersCollectionLabel = "semesters";
  static final String syllabusCopyCollectionLabel = "syllabus_copy";
  static final String subjectsCollectionLabel = "subjects";
  static final String journalCollectionLabel = "journal";
  static final String notesCollectionLabel = "notes";
  static final String questionPaperCollectionLabel = "question_paper";


  static final String yearsCollectionLabel = "years";
  static final String versionsCollectionLabel = "versions";

  CollectionReference usersCollection = FirebaseFirestore.instance.collection(usersCollectionLabel);
  CollectionReference coursesCollection = FirebaseFirestore.instance.collection(coursesCollectionLabel);

  Future<bool> isUserExists({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return userDocumentSnapshot.exists;
  }

  Future<UserModel> getUserByUserId({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return UserModel.getUserModelByMap(userMap: userDocumentSnapshot.data() as Map<dynamic, dynamic>, userId: userId);
  }

  Future<ApiResponse> addUser({required UserModel user}) async {
    try {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        UserModel.courseLabel: user.course,
        UserModel.semesterLabel: user.semester,
      });
      return ApiResponse(isError: false);
    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "Failed to add user: ERR: $err");
    }
  }

  Future? foo() async {
    QuerySnapshot snapshot = await coursesCollection.get();
    snapshot.docs.forEach((course) async {
      print("SEE: ${course.id}");
      QuerySnapshot semesterSnapshot = await course.reference.collection(semestersCollectionLabel).get();

      semesterSnapshot.docs.forEach((semester) async {

        // todo subjects
        QuerySnapshot subjectsSnapshot = await semester.reference.collection(subjectsCollectionLabel).get();
        subjectsSnapshot.docs.forEach((subject) {
          print("sem: ${semester.id}, Subject: ${subject.id}");

          // todo journal, notes, question paper
          // subject.reference.collection(journalCollectionLabel);
          // subject.reference.collection(notesCollectionLabel);
          // subject.reference.collection(questionPaperCollectionLabel);

        });

        // todo syllabus copy
        // QuerySnapshot syllabusCopySnapshot = await semester.reference.collection(syllabusCopyCollectionLabel).get();
        // syllabusCopySnapshot.docs.forEach((syllabusCopy) {
        //   print("sem: ${semester.id} : SYLLABUS COPY: ${syllabusCopy.data()}");
        // });

        // questionPaperSnapshot.docs.forEach((questionPaper) {
        //   print("\t\t subjects: ${questionPaper.id}");
        // });


      });

    });
    // var temp = snapshot.
    // print("TEMP: ${temp} ");
  }


}