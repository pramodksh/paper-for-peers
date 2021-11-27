const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const bucket = admin.storage().bucket();

// /courses_new/bca/semesters/1/subjects/java/question_paper/2017/versions/1
// /courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}

// Defining weights for reports
const reportWeights = {
  not_legitimate: 2,
  not_appropriate: 1,
  already_uploaded: 3,
  misleading: 4,
};
const maxQuestionPaperReports = 10;

exports.questionPaperReport = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}"
  )
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    const mergedValues = [].concat.apply(
      [],
      Object.values(newValue["reports"])
    );

    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = {};
    for (const report of mergedValues) {
      reportCounts[report] = reportCounts[report]
        ? reportCounts[report] + 1
        : 1;
    }

    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    for (var key in reportWeights) {
      if (reportCounts[key] != undefined) {
        reportCounts[key] = reportCounts[key] * reportWeights[key];
      } else {
        reportCounts[key] = 0;
      }
    }

    functions.logger.log("COUNTS AFTER MULTIPLYING: ", reportCounts);

    const totalReports = Object.values(reportCounts).reduce((a, b) => a + b);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    const avgReports = totalReports / totalUsers;
    functions.logger.log("AVG REPORTS: ", avgReports);

    // Delete document if limit exceeds
    if (totalReports >= maxQuestionPaperReports) {
      functions.logger.log("DELETING DOCUMENT");
      await change.after.ref.delete();

      functions.logger.log("DELETING FILE FROM STORAGE");

      const path = `courses/${context.params.course}/${context.params.semester}/${context.params.subject}/question_paper/${context.params.year}/${context.params.version}.pdf`;
      await bucket.file(path).delete();

      functions.logger.log(
        "DOCUMENT DELETED: ",
        totalReports,
        maxQuestionPaperReports
      );
    } else {
      functions.logger.log(
        "DOCUMENT NOT DELETED: ",
        totalReports,
        maxQuestionPaperReports
      );
    }
  });
