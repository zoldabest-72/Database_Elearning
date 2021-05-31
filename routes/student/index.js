var express = require('express');
var router = express.Router();
var subjectRouter = require('./subject');
// var classRouter = require('./class');
var Register = require('./register');
var Info = require('./info');
var Top3Info = require('./top3info');
/* GET home page. */
var checkPermit = require('../../utils/permitRole');
var checkLogined = require('../../utils/checkLogined');

router.use(express.static('public'));
router.use(checkLogined, checkPermit('Student'));
router.get('/', async function (req, res, next) {
    res.render('student/index', {});
});

router.use('/subject', subjectRouter);
// router.use('/class', classRouter);

router.use('/register', Register);
router.use('/info', Info);
router.use('/top3info', Top3Info);
module.exports = router;