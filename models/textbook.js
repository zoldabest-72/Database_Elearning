const DB = require('./connect');

module.exports = {
    textbooksForSubject: (SubjectCode, condition = {}) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM (Textbook JOIN UseFor ON Code = TextbookCode) WHERE SubjectCode = "${SubjectCode}" `;
            // if ("keySearch" in condition) {
            //     query += `AND CONCAT(SubjectCode,SemesterCode,ClassName,Name,FacultyCode) LIKE "%${condition.keySearch}%" `
            // }
            if ("Semester" in condition && condition.Semester != -1) {
                query += `AND SemesterCode = "${condition.Semester}" `
            }
            // if ("limit" in condition) {
            //     query += `LIMIT ${condition.limit} OFFSET ${(condition.page-1)*condition.limit}`;
            // }
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    getAllNotIN: (textbooks) => {
        return new Promise((res, rej) => {
            var query = `SELECT * FROM Textbook`;
            if (textbooks.length != 0) {
                var a = textbooks.map(tb => `"${tb.Code}"`).join(',');
                query += ` WHERE Code NOT IN (${a})`;
            }
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    removedTextbooksForSubject: (subjectCode, semester, books = []) => {
        return new Promise((res, rej) => {
            var query = `DELETE FROM UseFor WHERE SubjectCode = ${subjectCode} AND SemesterCode = ${semester}`;
            if (books.length != 0) {
                var a = books.map(tb => `"${tb}"`).join(',');
                query += ` AND TextbookCode NOT IN (${a})`;
            }
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    },
    insertTextbooksForSubject: (subjectCode, semester, userID, books = []) => {
        if (books.length == 0) return;
        return new Promise((res, rej) => {
            var a = books.map(tb => `("${tb}","${subjectCode}","${userID}","${semester}")`).join(',');
            var query = `INSERT INTO UseFor VALUES${a}`;
            console.log(query);
            DB.query(query, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            })
        })
    }
};