var express = require('express');
var router = express.Router();
var facultyController = require('../../controllers/aao/facultyController')

const { AAOaddClassForm } = require('../../utils/validator');

router.use(express.static('public'));
router.get('/', facultyController.viewAllFaculty);
router.get('/:FacultyCode', facultyController.viewDetail);
router.post('/add', AAOaddClassForm, facultyController.addNew);

module.exports = router;