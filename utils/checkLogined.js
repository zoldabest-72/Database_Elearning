// const { token } = require("morgan")

var jwt = require('jsonwebtoken');
module.exports = (req, res, next) => {
    var token = req.cookies.jwt || '';
    if (token) {
        req.user = jwt.decode(token, process.env.JWT_SECRET);

        next();
    } else if (req.originalUrl == '/user/login') next();
    else {
        res.redirect('/user/login')
    }
}