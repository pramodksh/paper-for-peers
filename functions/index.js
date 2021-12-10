const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const bucket = admin.storage().bucket();
const firestore = admin.firestore();
const fcm = admin.messaging();

const adminCollectionLabel = "admin";
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

const maxReports = async () => {
  const template = await admin.remoteConfig().getTemplate();
  const maxReports = template.parameters["REPORTS_MAX"].defaultValue.value;
  return maxReports;
};

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

function toSubject(subject) {
  return subject
    .toLowerCase()
    .split(" ")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

async function sendReportNotificationToAdmins(
  documentType,
  username,
  course,
  semester,
  subject
) {
  const adminSnapshot = await firestore.collection(adminCollectionLabel).get();

  const tokens = adminSnapshot.docs.map((snap) => snap.data()["fcm_token"]);

  if (subject == null) {
    subject = "";
  } else {
    subject = subject.replace(/_/g, " ");
    subject = toSubject(subject);
  }

  const payload = {
    notification: {
      title: `New ${capitalize(
        documentType.replace(/_/g, " ").toLowerCase()
      )} report of ${course.toUpperCase()} ${semester} ${subject}`,
      body: `${username} has reported a ${capitalize(
        documentType.replace(/_/g, " ").toLowerCase()
      )}`,
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      document_type: documentType.toUpperCase(),
      type: "REPORT",
    },
  };
  return await fcm.sendToDevice(tokens, payload);
}

exports.reportQuestionPaper = functions.firestore
  .document(
    "/courses_new/{course}/semesters/{semester}/subjects/{subject}/question_paper/{year}/versions/{version}"
  )
  .onUpdate(async (change, context) => {
    const questionPaperId = change.after.id;
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const totalUsers = Object.keys(newValue["reports"]).length;

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);

    // Add document to admin if limit exceeds
    if (totalReports >= (await maxReports())) {
      await admin
        .firestore()
        .collection(reportsQuestionPaperCollectionLabel)
        .doc(questionPaperId)
        .set({
          ref: change.after.ref,
        });

      await sendReportNotificationToAdmins(
        "QUESTION_PAPER",
        newValue["uploaded_by"],
        context.params.course,
        context.params.semester,
        context.params.subject
      );
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

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);

    // Add document to admin if limit exceeds
    if (totalReports >= (await maxReports())) {
      await admin
        .firestore()
        .collection(reportsJournalsCollectionLabel)
        .doc(journalId)
        .set({
          ref: change.after.ref,
        });

      await sendReportNotificationToAdmins(
        "JOURNAL",
        newValue["uploaded_by"],
        context.params.course,
        context.params.semester,
        context.params.subject
      );
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

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);

    // Add document to admin if limit exceeds
    if (totalReports >= (await maxReports())) {
      await admin
        .firestore()
        .collection(reportsSyllabusCopyCollectionLabel)
        .doc(syllabusCopyId)
        .set({
          ref: change.after.ref,
        });

      await sendReportNotificationToAdmins(
        "SYLLABUS_COPY",
        newValue["uploaded_by"],
        context.params.course,
        context.params.semester,
        null
      );
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

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);

    // Add document to admin if limit exceeds
    if (totalReports >= (await maxReports())) {
      await admin
        .firestore()
        .collection(reportsTextBookCollectionLabel)
        .doc(textBookId)
        .set({
          ref: change.after.ref,
        });

      await sendReportNotificationToAdmins(
        "TEXT_BOOK",
        newValue["uploaded_by"],
        context.params.course,
        context.params.semester,
        context.params.subject
      );
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

    // merge array of array into single array
    const mergedValues = getMergedReportValues(
      Object.values(newValue["reports"])
    );

    // Count the number of occurances of reports
    const reportCounts = getReportCounts(mergedValues);

    // multiply : report counts * report values (if key is not present put 0)
    const weightedReportCounts = getWeightedReportCounts(
      reportCounts,
      reportWeights
    );

    // find total report count
    const totalReports = getTotalReports(weightedReportCounts);

    // Add document to admin if limit exceeds
    if (totalReports >= (await maxReports())) {
      await admin
        .firestore()
        .collection(reportsNotesCollectionLabel)
        .doc(noteId)
        .set({
          ref: change.after.ref,
        });

      await sendReportNotificationToAdmins(
        "NOTES",
        newValue["uploaded_by"],
        context.params.course,
        context.params.semester,
        context.params.subject
      );
    }
  });
