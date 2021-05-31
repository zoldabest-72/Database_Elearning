const DB = require('./connect');

module.exports = {
    getAll: (condition = {}) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Faculty`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getByCode: (FacultyCode) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM Faculty WHERE Code = "${FacultyCode}"`, function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });
    }
};