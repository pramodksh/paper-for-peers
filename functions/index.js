const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const bucket = admin.storage().bucket();
const firestore = admin.firestore();

// /courses_new/bca/semesters/1/subjects/java/question_paper/2017/versions/1
// /courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}

// Admin - reports collection label
const reportsQuestionPaperCollectionLabel = "reports_question_papers";
const reportsNotesCollectionLabel = "reports_notes";
const reportsJournalsCollectionLabel = "reports_journals";
const reportsTextBookCollectionLabel = "reports_text_books";
const reportsSyllabusCopyCollectionLabel = "reports_syllabus_copy";

// Defining weights for reports
const reportWeights = {
  not_legitimate: 2,
  not_appropriate: 1,
  already_uploaded: 3,
  misleading: 4,
};
const maxReports = 10; // todo change to 40

function getReportCounts(mergedValues) {
  const reportCounts = {};
  for (const report of mergedValues) {
    reportCounts[report] = reportCounts[report] ? reportCounts[report] + 1 : 1;
  }
  return reportCounts;
}

function getMergedReportValues(reports) {
  const mergedValues = [].concat.apply([], reports);
  return mergedValues;
}

function getWeightedReportCounts(reportCounts, reportWeights) {
  const weightedReportCounts = {};
  for (var key in reportWeights) {
    if (reportCounts[key] != undefined) {
      weightedReportCounts[key] = reportCounts[key] * reportWeights[key];
    } else {
      weightedReportCounts[key] = 0;
    }
  }
  return weightedReportCounts;
}

function getTotalReports(weightedReportCounts) {
  const totalReports = Object.values(weightedReportCounts).reduce(
    (a, b) => a + b
  );
  return totalReports;
}

exports.reportQuestionPaper = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}"
  )
  .onUpdate(async (change, context) => {
    functions.logger.log("REPORT QUESTION PAPER");
    const questionPaperId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );
    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);
    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );
    functions.logger.log("COUNTS AFTER MULTIPLYING: ", weightedReportCounts);

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    // Delete document if limit exceeds
    if (totalReports >= maxReports) {
      await admin
        .firestore()
        .collection(reportsQuestionPaperCollectionLabel)
        .doc(questionPaperId)
        .set({
          ref: change.after.ref,
        });

      // await admin
      //   .firestore()
      //   .collection(reportsQuestionPaperCollectionLabel)
      //   .doc(questionPaperId)
      //   .set(newValue);

      functions.logger.log("ADDED Question paper IN ADMIN COLLECTION");

      // functions.logger.log("DELETING DOCUMENT");
      // await change.after.ref.delete();
      // functions.logger.log("DELETING FILE FROM STORAGE");
      // const path = `courses/${context.params.course}/${context.params.semester}/${context.params.subject}/question_paper/${context.params.year}/${context.params.version}.pdf`;
      // await bucket.file(path).delete();
      // functions.logger.log("DOCUMENT DELETED: ", totalReports, maxReports);
    } else {
      functions.logger.log("DOCUMENT NOT DELETED: ", totalReports, maxReports);
    }
  });

exports.reportJournal = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/journal/{version}"
  )
  .onUpdate(async (change, context) => {
    const journalId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );
    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);
    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );
    functions.logger.log("COUNTS AFTER MULTIPLYING: ", weightedReportCounts);

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    // Delete document if limit exceeds
    if (totalReports >= maxReports) {
      await admin
        .firestore()
        .collection(reportsJournalsCollectionLabel)
        .doc(journalId)
        .set({
          ref: change.after.ref,
        });

      // await admin
      //   .firestore()
      //   .collection(reportsJournalsCollectionLabel)
      //   .doc(journalId)
      //   .set(newValue);

      functions.logger.log("ADDED Journal IN ADMIN COLLECTION");
      // functions.logger.log("DELETING DOCUMENT");
      // await change.after.ref.delete();

      // functions.logger.log("DELETING FILE FROM STORAGE");

      // const path = `courses/${context.params.course}/${context.params.semester}/${context.params.subject}/journals/${context.params.version}.pdf`;
      // await bucket.file(path).delete();

      // functions.logger.log("DOCUMENT DELETED: ", totalReports, maxReports);
    } else {
      functions.logger.log("DOCUMENT NOT DELETED: ", totalReports, maxReports);
    }
  });

exports.reportSyllabusCopy = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/syllabus_copy/{version}"
  )
  .onUpdate(async (change, context) => {
    const syllabusCopyId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );
    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);
    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );
    functions.logger.log("COUNTS AFTER MULTIPLYING: ", weightedReportCounts);

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    // Delete document if limit exceeds
    if (totalReports >= maxReports) {
      await admin
        .firestore()
        .collection(reportsSyllabusCopyCollectionLabel)
        .doc(syllabusCopyId)
        .set({
          ref: change.after.ref,
        });

      // await admin
      //   .firestore()
      //   .collection(reportsSyllabusCopyCollectionLabel)
      //   .doc(syllabusCopyId)
      // .set(newValue);

      functions.logger.log("ADDED Syllabus copy IN ADMIN COLLECTION");
      // functions.logger.log("DELETING DOCUMENT");
      // await change.after.ref.delete();

      // functions.logger.log("DELETING FILE FROM STORAGE");

      // const path = `courses/${context.params.course}/${context.params.semester}/syllabus_copy/${context.params.version}.pdf`;
      // await bucket.file(path).delete();

      // functions.logger.log("DOCUMENT DELETED: ", totalReports, maxReports);
    } else {
      functions.logger.log("DOCUMENT NOT DELETED: ", totalReports, maxReports);
    }
  });

exports.reportTextBook = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/text_book/{version}"
  )
  .onUpdate(async (change, context) => {
    const textBookId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );
    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);
    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );
    functions.logger.log("COUNTS AFTER MULTIPLYING: ", weightedReportCounts);

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    // Delete document if limit exceeds
    if (totalReports >= maxReports) {
      await admin
        .firestore()
        .collection(reportsTextBookCollectionLabel)
        .doc(textBookId)
        .set({
          ref: change.after.ref,
        });

      // await admin
      //   .firestore()
      //   .collection(reportsTextBookCollectionLabel)
      //   .doc(textBookId)
      //   .set(newValue);

      functions.logger.log("ADDED Text book IN ADMIN COLLECTION");
      // functions.logger.log("DELETING DOCUMENT");
      // await change.after.ref.delete();

      // functions.logger.log("DELETING FILE FROM STORAGE");

      // const path = `courses/${context.params.course}/${context.params.semester}/${context.params.subject}/text_book/${context.params.version}.pdf`;
      // await bucket.file(path).delete();

      // functions.logger.log("DOCUMENT DELETED: ", totalReports, maxReports);
    } else {
      functions.logger.log("DOCUMENT NOT DELETED: ", totalReports, maxReports);
    }
  });

exports.reportNotes = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/notes/{noteId}"
  )
  .onUpdate(async (change, context) => {
    const noteId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;
    functions.logger.log("TOTAL USERS: ", totalUsers);

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );
    functions.logger.log("MERGEDValues: ", mergedValues);

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);
    functions.logger.log("reportCounts: ", reportCounts);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );
    functions.logger.log("COUNTS AFTER MULTIPLYING: ", weightedReportCounts);

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);
    functions.logger.log("TOTAL REPORTS: ", totalReports);

    // Delete document if limit exceeds
    if (totalReports >= maxReports) {
      await admin
        .firestore()
        .collection(reportsNotesCollectionLabel)
        .doc(noteId)
        .set({
          ref: change.after.ref,
        });

      // await admin
      //   .firestore()
      //   .collection(reportsNotesCollectionLabel)
      //   .doc(noteId)
      //   .set(newValue);

      functions.logger.log("ADDED Notes IN ADMIN COLLECTION");
      // functions.logger.log("DELETING DOCUMENT");
      // await firestore.recursiveDelete(change.after.ref);

      // functions.logger.log("DELETING FILE FROM STORAGE");

      // const path = `courses/${context.params.course}/${context.params.semester}/${context.params.subject}/notes/${context.params.noteId}.pdf`;
      // await bucket.file(path).delete();

      // functions.logger.log("DOCUMENT DELETED: ", totalReports, maxReports);
    } else {
      functions.logger.log("DOCUMENT NOT DELETED: ", totalReports, maxReports);
    }
  });
