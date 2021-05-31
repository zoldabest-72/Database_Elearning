var express = require('express');
var router = express.Router();
var lecturerController = require('../../controllers/aao/lecturerController')

router.use(express.static('public'));
router.get('/', lecturerController.viewAllLecturer);
router.get('/:ID', lecturerController.viewDetail);
router.post('/add', lecturerController.addNew);

module.exports = router;