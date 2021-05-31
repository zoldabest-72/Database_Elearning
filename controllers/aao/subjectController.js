const Subject = require('../../models/subject');
const Class = require('../../models/class');
const Semester = require('../../models/semester');
const Faculty = require('../../models/faculty');
const Textbook = require('../../models/textbook')


exports.viewAllSubject = async(req, res) => {
    try {
        var condition = req.query;
        if (!("page" in condition)) {
            condition.page = 1;
        }
        if (!("limit" in condition)) {
            condition.limit = 10;
        }
        var subjects = await Subject.getAll(condition);

        var semester = await Semester.now();
        var semesters = await Semester.getAll();
        var subjectsGroup = await Subject.getSubjectGroup();
        var faculties = await Faculty.getAll();
        var tempCond = {...condition };
        delete tempCond.limit;
        var max = (await Subject.getAll(tempCond)).length;
        var pageMax = Math.ceil(max / condition.limit);
        res.render('aao/subject/viewAll', {
            user: req.user,
            condition,
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
        console.log(err);
        res.status(401).json(err);
    }
}

exports.addForm = (req, res) => {
    res.render('faculty/subject/add');
}
exports.addNew = async(req, res) => {
    try {
        var subject = req.body;
        subject.facultyCode = req.user.facultyCode;
        await Subject.add(subject);
    } catch (error) {
        console.log(error);
        res.status(401).send();
    }
}
exports.viewDetail = async(req, res) => {
    try {
        var condition = req.query;
        if (!("Semester" in condition)) {
            condition.Semester = await Semester.now();
        }
        if (!("page" in condition)) {
            condition.page = 1;
        }
        if (!("limit" in condition)) {
            condition.limit = 10;
        }
        var textbooks = await Textbook.textbooksForSubject(req.params.ID);
        var subject = await Subject.getByCode(req.params.ID);
        var semesters = await Semester.getAll();
        var classes = await Class.classesOfSubject(req.params.ID);
        res.render('aao/subject/detail', { textbooks, subject, semesters, classes, condition });
    } catch (error) {
        var message = "có lỗi";
        console.log(error);
        res.status(400).send([{ message }]);
    }
}