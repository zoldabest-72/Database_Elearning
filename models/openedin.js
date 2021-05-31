const DB = require('./connect');

module.exports = {
    getAll: () => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM OpenedIn, Subject
                        WHERE SubjectCode = Code`
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    openSubjectInSemester: (subjectcode, semestercode) => {
        var query = `INSERT INTO OpenedIn VALUES("${subjectcode}","${semestercode}",null)`;
        DB.query(query, function (err, result, fields) {
            if (err) console.log(err)
            console.log(result);
        });
    },
    getAllSubjectOpened: (facultyCode, semesterCode) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Subject JOIN OpenedIn ON Code = SubjectCode) WHERE FacultyCode = "${facultyCode}" AND SemesterCode = "${semesterCode}"`;
            console.log(query);
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    removeSubjectOpenedInSemesterByCode: (code, semestercode) => {
        query = `DELETE FROM OpenedIn WHERE SubjectCode = "${code}" AND SemesterCode = "${semestercode}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        })
    }
};