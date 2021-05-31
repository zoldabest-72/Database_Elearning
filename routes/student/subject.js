var express = require('express');
const { route } = require('..');
var router = express.Router();
var subjectController = require('../../controllers/student/subjectController')


router.use(express.static('public'));

router.route('/')
    .get(subjectController.enroll)
    .post(subjectController.enroll)
module.exports = router;