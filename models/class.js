const DB = require('./connect');
const lecturer = require('./lecturer');

module.exports = {
    getAll: (condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Class JOIN Subject on SubjectCode = Code) `;
            if ("keySearch" in condition) {
                query += `WHERE CONCAT(SubjectCode,SemesterCode,ClassName,Name,FacultyCode) LIKE "%${condition.keySearch}%" `
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
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    add: (clas) => {
        return new Promise((res, rej) => {
            DB.query(`INSERT INTO Class(SubjectCode, SemesterCode, ClassName) VALUES("${clas.SubjectCode}","${clas.Semester}","${clas.name}")`, function(err, result, fields) {
                if (err) rej(err);

            })
            var classTime = clas.times.map(ct => `("${clas.SubjectCode}","${clas.Semester}","${clas.name}","${ct.date}",'${ct.start}:00:00','${ct.finish}:00:00',"${ct.room}","${clas.week}")`).join(',');
            DB.query(`INSERT INTO ClassTime VALUES${classTime}`, function(err, result, fields) {
                if (err) rej(err);

            })
            res();
        })
    },
    classOfStudent: (ID, semesterCode = null) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Learn JOIN Subject on SubjectCode = Code) WHERE StudentID = "${ID}"`;
            if (semesterCode != null) {
                query += ` AND SemesterCode = "${semesterCode}"`
            }
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    classOfLecturer: (ID) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Teach JOIN Subject on SubjectCode = Code) WHERE LecturerID = "${ID}"`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getOne: (SubjectCode, SemesterCode, ClassName) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Class JOIN Subject on SubjectCode = Code) WHERE SubjectCode ="${SubjectCode}" AND SemesterCode = "${SemesterCode}" AND ClassName = "${ClassName}"`;
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getClassDetailsByStudentID: (studentid) => {
        return new Promise((res, rej) => {
            var query = `SELECT Code, Name, NoOfCredits, T.ClassName, getUserFullName(MainLecturerID) Lecturer, T.Date, getPeriod(T.StartTime, T.FinishTime) Period, T.Room
            FROM Subject, Class C, Learn L, ClassTime T
            WHERE L.StudentID = "${studentid}" AND Code = L.SubjectCode
                AND C.SubjectCode = L.SubjectCode AND C.SemesterCode = L.SemesterCode AND C.ClassName = L.ClassName
                AND C.SubjectCode = T.SubjectCode AND C.SemesterCode = T.SemesterCode AND C.ClassName = L.ClassName;`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getClassByLecturerID: (lecturerid) => {
        return new Promise((res, rej) => {
            var query = `SELECT Code, Name, SemesterCode, NoOfCredits, ClassName, Week, CountStudentsInClass(Code, SemesterCode, ClassName) nstudents
            FROM Subject, Teach 
            WHERE LecturerID = "${lecturerid}" AND SubjectCode = Code;`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getClassOrderedByNStudentsByLecturerID: (lecturerid) => {
        return new Promise((res, rej) => {
            var query = `SELECT Code, Name, SemesterCode, NoOfCredits, ClassName, Week, CountStudentsInClass(Code, SemesterCode, ClassName) nstudents
            FROM Subject, Teach 
            WHERE LecturerID = "${lecturerid}" AND SubjectCode = Code
            ORDER BY nstudents`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getClassInSemester: (semestercode) => {
        return new Promise((res, rej) => {
            query = `SELECT C.SubjectCode, S.Name, C.ClassName, C.SemesterCode, C.MainLecturerID FROM Class C, Subject S WHERE C.SubjectCode = S.Code AND SemesterCode = "${semestercode}"`;
            // query = `SELECT C.SubjectCode, C.ClassName, C.SemesterCode, L.Lecturers, L.Weeks 
            //         FROM Class C, LecturersOfClass L 
            //         WHERE C.SemesterCode = "${semestercode}"
            //         AND C.SubjectCode = L.SubjectCode
            //         AND C.ClassName = L.ClassName
            //         AND C.SemesterCode = L.SemesterCode`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    getClassTime: (SemesterCode, ClassName, SubjectCode) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM ClassTime WHERE SemesterCode ='${SemesterCode}' and ClassName = '${ClassName}' and SubjectCode = '${SubjectCode}';`,
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },

    getClassByInfo: (cls) => {
        return new Promise((res, rej) => {
            query = `SELECT * FROM Class
                WHERE SubjectCode = "${cls.SubjectCode}"
                AND ClassName = "${cls.ClassName}"
                AND SemesterCode = "${cls.SemesterCode}"`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    getNoOfStudents: (SubjectCode, SemesterCode, ClassName) => {
        return new Promise((res, rej) => {
            DB.query(`select count(*) as NoOfStudents from 
            Learn where (SemesterCode ='${SemesterCode}' and ClassName='${ClassName}' and SubjectCode='${SubjectCode}');`,
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },
    classesOfSubject: (subjectCode) => {
        return new Promise((res, rej) => {
            var query = `SELECT Class.ClassName AS ClassName, Class.SemesterCode AS SemesterCode, NumberStudent FROM (Class LEFT JOIN (SELECT ClassName,SubjectCode, SemesterCode,COUNT(*) AS NumberStudent FROM Learn GROUP BY ClassName,SubjectCode, SemesterCode) AS Learn ON Learn.SubjectCode = Class.SubjectCode AND Learn.SemesterCode = Class.SemesterCode AND Learn.ClassName = Class.ClassName) WHERE Class.SubjectCode = "${subjectCode}"`;
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },

    getMainLecturerNameByClass: (cls) => {
        return new Promise((res, rej) => {
            query = `SELECT getUserFullName(MainLecturerID) FROM Class
                        WHERE SubjectCode = "${cls.SubjectCode}"
                        AND ClassName = "${cls.ClassName}"
                        AND SemesterCode = "${cls.SemesterCode}"`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    getTeacher: (SubjectCode, SemesterCode, ClassName) => {
        return new Promise((res, rej) => {
            DB.query(`select User.ID,User.Fname,User.Mname,User.Lname from Teach,User where
            (Teach.SubjectCode = '${SubjectCode}' and Teach.SemesterCode='${SemesterCode}' and Teach.ClassName='${ClassName}' 
            and Teach.LecturerID = User.ID);`,
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },
    updateMainLecturerOfClass: (lecturerid, clas) => {
        query = `UPDATE Class
                SET MainLecturerID = "${lecturerid}"
                WHERE SubjectCode = "${clas.SubjectCode}"
                AND ClassName = "${clas.ClassName}"
                AND SemesterCode = "${clas.SemesterCode}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    removeMainLecturerOfClass: (clas) => {
        query = `UPDATE Class
                SET MainLecturerID = null
                WHERE SubjectCode = "${clas.SubjectCode}"
                AND ClassName = "${clas.ClassName}"
                AND SemesterCode = "${clas.SemesterCode}"`;
        DB.query(query, (err, result, fields) => {
            if (err) console.log(err)
            console.log(result);
        });
    },
    getMainLecturerOfClass: (clas) => {
        return new Promise((res, rej) => {
            query = `SELECT LecturerID, getUserFullName(ID) Fullname FROM Manage
                    WHERE SubjectCode = "${clas.SubjectCode}"
                    AND ClassName = "${clas.ClassName}"
                    AND SemesterCode = "${clas.SemesterCode}"`;
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    getListClass: (SubjectCode, SemesterCode) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT Class.SubjectCode,Subject.Name,Class.SemesterCode, Class.ClassName,ClassTime.Date,ClassTime.StartTime,ClassTime.FinishTime,ClassTime.Room,ClassTime.Week FROM ((Class JOIN Subject ON Class.SubjectCode = Subject.Code) JOIN ClassTime ON (Class.SemesterCode = ClassTime.SemesterCode AND Class.ClassName = ClassTime.ClassName AND Class.SubjectCode = ClassTime.SubjectCode)) where Class.SubjectCode = '${SubjectCode}' AND Class.SemesterCode = '${SemesterCode}';`,
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },
    classOfLecturerOfSubject: (lecturerID, subjectCode, semesterCode = null) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM Teach WHERE LecturerID = "${lecturerID}" AND SubjectCode = "${subjectCode}" `;
            if (semesterCode && semesterCode != -1) {
                query += ` AND SemesterCode = "${semesterCode}"`
            }
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        })
    },
    changeClass: (ClassName, StudentID, SubjectCode, SemesterCode) => {
        return new Promise((res, rej) => {
            DB.query(`update Learn
            set ClassName='${ClassName}' where (StudentID='${StudentID}' and SubjectCode='${SubjectCode}' and SemesterCode='${SemesterCode}');`,
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },
    getLearning: (userID, semesterCode) => {
        return new Promise((res, rej) => {
            var query = `SELECT Enroll.SubjectCode AS SubjectCode, Code, Name, NoOfCredits, Learn.ClassName AS ClassName, Date,StartTime,FinishTime,Room FROM ((Enroll JOIN Subject on Code = SubjectCode) LEFT JOIN (Learn JOIN ClassTime ON Learn.SubjectCode = ClassTime.SubjectCode AND Learn.SemesterCode = ClassTime.SemesterCode AND Learn.ClassName = ClassTime.ClassName) ON Learn.SubjectCode = Enroll.SubjectCode AND Learn.SemesterCode = Enroll.SemesterCode AND Learn.StudentID = Enroll.StudentID) WHERE Enroll.StudentID = "${userID}" AND Enroll.SemesterCode = "${semesterCode}";`
            DB.query(query, // @@ câu lệnh khủng bố hôm qua à , đúng rồi á, chạy lại thử
                function(err, result, fields) {
                    if (err) rej(err);
                    res(result);
                });
        });
    },
    insertClass: (ClassName, userID, SubjectCode, SemesterCode) => {
        DB.query(`INSERT INTO Learn VALUES("${userID}","${SubjectCode}","${SemesterCode}","${ClassName}",NULL,NULL,NULL,NULL,NULL)`,
            function(err, result, fields) {
                if (err) throw err;
            });
    },


};