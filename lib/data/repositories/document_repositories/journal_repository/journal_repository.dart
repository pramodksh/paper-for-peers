import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';

class JournalRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;
  static late final firestore.CollectionReference coursesCollection;

  JournalRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> getJournals({
    required String course, required int semester,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();

      firestore.QuerySnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

      List<JournalSubjectModel> journalSubjects = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(subjectSnapshot.docs, (subject) async {

        List<JournalModel> journals = [];
        firestore.QuerySnapshot journalSnapshot = await subject.reference.collection(FirebaseCollectionConfig.journalCollectionLabel).get();
        await Future.forEach<firestore.QueryDocumentSnapshot>(journalSnapshot.docs, (journal) {
          Map<String, dynamic> journalData = journal.data() as Map<String, dynamic>;
          journals.add(JournalModel(
            uploadedOn: DateTime.now(), // todo change to database value
            version: int.parse(journal.id),
            uploadedBy: journalData['uploaded_by'],
            url: journalData['url'],
          ));
        });

        journalSubjects.add(JournalSubjectModel(
          subject: subject.id,
          journalModels: journals,
        ));
      });
      return ApiResponse<List<JournalSubjectModel>>(isError: false, data: journalSubjects);
    } catch (_) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching journals");
    }
  }

}