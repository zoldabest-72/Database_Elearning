var express = require('express');
var router = express.Router();
var subjectController = require('../../controllers/aao/subjectController')


router.use(express.static('public'));
router.get('/', subjectController.viewAllSubject);
router.get('/:ID', subjectController.viewDetail);

router.route('/add')
    .get(subjectController.addForm)
    .post(subjectController.addNew)
module.exports = router;