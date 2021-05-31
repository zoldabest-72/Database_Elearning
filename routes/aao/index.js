var express = require('express');
var router = express.Router();
var subjectRouter = require('./subject');
var classRouter = require('./class');
var studentRouter = require('./student');
var lecturerRouter = require('./lecturer');
var facultyRouter = require('./faculty');
var semesterRouter = require('./semester');
var checkPermit = require('../../utils/permitRole');

var checkLogined = require('../../utils/checkLogined')

router.use(express.static('public'));
router.use(checkLogined, checkPermit('AAOStaff'));
router.get('/', async function(req, res, next) {
    res.render('aao/index', { user: req.user });
});

router.use('/subject/', subjectRouter);
router.use('/class/', classRouter);

router.use('/student/', studentRouter);
router.use('/lecturer/', lecturerRouter);

router.use('/faculty', facultyRouter);
router.use('/semester', semesterRouter);

module.exports = router;