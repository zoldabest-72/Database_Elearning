const Subject = require('../../models/subject');
const Class = require('../../models/class');
const Semester = require('../../models/semester');
const Faculty = require('../../models/faculty');
const Student = require('../../models/student');
const Lecturer = require('../../models/lecturer');

const { validationResult } = require('express-validator');
exports.viewAllClass = async(req, res) => {
    try {
        var condition = req.query;
        if (!("page" in condition)) {
            condition.page = 1;
        }
        if (!("limit" in condition)) {
            condition.limit = 10;
        }
        var classes = await Class.getAll(condition);
        var semester = await Semester.now();
        var subjects = await Subject.getSubjectInSemester(semester);
        var subjectsGroup = await Subject.getSubjectGroup();
        var semesters = await Semester.getAll();
        var faculties = await Faculty.getAll();
        var tempCond = {...condition };
        delete tempCond.limit;
        var max = (await Class.getAll(tempCond)).length;
        var pageMax = Math.ceil(max / condition.limit);
        res.render('aao/class/viewAll', {
            user: req.user,
            classes,
            subjects,
            subjectsGroup,
            semester,
            semesters,
            faculties,
            condition,
            pageMax,
            max
        });
    } catch (err) {
        res.status(401).send();
        console.log(err);
    }
}

exports.addNew = async(req, res) => {
    if (!validationResult(req).isEmpty()) {
        var errs = validationResult(req).array();
        return res.status(400).json(errs.map(err => ({ message: err.msg })));
    }
    try {
        var clas = req.body;
        await Class.add(clas);
        res.status(200).send('Thêm thành công');
    } catch (error) {
        var message = "";
        if (error.code == "ER_DATA_TOO_LONG") {
            message = "Tên của lớp học quá quá dài";
        } else if (error.code == "ER_DUP_ENTRY") {
            message = "Dữ liệu đã tồn tại";
        }
        res.status(400).send([{ message }]);
    }
}

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
        var clas = (await Class.getOne(params[0], params[1], params[2]))[0];
        var students = await Student.studentsInClass(params[0], params[1], params[2]);
        var lecturers = await Lecturer.lecturersOfClass(params[0], params[1], params[2]);
        res.render('aao/class/detail', { user: req.user, clas, students, lecturers, condition });
    } catch (error) {
        var message = "có lỗi";
        console.log(error);
        res.status(400).send([{ message }]);
    }
}