var jwt = require('jsonwebtoken');
const con = require('../models/connect');
var User = require('../models/user')
exports.login = async(req, res) => {
    var user = await User.getByEmail(req.body.email);
    if (user.length) {
        user = user[0];
        if (user.Password == req.body.password) {
            delete user.Password;
            user.role = await User.getRole(user.ID);
            if (user.role == 'Lecturer' || user.role == 'FacultyOfficer') {
                user.facultyCode = await User.getFacultyCode(user.ID);
            }
            const token = jwt.sign({...user }, process.env.JWT_SECRET, {
                expiresIn: process.env.JWT_EXPIRES_IN
            });
            res.cookie('jwt', token, {
                expires: new Date(
                    Date.now() + process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000
                ),
                httpOnly: true,
                secure: req.secure || req.headers['x-forwarded-proto'] === 'https'
            });

            // Remove password from output

            res.redirect('/');
        } else {
            res.render('auth/login', { user: req.user, email: req.body.email, errorPassword: "Password is incorrect!!!" })
        }
    } else {
        res.render('auth/login', { email: req.body.email, errorEmail: "Email isn't exist!!!" })
    }
}

exports.logout = (req, res) => {
    delete req.user;
    res.clearCookie('jwt');
    res.redirect('/');
}