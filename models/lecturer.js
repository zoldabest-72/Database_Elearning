const DB = require('./connect');

module.exports = {
    getAll: (condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT Lecturer.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, Bdate, Address, Phone, FacultyCode FROM (((Lecturer JOIN FacultyStaff on Lecturer.ID = FacultyStaff.ID) JOIN User on Lecturer.ID = User.ID) JOIN UserPhone on Lecturer.ID = UserPhone.UserID) `;
            if ("keySearch" in condition) {
                query += `WHERE CONCAT(Lecturer.ID,CONCAT(Fname,' ',Mname,' ',Lname), Email, FacultyCode) LIKE "%${condition.keySearch}%" `
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
                query += `LIMIT ${condition.limit} OFFSET ${(condition.page - 1) * condition.limit}`;
            }
            console.log(query);
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getByID: (ID) => {
        return new Promise((res, rej) => {
            var query = `SELECT Lecturer.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, FacultyCode FROM ((Lecturer JOIN FacultyStaff on Lecturer.ID = FacultyStaff.ID) JOIN User on Lecturer.ID = User.ID) WHERE Lecturer.ID = "${ID}"`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                if (result) {
                    res(result[0])
                };
            })
        });
    },
    add: (clas) => {
        return new Promise((res, rej) => {
            DB.query(`INSERT INTO Class(SubjectCode, SemesterCode, ClassName) VALUES("${clas.SubjectCode}","${clas.Semester}","${clas.name}")`, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    lecturersOfClass: (SubjectCode, SemesterCode, ClassName) => {
        return new Promise((res, rej) => {
            var query = `SELECT Lecturer.ID AS ID,CONCAT(Fname,' ',Mname,' ',Lname) AS Name, Email, FacultyCode FROM (Teach JOIN ((Lecturer JOIN FacultyStaff on Lecturer.ID = FacultyStaff.ID) JOIN User on Lecturer.ID = User.ID) ON Lecturer.ID = LecturerID) WHERE SubjectCode ="${SubjectCode}" AND SemesterCode = "${SemesterCode}" AND ClassName = "${ClassName}"`;
            console.log(query);
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getLecturerInSemester: (semestercode) => {
        return new Promise((res, rej) => {
            query = `SELECT * FROM LecturersInfo
                    WHERE ID IN (
                        SELECT LecturerID FROM Teach 
                        WHERE SemesterCode = "${semestercode}")`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};