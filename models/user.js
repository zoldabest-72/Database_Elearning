const DB = require('./connect');

module.exports = {
    getAll: () => {
        return new Promise((res, rej) => {
            DB.query("SELECT * FROM Student", function(err, result, fields) {
                if (err) rej(err);
                res(result);
            });
        });

    },
    getByEmail: (email) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT * FROM User WHERE email = "${email}"`, function(err, result) {
                if (err) rej(err);
                res(result);
            });
        });
    },
    getRole: (ID) => {
        return new Promise((res, rej) => {
            DB.query(`CALL getRole("${ID}",@role)`);
            DB.query(`SELECT @role as role;`, function(err, result, fields) {
                if (err) rej(err);
                res(result[0].role);
            });
        })
    },
    getFacultyCode: (ID) => {
        return new Promise((res, rej) => {
            DB.query(`SELECT FacultyCode FROM FacultyStaff WHERE ID = "${ID}"`, function(err, result, fields) {
                if (err) rej(err);
                res(result[0].FacultyCode);
            });
        })
    }
};