const DB = require('./connect');
const lecturer = require('./lecturer');

module.exports = {
    getAll: () => {

    },
    getStudentInClass: (cls) => {
        return new Promise((res, rej) => {
            var query = `SELECT StudentID, getUserFullName(StudentID) Fullname, Name FacultyName, Grade, Status 
                        FROM Learn, Student, Faculty WHERE StudentID = ID AND FacultyCode = Code
                        AND SubjectCode = "${cls.SubjectCode}"
                        AND SemesterCode = "${cls.SemesterCode}"
                        AND ClassName = "${cls.ClassName}"`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getNStudentInSemester: (semester) => {
        return new Promise((res, rej) => {
            var query = `SELECT COUNT(*) nstudent FROM Learn
                        WHERE SemesterCode = "${semester}"`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getNStudent: () => {
        return new Promise((res, rej) => {
            var query = `SELECT COUNT(*) nstudent FROM Learn`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};