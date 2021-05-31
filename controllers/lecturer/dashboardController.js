const con = require('../../models/connect');
const Faculty = require('../../models/faculty');
const Cls = require('../../models/class');
const Teach = require('../../models/teach');
module.exports = {
    viewDashboard: async (req, res, next) => {
        try {
            var facultyname = await Faculty.getAll();
            facultyname = facultyname.filter(x => x.Code === req.user.facultyCode);
            facultyname = facultyname[0].Name;
            var orderedclasses = await Cls.getClassOrderedByNStudentsByLecturerID(req.user.ID);
            var orderedsemesters = await Teach.getOrderedSemestersOfLecturer(req.user.ID);
            var nclasses1 = await Teach.getNClassesInNYear(1, req.user.ID);
            nclasses1 = nclasses1.length ? nclasses1[0].nclasses : 0;
            var nclasses2 = await Teach.getNClassesInNYear(2, req.user.ID);
            nclasses2 = nclasses2.length ? nclasses2[0].nclasses : 0;
            var nclasses3 = await Teach.getNClassesInNYear(3, req.user.ID);
            nclasses3 = nclasses3.length ? nclasses3[0].nclasses : 0;
            res.render('lecturer/dashboard/viewDashboard', {
                Title: 'Dashboard',
                User: req.user,
                FacultyName: facultyname,
                OrderedClasses: orderedclasses,
                OrderedSemesters: orderedsemesters,
                NClasses: [nclasses1, nclasses2 - nclasses1, nclasses3 - nclasses2 - nclasses1]
            });
        } catch (error) {
            res.status(401).json(error);
        }
    }
}