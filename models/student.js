const DB = require('./connect');

module.exports = {
    getAll: (condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT Student.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, Grade, FacultyCode FROM (Student JOIN User on Student.ID = User.ID) `;
            if ("keySearch" in condition) {
                query += `WHERE CONCAT(Student.ID,CONCAT(Fname,' ',Mname,' ',Lname), Email, Grade, FacultyCode) LIKE "%${condition.keySearch}%" `
            }
            if ("SFacultyCode" in condition && condition.SFacultyCode != -1) {
                query += `AND FacultyCode = "${condition.SFacultyCode}" `
            }
            if ("Semester" in condition && condition.Semester != -1) {
                query += `AND SemesterCode = "${condition.Semester}" `
            }
            if ("SSubjectCode" in condition && condition.SSubjectCode != -1) {
                query += `AND SubjectCode = "${condition.SSubjectCode}" `
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
    getByID: (ID) => {
        return new Promise((res, rej) => {
            var query = `SELECT Student.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, Grade, FacultyCode, Status FROM (Student JOIN User on Student.ID = User.ID) WHERE Student.ID = "${ID}"`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                if (result) {
                    res(result[0])
                };
            })
        });
    },
    add: (clas) => {
        return new Promise((res, rej) => {
            DB.query(`INSERT INTO Class(SubjectCode, SemesterCode, ClassName) VALUES("${clas.SubjectCode}","${clas.Semester}","${clas.name}")`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    studentsInClass: (SubjectCode, SemesterCode, ClassName) => {
        return new Promise((res, rej) => {
            var query = `SELECT Student.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, Grade, FacultyCode FROM (Learn JOIN (Student JOIN User ON Student.ID = User.ID) ON Student.ID = StudentID) WHERE SubjectCode ="${SubjectCode}" AND SemesterCode = "${SemesterCode}" AND ClassName = "${ClassName}"`;
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};