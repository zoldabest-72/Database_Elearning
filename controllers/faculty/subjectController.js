const con = require('../../models/connect');
const Subject = require('../../models/subject');
const Enroll = require('../../models/enroll');
const Semester = require('../../models/semester');
const Usefor = require('../../models/usefor');
const Teach = require('../../models/teach');
const OpenedIn = require('../../models/openedin');
module.exports = {
    viewAllSubject: async(req, res) => {
        try {
            var subjects = await Subject.getAll();
            subjects = subjects.filter(subject => subject.FacultyCode == req.user.facultyCode);
            var semester = await Semester.getCurrentSemester();
            semester = semester[0].Code;
            if (req.query.semester) semester = req.query.semester;
            var nlecturers = await Teach.getNLecturersInSemesterGroupBySubject(semester);
            res.render('faculty/subject/viewAll', {
                Title: "Subject",
                user: req.user,
                subjects: subjects,
                Semester: semester
            });
        } catch (err) {
            console.log(err);
            res.status(401).json(err);
        }

    },
    addNew: async(req, res) => {
        try {
            var subject = req.body;
            subject.facultyCode = req.user.facultyCode;
            await Subject.add(subject);
            res.redirect('/faculty/subject');
        } catch (error) {
            console.log(error);
            res.status(401).send();
        }
    },
    edit: async(req, res) => {
        try {
            var subjectcode = req.query.edit;
            res.redirect('/faculty/subject');
        } catch {
            console.log(error);
            res.status(401).send();
        }
    },
    remove: async(req, res, next) => {
        try {
            var subjectcode = req.query.remove;
            await Subject.removeSubjectByCode(subjectcode);
            res.redirect('/faculty/subject');
        } catch (error) {
            console.log(error);
            res.status(401).send();
        }
    },
    getInfo: async(req, res) => {
        try {
            var subject = await Subject.getSubjectByCode(req.query.subjectcode);
            var semester = await Semester.getCurrentSemester();
            semester = semester[0].Code;
            if (req.query.semester) semester = req.query.semester;
            var nyear = 3;
            if (req.query.nyear) nyear = parseInt(req.query.nyear);
            var textbooks = await Usefor.getTextbookBySubjectAndSemester(req.query.subjectcode, semester)
            var nstudent = await Enroll.getNumberOfStudentEnrollSubjectInNYearAgo(req.query.subjectcode, nyear);
            console.log(nstudent)
            res.render('faculty/subject/viewSubjectInfo', {
                Title: 'Subject Info',
                Subject: subject,
                Textbooks: textbooks,
                Semester: semester,
                NStudent: nstudent,
                nyear: nyear,
                user: req.user
            });
        } catch (error) {
            console.log(error);
            res.status(401).send();
        }
    },
    viewAllSubjectOpened: async(req, res, next) => {
        try {
            if (req.query.rmcode) {
                await OpenedIn.removeSubjectOpenedInSemesterByCode(req.query.rmcode, req.query.semester)
                res.redirect('/faculty/subject/open?semester=' + req.query.semester);
            }
            var semester = await Semester.getCurrentSemester();
            semester = semester[0].Code;
            var nextsemester = parseInt(semester) + 1;
            nextsemester = nextsemester.toString();
            if (req.query.semester) semester = req.query.semester;
            var openedsubjects = await OpenedIn.getAll();
            openedsubjects = openedsubjects.filter(x => x.FacultyCode === req.user.facultyCode && x.SemesterCode === semester);
            var subjects = await Subject.getAll();
            subjects = subjects.filter(x => {
                for (var i = 0; i < openedsubjects.length; i++) {
                    if (openedsubjects[i].Code === x.Code) return false;
                }
                return x.FacultyCode === req.user.facultyCode;
            });

            var nlecturers = await Teach.getNLecturersInSemesterGroupBySubject(semester);
            res.render('faculty/subject/viewOpenedSubject', {
                Title: "Subject",
                user: req.user,
                OpenedSubjects: openedsubjects,
                Subjects: subjects,
                Semester: semester,
                NextSemester: nextsemester,
                NLecturers: nlecturers
            });
        } catch (err) {
            res.status(401).json(err);
        }
    },
    openNew: async(req, res, next) => {
        try {
            if (req.body.subjectcode && req.body.semester) {
                await OpenedIn.openSubjectInSemester(req.body.subjectcode, req.body.semester);
            }
            res.redirect('/faculty/subject/open?semester=' + req.body.semester);
        } catch (error) {
            res.status(401).json(error);
        }
    }
}