var express = require('express');
var router = express.Router();
var subjectRouter = require('./subject');
var classRouter = require('./class');

var dashboardRouter = require('./dashboard');
/* GET home page. */

var checkPermit = require('../../utils/permitRole');

var checkLogined = require('../../utils/checkLogined')

router.use(express.static('public'));
router.use(checkLogined, checkPermit('Lecturer'));
router.get('/', async function(req, res, next) {
    res.render('lecturer/index', { user: req.user });
});

router.use('/subject/', subjectRouter);

router.use('/class/', classRouter);




router.use('/dashboard', dashboardRouter);
module.exports = router;