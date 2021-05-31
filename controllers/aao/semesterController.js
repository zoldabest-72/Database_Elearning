const con = require('../../models/connect');
var Semester = require('../../models/semester');
exports.now = async(req, res) => {
    var semesters = await Semester.getAll();
    semesters.reverse();
    res.render('aao/semester/viewAll', { user: req.user, semesters });
}
exports.addNew = async(req, res) => {
    try {
        await Semester.add(req.body);
        res.redirect('/aao/semester');
    } catch (error) {
        console.log(error);
        res.status(400).json({ mess: "lỗi database" });
    }
}