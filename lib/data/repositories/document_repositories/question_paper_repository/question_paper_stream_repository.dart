// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:papers_for_peers/config/firebase_collection_config.dart';
// import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
//
// class QuestionPaperStreamRepository {
//
//   final firestore.FirebaseFirestore _firebaseFirestore;
//
//   static late final firestore.CollectionReference coursesCollection;
//
//   QuestionPaperStreamRepository({firestore.FirebaseFirestore? firebaseFirestore})
//       : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance {
//     coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
//   }
//
//   void dispose() {
//     _questionPaperYears.close();
//   }
//
//   void refresh({
//     required String course,
//     required int semester,
//     required String subject,
//   }) async {
//
//     print("\n\n");
//
//     firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
//     firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
//     firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
//
//     // firestore.QuerySnapshot questionPaperSnapshot =
//     subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).snapshots().listen((questionPaperSnapshot) async {
//       List<QuestionPaperYearModel> questionPaperYearsList = [];
//       await Future.forEach<firestore.QueryDocumentSnapshot>(questionPaperSnapshot.docs, (year) async {
//
//         year.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).snapshots().listen((versionsSnapshot) async {
//           List<QuestionPaperModel> questionPapers = [];
//
//           await Future.forEach<firestore.QueryDocumentSnapshot>(versionsSnapshot.docs, (version) {
//
//             print("${year.id} || VERSION: ${version.id}");
//
//             Map<String, dynamic> versionData = version.data() as Map<String, dynamic>;
//             questionPapers.add(QuestionPaperModel(
//               version: int.parse(version.id),
//               uploadedBy: versionData['uploaded_by'] ?? "null",
//               url: versionData['url'] ?? "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
//             ));
//           });
//
//           questionPaperYearsList.add(QuestionPaperYearModel(
//             year: int.parse(year.id),
//             questionPaperModels: questionPapers,
//           ));
//         });
//       });
//       print("ADDING STREAM");
//       _questionPaperYears.add(questionPaperYearsList);
//     });
//
//
//
//
//     // List<QuestionPaperYearModel> questionPaperYearsList = [];
//     // questionPaperSnapshot.docs.forEach((year) {
//     //
//     //   print("YEAR: ${year.id}");
//     //
//     //
//     //   year.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).snapshots().listen((versionsSnapshot) {
//     //     print("\t\tLISTENING: versions of year: ${year.id}");
//     //
//     //     List<QuestionPaperModel> questionPapers = [];
//     //     versionsSnapshot.docs.forEach((version) {
//     //       print("\t\tVERSION: ${version.id}");
//     //
//     //       Map<String, dynamic> versionData = version.data();
//     //       questionPapers.add(QuestionPaperModel(
//     //         version: int.parse(version.id),
//     //         uploadedBy: versionData['uploaded_by']!,
//     //         url: versionData['url'],
//     //       ));
//     //
//     //     });
//     //     questionPaperYearsList.add(QuestionPaperYearModel(
//     //       year: int.parse(year.id),
//     //       questionPaperModels: questionPapers,
//     //     ));
//     //   });
//     // });
//     //
//     // print("ADDING TO STREAM HERE : ${questionPaperYearsList}");
//     // _questionPaperYears.add(questionPaperYearsList);
//
//     // subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).snapshots().listen((questionPaperSnapshot) async {
//     //   print("LISTENING: question paper");
//     //
//     //   List yearList = [];
//     //   questionPaperSnapshot.docs.forEach((year) {
//     //     year.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).snapshots().listen((versionsSnapshot) {
//     //         print("\t\tLISTENING: versions");
//     //
//     //     }, onDone: () {
//     //       print("DONE DONE DONE");
//     //     });
//     //
//     //     print("YEAR: ${year.id}\n\n");
//     //     yearList.add(year.id);
//     //
//     //     // year.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).snapshots().listen((versionsSnapshot) async {
//     //     //   print("\t\tLISTENING: versions");
//     //     //   versionsSnapshot.docs.forEach((version) {
//     //     //   });
//     //     // },
//     //     // onDone: () {
//     //     // });
//     //   });
//     //
//     //   print("YEARS LIST: ${yearList}");
//     //
//     // });
//
//
//     // subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).snapshots().listen((questionPaperSnapshot) async {
//     //   List<QuestionPaperYearModel> questionPaperYearsList = [];
//     //   await Future.forEach<firestore.QueryDocumentSnapshot>(questionPaperSnapshot.docs, (questionPaper) async {
//     //     firestore.QuerySnapshot versionsSnapshot = await questionPaper.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).get();
//     //     List<QuestionPaperModel> questionPapers = [];
//     //
//     //     await Future.forEach<firestore.QueryDocumentSnapshot>(versionsSnapshot.docs, (version) async {
//     //       Map<String, dynamic> versionData = version.data() as Map<String, dynamic>;
//     //       questionPapers.add(QuestionPaperModel(
//     //         version: int.parse(version.id),
//     //         uploadedBy: versionData['uploaded_by']!,
//     //         url: versionData['url'],
//     //       ));
//     //     });
//     //     questionPaperYearsList.add(QuestionPaperYearModel(
//     //       year: int.parse(questionPaper.id),
//     //       questionPaperModels: questionPapers,
//     //     ));
//     //   });
//     //
//     //   _questionPaperYears.add(questionPaperYearsList);
//     //
//     // });
//
//
//
//     // _questionPaperYears.add(List.generate(1, (index) => QuestionPaperYearModel(
//     //   year: 2020,
//     //   questionPaperModels: List.generate(2, (index) => QuestionPaperModel(version: 2, url: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf", uploadedBy: "uploadedBy")),
//     // )));
//   }
//
//   Stream<List<QuestionPaperYearModel>> get questionPaperYears => _questionPaperYears.stream;
//
// }