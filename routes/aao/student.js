var express = require('express');
var router = express.Router();
var studentController = require('../../controllers/aao/studentController')

router.use(express.static('public'));
router.get('/', studentController.viewAllStudent);
router.get('/:ID', studentController.viewDetail);
router.post('/add', studentController.addNew);

module.exports = router;