var express = require('express');
var router = express.Router();
var semesterController = require('../../controllers/aao/semesterController')

router.use(express.static('public'));
router.get('/', semesterController.now);
router.post('/', semesterController.addNew);

module.exports = router;