const DB = require('./connect');

module.exports = {
    getAll: (condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM Subject `;
            if ("keySearch" in condition) {
                query += `WHERE CONCAT(Code,Name,NoOfCredits,' ',FacultyCode) LIKE "%${condition.keySearch}%" `
            }
            if ("SFacultyCode" in condition && condition.SFacultyCode != -1) {
                query += `AND FacultyCode = "${condition.SFacultyCode}" `
            }
            // if ("Semester" in condition && condition.Semester != -1) {
            //     query += `AND SemesterCode = "${condition.Semester}" `
            // }
            if ("SSubjectCode" in condition && condition.SSubjectCode != -1) {
                query += `AND Code = "${condition.SSubjectCode}" `
            }
            if ("limit" in condition) {
                query += `LIMIT ${condition.limit} OFFSET ${(condition.page-1)*condition.limit}`;
            }
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    add: (subject) => {
        return new Promise((res, rej) => {
            DB.query(`INSERT INTO Subject VALUES("${subject.code}","${subject.name}","${subject.noOfCredits}","${subject.facultyCode}")`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSubjectInSemester: (semester) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Subject WHERE Code IN (SELECT SubjectCode FROM OpenedIn WHERE SemesterCode = "${semester}")`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    // THUY
    getSubjectRecommend: (studentid) => {
        return new Promise((res, rej) => {
            sql =
                `SELECT * 
            FROM Subject 
            WHERE FacultyCode = (
                SELECT FacultyCode
                FROM Student
                WHERE ID = "${studentid}")`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },

    getSubjectByKeyword: (text, semester) => {
        return new Promise((res, rej) => {
            sql = `SELECT * FROM (OpenedIn JOIN Subject ON SubjectCode = Code) WHERE CONCAT(Name,' ',Code) LIKE "%${text}%" AND SemesterCode = ${semester}`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSubjectByCode: (code) => {
        return new Promise((res, rej) => {
            sql = `SELECT * FROM Subject WHERE Code = "${code}"`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSubjectInSemester: (semester) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Subject WHERE Code IN (SELECT SubjectCode FROM OpenedIn WHERE SemesterCode = "${semester}")`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSubjectGroup: () => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Subject GROUP BY Code`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getByCode: (Code) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Subject WHERE Code = "${Code}" `, function(err, result, fields) {
                if (err) rej(err);
                res(result[0]);
            })
        })
    },
    subjectsOfFaculty: (condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM ((Subject JOIN OpenedIn ON Code = SubjectCode) LEFT OUTER JOIN (SELECT SubjectCode AS A, SemesterCode AS B,COUNT(*) AS NumberStudent FROM Enroll GROUP BY SubjectCode,SemesterCode) AS Er ON OpenedIn.SubjectCode = Er.A AND OpenedIn.SemesterCode = Er.B) `;
            if ("keySearch" in condition) {
                query += `WHERE CONCAT(Code,Name,NoOfCredits,' ',OpenedIn.SemesterCode,' ',FacultyCode) LIKE "%${condition.keySearch}%" `
            }
            if ("SFacultyCode" in condition && condition.SFacultyCode != -1) {
                query += `AND FacultyCode = "${condition.SFacultyCode}" `
            }
            if ("Semester" in condition && condition.Semester != -1) {
                query += `AND OpenedIn.SemesterCode = "${condition.Semester}" `
            }
            if ("SSubjectCode" in condition && condition.SSubjectCode != -1) {
                query += `AND Code = "${condition.SSubjectCode}" `
            }
            if ("limit" in condition) {
                query += `LIMIT ${condition.limit} OFFSET ${(condition.page-1)*condition.limit}`;
            }
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getSignedSubject: userid => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Subject WHERE ID IN (SELECT SubjectID FROM Study WHERE StudentID = "${userid}")`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });

    },
    subjectsTeachedBy: (LecturerID, semesterCode = '') => {
        return new Promise((res, rej) => {
            var querySubejctTeach = `SELECT Code,SemesterCode,Name,NoOfCredits,COUNT(*) AS NumClass FROM (Teach JOIN Subject ON SubjectCode = Code) WHERE LecturerID = "${LecturerID}" GROUP BY SubjectCode, SemesterCode ORDER BY SemesterCode DESC`;
            var query = `SELECT * FROM (OpenedIn Join (${querySubejctTeach}) AS T ON T.Code = SubjectCode AND T.SemesterCode = OpenedIn.SemesterCode) `;
            if (semesterCode != '') {
                query += `WHERE OpenedIn.SemesterCode = ${semesterCode}`;
            }
            DB.query(query, function(err, results, fields) {
                if (err) rej(err);
                res(results);
            })
        })
    },
    getAllSubjectOpened: (facultyCode, semesterCode) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Subject JOIN OpenedIn ON Code = SubjectCode) WHERE FacultyCode = "${facultyCode}" AND SemesterCode = "${semesterCode}"`;
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    removeSubjectByCode: (code) => {
        sql = `DELETE FROM Subject WHERE Code = "${code}"`;
        DB.query(sql, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        })
    },
    deteleByID: (studentid, subjectid) => {
        DB.query(`DELETE FROM Study WHERE SubjectID = "${subjectid}" AND StudentID = ${studentid}`, function(err, result, fields) {
            if (err) console.log(err)
            console.log(result);
        });
    }
};