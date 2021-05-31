var express = require('express');
var router = express.Router();
var classController = require('../../controllers/student/classController');


router.get('/', classController.SemesterInfo);
router.post('/', classController.getInfoSemester);
router.post('/allclass', classController.allclass);
router.post('/speclass', classController.speclass);
module.exports = router;