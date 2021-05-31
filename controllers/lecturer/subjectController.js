const Subject = require('../../models/subject');
const Textbook = require('../../models/textbook');
const Semester = require('../../models/semester');
const Class = require('../../models/class');


exports.viewAll = async(req, res) => {
    try {
        var condition = req.query;
        if (!("Semester" in condition)) {
            condition.Semester = (await Semester.getCurrentSemester())[0].Code;
        }
        var semesters = await Semester.getAll();
        var subjects = await Subject.subjectsTeachedBy(req.user.ID, condition.Semester);
        res.render('lecturer/subject/viewAll', { user: req.user, subjects, semesters, condition, Title: "Subject" });
    } catch (err) {
        console.log(err);
        res.status(401).json(err);
    }
}



exports.viewSubjectTeaching = async(req, res) => {
    try {
        var semester = await Semester.getCurrentSemester();
        var subjects = await Subject.subjectsTeachedBy(req.user.ID, semester[0].Code);
        res.render('lecturer/subject/viewSubjectTeaching', { user: req.user, subjects, Title: "Subject" });
    } catch (err) {
        console.log(err);
        res.status(401).json(err);
    }

}

exports.getTextbook = async(req, res) => {
    try {
        var semester = req.query.semesterCode || (await Semester.getCurrentSemester())[0].Code;
        var textbooks = await Textbook.textbooksForSubject(req.query.subjectCode, { Semester: semester });
        var textbooksNotUse = await Textbook.getAllNotIN(textbooks);
        res.json({ textbooks, textbooksNotUse });
    } catch (err) {
        console.log(err);
        res.status(401).json(err);
    }
}
exports.setTextbook = async(req, res) => {
    try {
        var semester = await Semester.getCurrentSemester();
        if (!('books[]' in req.body)) {
            req.body['books[]'] = []
        } else if (typeof(req.body['books[]']) != 'object') {
            req.body['books[]'] = [req.body['books[]']]
        }

        await Textbook.removedTextbooksForSubject(req.body.subjectCode, semester[0].Code);
        await Textbook.insertTextbooksForSubject(req.body.subjectCode, semester[0].Code, req.user.ID, req.body['books[]']);
        res.json({ message: "Chọn giáo trình thành công!" });
    } catch (err) {
        console.log(err);
        res.status(401).json(err);
    }
}


exports.viewClassOfSubjectInSemester = async(req, res) => {
    try {
        var condition = req.query;
        var classes = await Class.classOfLecturerOfSubject(req.user.ID, req.params.subjectCode, condition.Semester || null);
        var semesters = await Semester.getAll();
        res.render('lecturer/class/viewAll', {
            user: req.user,
            classes,
            semesters,
            subjectCode: req.params.subjectCode,
            condition
        })
    } catch (err) {
        res.status(401).send();
        console.log(err);
    }
}