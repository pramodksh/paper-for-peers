const reportWeights = {
  not_legitimate: 2,
  not_appropriate: 1,
  already_uploaded: 3,
  misleading: 4,
};

const reportCounts = {
  not_legitimate: 10,
  not_appropriate: 10,
  already_uploaded: 10,
  misleading: 10,
};

const totalUsers = 20;

for (var key in reportWeights) {
  if (reportCounts[key] != undefined) {
    reportCounts[key] = reportCounts[key] * reportWeights[key];
  } else {
    reportCounts[key] = 0;
  }
}

const totalReports = Object.values(reportCounts).reduce((a, b) => a + b);
const avgReports = totalReports / totalUsers;

console.log({ totalReports, avgReports });
