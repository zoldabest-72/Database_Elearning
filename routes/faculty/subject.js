var express = require('express');
var router = express.Router();
var subjectController = require('../../controllers/faculty/subjectController')


router.use(express.static('public'));
router.get('/', subjectController.viewAllSubject);
router.get('/open', subjectController.viewAllSubjectOpened);
router.route('/add')
    .post(subjectController.addNew);
router.route('/remove')
    .get(subjectController.remove);
router.post('/open/add', subjectController.openNew)
router.get('/info', subjectController.getInfo);
module.exports = router;