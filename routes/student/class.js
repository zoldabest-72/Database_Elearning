var express = require('express');
const { route } = require('..');
var router = express.Router();
var classController = require('../../controllers/student/classController')


router.use(express.static('public'));

router.route('/')
    .get(classController.page)
    .post(classController.page)
module.exports = router;