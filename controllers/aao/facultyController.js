const Subject = require('../../models/subject');
const Class = require('../../models/class');
const Semester = require('../../models/semester');
const Faculty = require('../../models/faculty');

const { validationResult } = require('express-validator');
exports.viewAllFaculty = async(req, res) => {
    try {
        var faculties = await Faculty.getAll();
        res.render('aao/faculty/viewAll', { faculties });
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
        if (!("keySearch" in condition)) {
            condition.keySearch = '';
        }
        condition.SFacultyCode = req.params.FacultyCode;
        var subjects = await Subject.subjectsOfFaculty(condition);
        var semester = await Semester.now();
        var subjectsInSemester = subjects.filter(subject => subject.SemesterCode == semester);
        var semesters = await Semester.getAll();
        var subjectsGroup = await Subject.getSubjectGroup();
        var faculties = await Faculty.getAll();
        var faculty = (await Faculty.getByCode(req.params.FacultyCode))[0];
        var tempCond = {...condition };
        delete tempCond.limit;
        var max = (await Subject.subjectsOfFaculty(tempCond)).length;
        var pageMax = Math.ceil(max / condition.limit);
        res.render('aao/faculty/detail', {
            user: req.user,
            condition,
            subjects,
            faculty,
            subjectsGroup,
            subjectsInSemester,
            semester,
            semesters,
            faculties,
            condition,
            pageMax,
            max
        });
    } catch (error) {
        var message = "có lỗi";
        console.log(error);
        res.status(400).send([{ message }]);
    }
}