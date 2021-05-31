var express = require('express');
var router = express.Router();
var classController = require('../../controllers/aao/classController')

const { AAOaddClassForm } = require('../../utils/validator');

router.use(express.static('public'));
router.get('/', classController.viewAllClass);
router.get('/:param', classController.viewDetail);
router.post('/add', AAOaddClassForm, classController.addNew);

module.exports = router;