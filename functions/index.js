const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// /courses_new/bca/semesters/1/subjects/java/question_paper/2017/versions/1
// /courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}

exports.questionPaperReport = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}"
  )
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    functions.logger.log("NEW VALUE: ", newValue);
    functions.logger.log("REPORTS: ", newValue["reports"]);
    functions.logger.log("VALUES: ", Object.values(newValue["reports"]));

    const totalReports = Object.values(newValue["reports"]).reduce(
      (pv, cv) => pv + cv,
      0
    );
    functions.logger.log("TOTAL: ", totalReports);
    //    functions.logger.log("previousValue VALUE: ", previousValue);
    functions.logger.log(
        "DETAILS:",
      context.params.course,
      context.params.semester,
      context.params.subject,
      context.params.year,
      context.params.version
    );

    /*
        const userSnapshot = await admin.firestore()
          .collection('users')
          .doc(context.params.userId)
          .collection('tokens')
          .get();
    */

  });
