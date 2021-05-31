var express = require('express');
var router = express.Router();

var authController = require('../controllers/authController')
var checkLogined = require('../utils/checkLogined')

router.get("/login", checkLogined, (req, res) => {
    if (req.user) {
        res.redirect('/');
    } else {
        res.render('auth/login', { user: undefined });
    }
});

router.post("/login", authController.login);

router.get('/logout', authController.logout);

module.exports = router;