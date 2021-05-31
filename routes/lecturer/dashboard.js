var express = require('express');
var router = express.Router();
var dashboardController = require('../../controllers/lecturer/dashboardController');
// var studentController = require('../../controllers/faculty/student/Controller');

router.use(express.static('public'));
router.get('/', dashboardController.viewDashboard);
module.exports = router;