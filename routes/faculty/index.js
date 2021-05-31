var express = require('express');
var router = express.Router();
var subjectRouter = require('./subject');
var classRouter = require('./class');
var lecturerRouter = require('./lecturer');
/* GET home page. */

var checkPermit = require('../../utils/permitRole');
var checkLogined = require('../../utils/checkLogined')

router.use(express.static('public'));
router.use(checkLogined, checkPermit('FacultyOfficer'));

router.get('/', async function(req, res, next) {
    res.render('faculty/index', { Title: "Home", user: req.user });
});

router.use('/subject/', subjectRouter);
router.use('/class/', classRouter);
router.use('/lecturer/', lecturerRouter);
module.exports = router;