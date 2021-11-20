import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';

class FirestoreRepository {

  final firestore.FirebaseFirestore _firebaseFirestore;

  FirestoreRepository({firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance {
    usersCollection =  _firebaseFirestore.collection(usersCollectionLabel);
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  static final String usersCollectionLabel = "users";
  // static String documentsCollectionLabel = "";

  // static final String yearsCollectionLabel = "years"; // todo delete if not used

  static late final firestore.CollectionReference usersCollection;
  static late final firestore.CollectionReference coursesCollection;



  Future<bool> isUserExists({required String userId}) async {
    firestore.DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return userDocumentSnapshot.exists;
  }

  Future<UserModel> getUserByUserId({required String userId}) async {
    firestore.DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return await UserModel.getUserModelByMap(
      userMap: userDocumentSnapshot.data() as Map<dynamic, dynamic>,
      userId: userId, getCourse: getCourse,
    );
  }

  Future<ApiResponse> addUser({required UserModel user}) async {

    print("ADD USER IN REPO ${user.toString()}");
    try {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        UserModel.courseLabel: user.course?.courseName,
        UserModel.semesterLabel: user.semester?.nSemester,
      });
      return ApiResponse(isError: false);
    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "Failed to add user: ERR: $err");
    }
  }

  Future<Course> getCourse(String name) async {

    firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(name).get();
    firestore.QuerySnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).get();

    List<Semester> semesters = [];

    await Future.forEach<firestore.QueryDocumentSnapshot>(semesterSnapshot.docs, (semester) async {
      print("\t ${semester.id}");
      firestore.QuerySnapshot subjectsSnapshot = await semester.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();
      List<String> subjects = [];
      subjectsSnapshot.docs.forEach((subject) {
        print("\t\t ${subject.id}");
        subjects.add(subject.id);
      });

      Semester semesterModel = Semester(subjects: subjects, nSemester: int.parse(semester.id));
      semesters.add(semesterModel);

    });

    Course courseModel = Course(courseName: coursesSnapshot.id, semesters: semesters);
    return courseModel;
  }

  Future<List<Course>> getCourses() async {
    firestore.QuerySnapshot coursesSnapshot = await coursesCollection.get();

    List<Course> courses = [];

    await Future.forEach<firestore.QueryDocumentSnapshot>(coursesSnapshot.docs, (course) async {

      List<Semester> semesters = [];

      firestore.QuerySnapshot semesterSnapshot = await course.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).get();
      await Future.forEach<firestore.QueryDocumentSnapshot>(semesterSnapshot.docs, (semester) async {
        print("\t ${semester.id}");
        firestore.QuerySnapshot subjectsSnapshot = await semester.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();
        List<String> subjects = [];
        subjectsSnapshot.docs.forEach((subject) {
          print("\t\t ${subject.id}");
          subjects.add(subject.id);
        });

        Semester semesterModel = Semester(subjects: subjects, nSemester: int.parse(semester.id));
        semesters.add(semesterModel);

      });

      Course courseModel = Course(courseName: course.id, semesters: semesters);
      courses.add(courseModel);

    });

    return courses;

  }
}