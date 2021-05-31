var express = require('express');
var router = express.Router();
var classController = require('../../controllers/faculty/classController');
var lecturerController = require('../../controllers/faculty/lecturerController');
// var studentController = require('../../controllers/faculty/student/Controller');

router.use(express.static('public'));
router.get('/', classController.viewClasses);

router.get('/edit', lecturerController.viewEditLecturer);
router.post('/edit', lecturerController.editLecturer);

router.get('/student', classController.viewStudentInClass);
module.exports = router;