var express = require('express');
var router = express.Router();
var checkLogined = require('../utils/checkLogined')


/* GET home page. */
router.get('/', checkLogined, function(req, res, next) {
    if (req.user.role == 'Student') {
        res.redirect('/student');
    } else if (req.user.role == 'Lecturer') {
        res.redirect('/lecturer');
    } else if (req.user.role == 'AAOStaff') {
        res.redirect('/aao');
    } else if (req.user.role == 'FacultyOfficer') {
        res.redirect('/faculty');
    } else {
        res.redirect('/user/login');
    }
});

module.exports = router;