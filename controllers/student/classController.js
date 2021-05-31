const con = require('../../models/connect');
const Class = require('../../models/class');
const Semester = require('../../models/semester');
const Usefor = require('../../models/usefor');
const { resolveInclude } = require('ejs');
const { getClassTime } = require('../../models/class');

exports.getStudentFeaturte = (req, res) => {
    res.render('student/index', { user: req.user })
}

exports.classRegister = async(req, res) => {
    var semester = (await Semester.getSemesterSign())[0].Code;
    var classes = await Class.getLearning(req.user.ID, semester);
    for (var i = 0; i < classes.length; i++) {
        classes[i].numStd = (await Class.getNoOfStudents(classes[i].SubjectCode, semester, classes[i].ClassName))[0].NoOfStudents;
        classes[i].Teachers = await Class.getTeacher(classes[i].SubjectCode, semester, classes[i].ClassName);
    }
    var SubClass = [];
    res.render('student/viewclass', {
        user: req.user,
        classes,
        semester,
        SubClass
    });
}

exports.viewClass = async(req, res) => { // chỗ này đúng mà ta
    var semester = (await Semester.getSemesterSign())[0].Code;
    var classes = await Class.getLearning(req.user.ID, semester);
    for (var i = 0; i < classes.length; i++) {
        classes[i].numStd = (await Class.getNoOfStudents(classes[i].SubjectCode, semester, classes[i].ClassName))[0].NoOfStudents;
        classes[i].Teachers = await Class.getTeacher(classes[i].SubjectCode, semester, classes[i].ClassName);
    }

    var SubClass = await Class.getListClass(req.body.SubjectCode, semester);
    if (SubClass.length == 0) {
        SubClass = []
    } else {
        for (i = 0; i < SubClass.length; i++) {
            SubClass[i].numStd = (await Class.getNoOfStudents(SubClass[i].SubjectCode, semester, SubClass[i].ClassName))[0].NoOfStudents;
            SubClass[i].Teachers = await Class.getTeacher(SubClass[i].SubjectCode, semester, SubClass[i].ClassName);

        }
    }
    res.render('student/viewclass', {
        user: req.user,
        classes,
        SubClass,
        semester
    });
}
exports.SignClass = async(req, res) => {
    var coincide = false;
    if (req.body.NoOfStudents < 60) {
        var classes = await Class.getLearning(req.user.ID, req.body.SemesterCode);
        var signClass = await Class.getClassTime(req.body.SemesterCode, req.body.ClassName, req.body.SubjectCode);
        for (i = 0; i < classes.length; i++) {
            if (classes[i].ClassName) {
                if (req.body.SubjectCode != classes[i].SubjectCode) {
                    for (t = 0; t < signClass.length; t++) {
                        if (signClass[t].Date == classes[i].Date) {
                            if ((signClass[t].StartTime < classes[i].StartTime && signClass[t].FinishTime <= classes[i].StartTime) || (signClass[t].StartTime >= classes[i].FinishTime && signClass[t].FinishTime > classes[i].FinishTime)) {

                            } else {
                                coincide = true;
                            }
                        }
                    }
                }
            }
            if (coincide) {
                res.redirect('/student/register');
                return;
            }
        }
        if (classes.filter((c) => c.SubjectCode == req.body.SubjectCode && c.ClassName).length > 0) {
            await Class.changeClass(req.body.ClassName, req.user.ID, req.body.SubjectCode, req.body.SemesterCode);
        } else {
            Class.insertClass(req.body.ClassName, req.user.ID, req.body.SubjectCode, req.body.SemesterCode);
        }
        res.redirect('/student/register');
    } else {
        res.redirect('/student/register');
    }
}

exports.SemesterInfo = async(req, res) => {
    res.render('student/SemesterInfo', {
        user: req.user,
        classes: [],
        Spec: false,
        TotalCredit: 0,
        TotalSubject: 0,
        SubClass: [],
        SemesterCode: []
    })
}

exports.getInfoSemester = async(req, res) => {
    var SemesterCode = await Semester.getSemester(req.body.SemesterCode);
    if (SemesterCode.length > 0) {
        SemesterCode = SemesterCode[0].Code;
        var SemesterSign = (await Semester.getSemesterSign())[0].Code;
        if (SemesterCode != SemesterSign) {
            var classes = await Class.getLearning(req.user.ID, SemesterCode);
            var TotalCredit = 0;
            var TotalSubject = 0;
            for (i = 0; i < classes.length; i++) {
                classes[i].numStd = (await Class.getNoOfStudents(classes[i].SubjectCode, SemesterCode, classes[i].ClassName))[0].NoOfStudents;
                classes[i].Teachers = await Class.getTeacher(classes[i].SubjectCode, SemesterCode, classes[i].ClassName);
                classes[i].Texts = await Usefor.getTextbook(classes[i].SubjectCode, SemesterCode);
                if (i != 0) {
                    if (classes[i - 1].SubjectCode != classes[i].SubjectCode) {
                        TotalCredit = TotalCredit + classes[i].NoOfCredits;
                        TotalSubject = TotalSubject + 1;
                    }
                } else {
                    TotalCredit = TotalCredit + classes[i].NoOfCredits;
                    TotalSubject = TotalSubject + 1;
                } // db chưa lưu quên db này còn lỗi @@ cái primary key k đủ 3 cột r á 
            }
            res.render('student/SemesterInfo', {
                classes,
                user: req.user,
                TotalCredit,
                TotalSubject,
                SubClass: [],
                SemesterCode
            })
        } else {
            res.render('student/SemesterInfo', {
                errorSemester: "Mã học kỳ sai hoặc chưa có thông tin về học kỳ",
                classes: [],
                user: req.user,
                TotalCredit,
                TotalSubject,
                SubClass: [],
                SemesterCode
            })
        }
    } else {
        res.render('student/SemesterInfo', {
            errorSemester: "Mã học kỳ sai hoặc chưa có thông tin về học kỳ",
            classes: [],
            user: req.user,
            TotalCredit,
            TotalSubject,
            SubClass: [],
            SemesterCode
        })
    }

}

exports.allclass = async(req, res) => {
    var SemesterCode = req.body.SemesterCode;
    var classes = await Class.getLearning(req.user.ID, SemesterCode);
    var TotalCredit = 0;
    var TotalSubject = 0;
    for (i = 0; i < classes.length; i++) {
        classes[i].numStd = (await Class.getNoOfStudents(classes[i].SubjectCode, SemesterCode, classes[i].ClassName))[0].NoOfStudents;
        classes[i].Teachers = await Class.getTeacher(classes[i].SubjectCode, SemesterCode, classes[i].ClassName);
        classes[i].Texts = await Usefor.getTextbook(classes[i].SubjectCode, SemesterCode);
        if (i != 0) {
            if (classes[i - 1].SubjectCode != classes[i].SubjectCode) {
                TotalCredit = TotalCredit + classes[i].NoOfCredits;
                TotalSubject = TotalSubject + 1;
            }
        } else {
            TotalCredit = TotalCredit + classes[i].NoOfCredits;
            TotalSubject = TotalSubject + 1;
        }
    }
    var SubClass = await Class.getListClass(req.body.SubjectCode, SemesterCode);
    for (i = 0; i < SubClass.length; i++) {
        SubClass[i].numStd = (await Class.getNoOfStudents(SubClass[i].SubjectCode, SemesterCode, SubClass[i].ClassName))[0].NoOfStudents;
        SubClass[i].Teachers = await Class.getTeacher(SubClass[i].SubjectCode, SemesterCode, SubClass[i].ClassName);
        SubClass[i].Texts = await Usefor.getTextbook(SubClass[i].SubjectCode, SemesterCode);
    }
    res.render('student/SemesterInfo', {
        user: req.user,
        classes,
        Spec: false,
        user: req.user,
        TotalCredit,
        TotalSubject,
        SubClass,
        SemesterCode
    })
}

exports.speclass = async(req, res) => {
    var SemesterCode = req.body.SemesterCode;
    var classes = await Class.getLearning(req.user.ID, SemesterCode);
    var TotalCredit = 0;
    var TotalSubject = 0;
    for (i = 0; i < classes.length; i++) {
        classes[i].numStd = (await Class.getNoOfStudents(classes[i].SubjectCode, SemesterCode, classes[i].ClassName))[0].NoOfStudents;
        classes[i].Teachers = await Class.getTeacher(classes[i].SubjectCode, SemesterCode, classes[i].ClassName);
        classes[i].Texts = await Usefor.getTextbook(classes[i].SubjectCode, SemesterCode);
        if (i != 0) {
            if (classes[i - 1].SubjectCode != classes[i].SubjectCode) {
                TotalCredit = TotalCredit + classes[i].NoOfCredits;
                TotalSubject = TotalSubject + 1;
            }
        } else {
            TotalCredit = TotalCredit + classes[i].NoOfCredits;
            TotalSubject = TotalSubject + 1;
        }
    }
    var SubClass = await Class.getListClass(req.body.SubjectCode, SemesterCode);
    for (i = 0; i < SubClass.length; i++) {
        SubClass[i].numStd = (await Class.getNoOfStudents(SubClass[i].SubjectCode, SemesterCode, SubClass[i].ClassName))[0].NoOfStudents;
        SubClass[i].Teachers = await Class.getTeacher(SubClass[i].SubjectCode, SemesterCode, SubClass[i].ClassName);
        SubClass[i].Texts = await Usefor.getTextbook(SubClass[i].SubjectCode, SemesterCode);
    }
    res.render('student/SemesterInfo', {
        user: req.user,
        classes,
        Spec: true,
        user: req.user,
        TotalCredit,
        TotalSubject,
        SubClass,
        SemesterCode
    })
}

exports.getTop3Info = async(req, res) => {
    var count = 0;
    var Top3 = await Semester.getTop3Semester(req.user.ID);
    var SemesterSign = await Semester.getSemesterSign();
    var classes = [];
    var TotalCredit = [];
    var TotalSubject = [];
    var top3semes = [];
    for (x = 0; x < Top3.length; x++) {
        if (Top3[x].SemesterCode == SemesterSign[0].Code) {
            continue;
        }

        if (count == 3) {
            break;
        }
        var SubClass = await Class.getLearning(req.user.ID, Top3[x].SemesterCode);
        var SubCredits = 0;
        var SubSubject = 0
        for (i = 0; i < SubClass.length; i++) {
            SubClass[i].numStd = (await Class.getNoOfStudents(SubClass[i].SubjectCode, Top3[x].SemesterCode, SubClass[i].ClassName))[0].NoOfStudents;
            SubClass[i].Teachers = await Class.getTeacher(SubClass[i].SubjectCode, Top3[x].SemesterCode, SubClass[i].ClassName);
            SubClass[i].Texts = await Usefor.getTextbook(SubClass[i].SubjectCode, Top3[x].SemesterCode);
            if (i != 0) {
                if (SubClass[i - 1].SubjectCode != SubClass[i].SubjectCode) {
                    SubCredits = SubCredits + SubClass[i].NoOfCredits;
                    SubSubject = SubSubject + 1;
                }
            } else {
                SubCredits = SubCredits + SubClass[i].NoOfCredits;
                SubSubject = SubSubject + 1;
            }
        }
        classes.push(SubClass);
        TotalCredit.push(SubCredits);
        TotalSubject.push(SubSubject);
        top3semes.push(Top3[x].SemesterCode);
        count = count + 1;
    }
    res.render('student/top3Semester', {
        user: req.user,
        Top3: top3semes,
        classes,
        TotalCredit,
        TotalSubject
    })
}