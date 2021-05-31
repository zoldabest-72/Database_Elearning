const Class = require('../../models/class');
const Student = require('../../models/student');
const Lecturer = require('../../models/lecturer');
exports.viewDetail = async(req, res) => {
    try {
        var condition = req.query;
        if (!("page" in condition)) {
            condition.page = 1;
        }
        if (!("limit" in condition)) {
            condition.limit = 10;
        }
        var params = req.params.param.split('__');
        var classes = await Class.getOne(params[0], params[1], params[2]);
        var students = await Student.studentsInClass(params[0], params[1], params[2]);
        // var lecturers = await Lecturer.lecturersOfClass(params[0], params[1], params[2]);
        res.render('lecturer/class/detail', { user: req.user, classes, students, condition });
    } catch (error) {
        var message = "có lỗi";
        console.log(error);
        res.status(400).send([{ message }]);
    }
}