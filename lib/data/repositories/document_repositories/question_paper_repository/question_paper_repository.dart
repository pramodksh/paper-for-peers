import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class QuestionPaperRepository {

  final firestore.FirebaseFirestore _firebaseFirestore;
  static late final firestore.CollectionReference coursesCollection;

  QuestionPaperRepository({firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> addQuestionPaper({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required int year, required String documentUrl,
  }) async {
    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.DocumentSnapshot yearSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).doc(year.toString()).get();
      await yearSnapshot.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).doc(version.toString()).set(
          {
            "uploaded_by": user.displayName,
            "url": documentUrl,
          }
      );
      return ApiResponse(isError: false,);

    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "There was an error while setting question paper: $err");
    }

  }

  Future<ApiResponse> getQuestionPapers({
    required String course, required int semester,
    required String subject,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.QuerySnapshot questionPaperSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).get();
      List<QuestionPaperYearModel> questionPaperYears = [];

      await Future.forEach<firestore.QueryDocumentSnapshot>(questionPaperSnapshot.docs, (questionPaper) async {
        firestore.QuerySnapshot versionsSnapshot = await questionPaper.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).get();
        List<QuestionPaperModel> questionPapers = [];

        await Future.forEach<firestore.QueryDocumentSnapshot>(versionsSnapshot.docs, (version) async {
          Map<String, dynamic> versionData = version.data() as Map<String, dynamic>;
          questionPapers.add(QuestionPaperModel(
            version: int.parse(version.id),
            uploadedBy: versionData['uploaded_by'],
            url: versionData['url'],
          ));
        });
        questionPaperYears.add(QuestionPaperYearModel(
          year: int.parse(questionPaper.id),
          questionPaperModels: questionPapers,
        ));
      });
      return ApiResponse<List<QuestionPaperYearModel>>(isError: false, data: questionPaperYears);
    } catch (e) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching question papers: ${e}");
    }
  }

}