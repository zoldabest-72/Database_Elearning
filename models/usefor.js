const DB = require('./connect');

module.exports = {
    getTextbookBySubjectAndSemester: (subjectcode, semestercode) => {
        return new Promise((res, rej) => {
            sql = `SELECT T.*, SubjectCode, SemesterCode, S.Name SubjectName
                    FROM Textbook T, UseFor, Subject S
                    WHERE TextbookCode = T.Code 
                    AND SubjectCode = "${subjectcode}"
                    AND SemesterCode = "${semestercode}"
                    AND SubjectCode = S.Code`;
            DB.query(sql, (err, result, fields) => {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getTextbook: (SubjectCode, SemesterCode) => {
        return new Promise((res, rej) => {
            DB.query(`select Textbook.Name from Textbook,UseFor where
                (UseFor.SubjectCode = '${SubjectCode}' and UseFor.SemesterCode = '${SemesterCode}' and UseFor.TextbookCode = Textbook.Code);`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};