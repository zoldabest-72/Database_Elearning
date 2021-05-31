const DB = require('./connect');

module.exports = {
    enrollSubjectByCode: (studentid, subjectcode) => {
        semestercode = "202";
        sql = `INSERT INTO Enroll VALUES ("${studentid}","${subjectcode}","${semestercode}")`;
        DB.query(sql, (err, result, fields) => {
            if (err) console.log(err);
            console.log("Enrolled " + subjectcode);
        })
    },

    removeSubjectByCode: (studentid, subjectcode) => {
        semestercode = "202";
        sql = `DELETE FROM Enroll WHERE 
                SubjectCode = "${subjectcode}" 
                AND StudentID = "${studentid}" 
                AND SemesterCode = "${semestercode}"`;
        DB.query(sql, (err, result, fields) => {
            if (err) console.log(err);
            console.log("Removed " + subjectcode);
        })
    },

    getEnrolledSubjectsByStudentId: (studentid, semesterCode) => {
        return new Promise((res, rej) => {
            sql = `SELECT * FROM Enroll WHERE StudentID = "${studentid}" AND SemesterCode = "${semesterCode}"`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getEnrolledSubjects: () => {
        return new Promise((res, rej) => {
            sql = `SELECT * FROM Enroll`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getNumberOfStudentEnrollSubjectInNYearAgo: (subjectcode, nyear) => {
        return new Promise((res, rej) => {
            sql = `SELECT COUNT(*) nstudent FROM Enroll 
                    WHERE SubjectCode = "${subjectcode}" 
                    AND 1 = SemesterInRangeNYear(SemesterCode, "${nyear}")
                    GROUP BY SemesterCode`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    }
};