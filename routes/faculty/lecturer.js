var express = require('express');
var router = express.Router();
var lecturerController = require('../../controllers/faculty/lecturerController');

router.use(express.static('public'));
router.get('/', lecturerController.viewLecturer);
router.get('/class', lecturerController.viewLecturerClass);

module.exports = router;