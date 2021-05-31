var express = require('express');
var router = express.Router();
var classController = require('../../controllers/student/classController');

router.get('/', classController.classRegister);
router.post('/', classController.viewClass);
router.post('/add', classController.SignClass);
module.exports = router;