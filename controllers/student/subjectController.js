var Subject = require('../../models/subject');
var Enroll = require('../../models/enroll');
const Semester = require('../../models/semester');


module.exports = {
    enroll: async(req, res) => {
        var recommends = await Subject.getSubjectRecommend(req.user.ID);
        var searchs = null;

        var semesterCode = (await Semester.getSemesterSign())[0].Code;
        if (req.body.enroll) {
            await Enroll.enrollSubjectByCode(req.user.ID, req.body.enroll);
        };
        if (req.body.remove) {
            await Enroll.removeSubjectByCode(req.user.ID, req.body.remove);
        };
        if (req.query.keyword) {
            searchs = await Subject.getSubjectByKeyword(req.query.keyword, semesterCode);
        };
        var enrolledCodes = await Enroll.getEnrolledSubjectsByStudentId(req.user.ID, semesterCode);
        enrolledCodes = enrolledCodes.map(x => x.SubjectCode);
        res.render('student/subject/enroll', {
            Title: "Course",
            recommends: recommends,
            searchs: searchs,
            enrolledCodes: enrolledCodes
        });
    }
};