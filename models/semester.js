const DB = require('./connect');

module.exports = {
    now: () => {
        return new Promise((res, rej) => {
            DB.query(`SELECT Code FROM Semester ORDER BY FinishDate DESC`, function(err, result, fields) {
                if (err) rej(err);
                if (result.length) res(result[0].Code);
            })
        })
    },
    getAll: () => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Semester`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getCurrentSemester: () => {
        return new Promise((res, rej) => {
            DB.query(`SELECT Code FROM Semester WHERE StartDate < NOW() AND  NOW() < FinishDate`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    add: (semester) => {
        return new Promise((res, rej) => {
            console.log(`INSERT INTO Semester VALUES(${semester.SemesterCode},'${semester.StartDate}','${semester.FinishDate})'`);
            DB.query(`INSERT INTO Semester VALUES(${semester.SemesterCode},'${semester.StartDate}','${semester.FinishDate}')`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSemesterSign: () => {
        return new Promise((res, rej) => {
            DB.query("select Code from Semester where (curdate()<StartDate);", function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getSemester: (SemesterCode) => {
        return new Promise((res, rej) => {
            DB.query(`Select Code from Semester where Code = "${SemesterCode}"`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getTop3Semester: (StudentID) => {
        return new Promise((res, rej) => {
            DB.query(`select Learn.SemesterCode, Sum(Subject.NoOfCredits) as Total from Learn,Subject
            where Learn.StudentID = '${StudentID}' and Learn.SubjectCode = Subject.Code group by Learn.SemesterCode order by Total desc limit 4;`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }

};