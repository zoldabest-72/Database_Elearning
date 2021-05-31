const con = require('../../models/connect');
const Cls = require('../../models/class');
const Teach = require('../../models/teach');
const Learn = require('../../models/learn');
const Semester = require('../../models/semester');
module.exports = {
    viewClasses: async (req, res, next) => {
        if (req.query.cls) {
            if (req.query.week === '') {
                await Teach.removeWeekOfLecturerOfClass(
                    req.query.lecturerid,
                    JSON.parse(req.query.cls)
                );
            } else {
                await Teach.updateWeekOfLecturerOfClass(
                    req.query.week,
                    req.query.lecturerid,
                    JSON.parse(req.query.cls)
                );
            }
            res.redirect('/faculty/class');
        }
        else {
            var classes, nstudent;
            var cursemester = await Semester.getCurrentSemester();
            cursemester = cursemester[0].Code;
            if (req.query.semester) {
                classes = await Cls.getClassInSemester(req.query.semester);
                console.log(classes)
                nstudent = await Learn.getNStudentInSemester(req.query.semester);
            } else {
                classes = await Cls.getAll();
                nstudent = await Learn.getNStudent();
            }
            var lecturers = await Teach.getAll();
            res.render('faculty/class/viewClasses', {
                Title: 'Classes',
                Classes: classes,
                lecturers: lecturers,
                Semester: req.query.semester,
                CurSemester: cursemester,
                NStudent: nstudent,
                user: req.user
            });
        }
    },
    viewStudentInClass: async (req, res, next) => {
        // try {
        var cls = {
            SubjectCode: req.query.subjectcode,
            SubjectName: req.query.subjectname,
            ClassName: req.query.classname,
            SemesterCode: req.query.semestercode,
        };
        var students = await Learn.getStudentInClass(cls);
        res.render('faculty/class/viewStudents', {
            Title: "Class's Students",
            Students: students,
            Cls: cls,
            user: req.user
        });
        // } catch (err) {
        //     res.status(401).json(err);
        // }
    }
}