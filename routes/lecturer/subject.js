var express = require('express');
var router = express.Router();

var subjectController = require('../../controllers/lecturer/subjectController')


router.use(express.static('public'));
router.get('/', subjectController.viewAll);
router.get('/teaching', subjectController.viewSubjectTeaching);

router.get('/textbooks', subjectController.getTextbook);

router.post('/settextbooks', subjectController.setTextbook);

router.get('/:subjectCode', subjectController.viewClassOfSubjectInSemester);
module.exports = router;