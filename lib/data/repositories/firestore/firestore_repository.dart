import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class FirestoreRepository {

  final firestore.FirebaseFirestore _firebaseFirestore;

  FirestoreRepository({firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance {
    usersCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.usersCollectionLabel);
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  static late final firestore.CollectionReference usersCollection;
  static late final firestore.CollectionReference coursesCollection;

  Future<bool> isUserExists({required String userId}) async {
    firestore.DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return userDocumentSnapshot.exists;
  }

  // List<double> getRatingsOfUser(firestore.QuerySnapshot ratingSnapshot) {
  //   // ratingSnapshot.docs.forEach((element) {
  //   //   List<double> ratings = (element.data() as Map).values.toList().map((e) => e['rating'] as double).toList();
  //   //   print("CHECK HERE: ${ratings}");
  //   // });
  // }

  Future<UserModel> getUserByUserId({required String userId}) async {
    firestore.DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    firestore.QuerySnapshot ratingSnapshot = await userDocumentSnapshot.reference.collection(FirebaseCollectionConfig.ratingCollectionLabel).get();

    List<double> totalRatings = [];
    ratingSnapshot.docs.forEach((element) {

      List<double> ratings = (element.data() as Map).values.toList().map((e) => e['rating'] as double).toList();
      totalRatings.addAll(ratings);
      print("CHECK HERE: ${ratings}");
    });

    Map<String, dynamic> userData = userDocumentSnapshot.data() as Map<String, dynamic>;

    if (userData.containsKey(UserModel.fcmTokenLabel) && userData[UserModel.fcmTokenLabel] != null) {

      return await UserModel.getUserModelByMap(
        fcmToken: userData[UserModel.fcmTokenLabel],
        userMap: userData,
        userId: userId, getCourse: getCourse,
        avgRating: totalRatings.length == 0 ? 0 : totalRatings.average,
        totalRatings: totalRatings.length,
      );
    } else {
      String? token = await FirebaseMessaging.instance.getToken();
      log("TOKEN: $token");

      UserModel userModel = await UserModel.getUserModelByMap(
        fcmToken: token,
        userMap: userData,
        userId: userId, getCourse: getCourse,
        avgRating: totalRatings.length == 0 ? 0 : totalRatings.average,
        totalRatings: totalRatings.length,
      );

      addUser(user: userModel);

      return userModel;
    }


  }

  Future<ApiResponse> addUser({required UserModel user}) async {

    try {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        UserModel.courseLabel: user.course?.courseName,
        UserModel.semesterLabel: user.semester?.nSemester,
        UserModel.fcmTokenLabel: user.fcmToken,
      });
      return ApiResponse.success();
    } catch (err) {
      return ApiResponse.error(errorMessage: "Failed to add user: ERR: $err");
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