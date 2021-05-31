const con = require('../../models/connect');
const Teach = require('../../models/teach');
const Cls = require('../../models/class');
const Lecturer = require('../../models/lecturer');

module.exports = {
    viewEditLecturer: async (req, res, next) => {
        try {
            var cls = {
                SubjectCode: req.query.subjectcode,
                Name: req.query.subjectname,
                ClassName: req.query.classname,
                SemesterCode: req.query.semestercode,
            };
            var lecturers = await Teach.getAll();
            var freelecturers = await Lecturer.getAll();
            res.render('faculty/class/editLecturer', {
                Title: 'Lecturers',
                cls: cls,
                lecturers: lecturers,
                freelecturers: freelecturers,
                user: req.user
            });
        } catch (err) {
            res.status(401).json(err);
        }
    },
    editLecturer: async (req, res, next) => {
        try {
            var cls = {
                SubjectCode: req.body.subjectcode,
                Name: req.body.subjectname,
                ClassName: req.body.classname,
                SemesterCode: req.body.semestercode
            };
            console.log(req.body);
            await Cls.removeMainLecturerOfClass(cls);
            await Teach.removeLecturersOfClass(cls);
            if (req.body.lecturersid) {
                if (Array.isArray(req.body.lecturersid)) {
                    req.body.lecturersid.forEach(
                        lecturerid => Teach.addLecturerToClass(lecturerid, cls));
                } else {
                    await Teach.addLecturerToClass(req.body.lecturersid, cls);
                }
            }
            if (req.body.mainlecturerid) {
                await Teach.addLecturerToClass(req.body.mainlecturerid, cls);
                await Cls.updateMainLecturerOfClass(req.body.mainlecturerid, cls);
            }
            res.redirect('/faculty/class');
        } catch (err) {
            res.status(401).json(err);
        }
    },
    viewLecturer: async (req, res, next) => {
        try {
            var lecturers;
            if (req.query.semestercode) {
                lecturers = await Lecturer.getLecturerInSemester(req.query.semestercode);
            } else {
                lecturers = await Lecturer.getAll();
            }
            res.render('faculty/lecturer/viewLecturers', {
                Title: 'Lecturers',
                Lecturers: lecturers,
                user: req.user
            });
        } catch (err) {
            res.status(401).json(err);
        }
    },
    viewLecturerClass: async (req, res, next) => {
        try {
            var classes;
            if (req.query.semestercode) {
                classes = await Teach.getClassOfLecturerInSemester(req.query.lecturerid, req.query.semestercode);
            } else {
                classes = await Teach.getClassByLecturerID(req.query.lecturerid);
            }
            var lecturer = await Lecturer.getAll();
            console.log(lecturer);
            lecturer = lecturer.filter(x => {
                return x.ID === req.query.lecturerid
            });
            res.render('faculty/lecturer/viewLecturerClass', {
                Title: "Lecturer's Class",
                Classes: classes,
                Lecturer: lecturer[0],
                user: req.user,
                Semester: req.query.semestercode
            });
        } catch (err) {
            res.status(401).json(err);
        }
    }
}