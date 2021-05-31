var express = require('express');
var router = express.Router();

var classController = require('../../controllers/lecturer/classController')


router.use(express.static('public'));
router.get('/:param', classController.viewDetail);
module.exports = router;