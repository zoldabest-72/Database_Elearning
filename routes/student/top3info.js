var express = require('express');
var router = express.Router();
var classController = require('../../controllers/student/classController');

router.get('/', classController.getTop3Info);
module.exports = router;