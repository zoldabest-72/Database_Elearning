const DB = require('./connect');

module.exports = {
    getAll: () => {
        return new Promise((res, rej) => {
            query = `SELECT LecturerID, SubjectCode, FacultyCode, Name SubjectName, ClassName, SemesterCode, Week, getUserFullName(LecturerID) Name FROM Teach,Subject WHERE Code = SubjectCode`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getLecturersFullNameByClass: (cls) => {
        return new Promise((res, rej) => {
            query = `SELECT getUserFullName(LecturerID) Name FROM Teach 
                    WHERE SubjectCode = "${cls.SubjectCode}"
                    AND ClassName = "${cls.ClassName}"
                    AND SemesterCode = "${cls.SemesterCode}"`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    addLecturerToClass: (lecturerid, cls) => {
        query = `INSERT INTO Teach SELECT * FROM (SELECT
            "${lecturerid}", 
            "${cls.SubjectCode}", 
            "${cls.SemesterCode}",
            "${cls.ClassName}",
            null) t
            WHERE 0 = (
                SELECT COUNT(*) FROM Teach
                WHERE LecturerID = "${lecturerid}"
                AND SubjectCode = "${cls.SubjectCode}" 
                AND SemesterCode = "${cls.SemesterCode}"
                AND ClassName = "${cls.ClassName}")`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    removeLecturersOfClass: (cls) => {
        query = `DELETE FROM Teach
                WHERE SubjectCode = "${cls.SubjectCode}" 
                AND SemesterCode = "${cls.SemesterCode}"
                AND ClassName = "${cls.ClassName}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    updateWeekOfLecturerOfClass: (week, lecturerid, cls) => {
        query = `UPDATE Teach SET Week = "${week}"
                WHERE LecturerID = "${lecturerid}" AND SubjectCode = "${cls.SubjectCode}"
                AND ClassName = "${cls.ClassName}" AND SemesterCode = "${cls.SemesterCode}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    removeWeekOfLecturerOfClass: (lecturerid, cls) => {
        query = `UPDATE Teach SET Week = null
                WHERE LecturerID = "${lecturerid}" AND SubjectCode = "${cls.SubjectCode}"
                AND ClassName = "${cls.ClassName}" AND SemesterCode = "${cls.SemesterCode}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    getClassByLecturerID: (lecturerid) => {
        return new Promise((res, rej) => {
            var query = `SELECT Code, Name, SemesterCode, NoOfCredits, ClassName, Week, CountStudentsInClass(Code, SemesterCode, ClassName) nstudents
            FROM Subject, Teach 
            WHERE LecturerID = "${lecturerid}" AND SubjectCode = Code;`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getClassOfLecturerInSemester: (lecturerid, semestercode) => {
        return new Promise((res, rej) => {
            var query = `SELECT Code, Name, NoOfCredits, ClassName, Week
            FROM Subject, Teach 
            WHERE LecturerID = "${lecturerid}" AND SubjectCode = Code AND SemesterCode = "${semestercode}"`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getNLecturersInSemesterGroupBySubject: (semestercode) => {
        return new Promise((res, rej) => {
            var query = `SELECT SubjectCode, COUNT(DISTINCT LecturerID) nlecturers FROM Teach
                        WHERE SemesterCode = "${semestercode}"
                        GROUP BY SubjectCode`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getOrderedSemestersOfLecturer: (lecturerid) => {
        return new Promise((res, rej) => {
            var query = `SELECT LecturerID, SemesterCode, COUNT(*) nclasses 
                        FROM Teach
                        WHERE LecturerID = 'GV12345'
                        GROUP BY LecturerID, SemesterCode
                        ORDER BY nclasses;`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getNClassesInNYear: (nyear, lecturerid) => {
        return new Promise((res, rej) => {
            var query = `SELECT LecturerID, COUNT(*) nclasses FROM Teach
                        WHERE 1 = SemesterInRangeNYear(SemesterCode, "${nyear}")
                        AND LecturerID = "${lecturerid}"
                        GROUP BY LecturerID`;
            DB.query(query, function (err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};