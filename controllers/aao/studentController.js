const Subject = require('../../models/subject');
const Semester = require('../../models/semester');
const Faculty = require('../../models/faculty');
const Student = require('../../models/student');
const Class = require('../../models/class');

const { validationResult } = require('express-validator');
const con = require('../../models/connect');
exports.viewAllStudent = async(req, res) => {
    try {
        var condition = req.query;
        if (!("page" in condition)) {
            condition.page = 1;
        }
        if (!("limit" in condition)) {
            condition.limit = 10;
        }
        var students = await Student.getAll(condition);
        var semester = await Semester.now();
        var subjects = await Subject.getSubjectInSemester(semester);
        var semesters = await Semester.getAll();
        var faculties = await Faculty.getAll();
        var tempCond = {...condition };
        delete tempCond.limit;
        var max = (await Student.getAll(tempCond)).length;
        var pageMax = Math.ceil(max / condition.limit);
        res.render('aao/student/viewAll', {
            user: req.user,
            students,
            subjects,
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
        if (!("Semester" in condition)) {
            condition.Semester = await Semester.now();
        }
        var student = await Student.getByID(req.params.ID);
        var classes = await Class.classOfStudent(req.params.ID, condition.Semester);
        var semesters = await Semester.getAll();
        res.render('aao/student/detail', { student, classes, semesters, condition });
    } catch (error) {
        var message = "có lỗi";
        console.log(error);
        res.status(400).send([{ message }]);
    }
}