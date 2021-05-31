const con = require('../../models/connect');
const Class = require('../../models/class');
const Semester = require('../../models/semester');
const Usefor = require('../../models/usefor');
const { resolveInclude } = require('ejs');
const { getClassTime } = require('../../models/class');

exports.getStudentFeaturte = (req, res) => {
    res.render('student/index', {})
}

exports.classRegister = async(req, res) => {
    var SemesterCode = await Semester.getSemesterSign();
    var TotalCredit = 0;
    var TotalSubject = 0;
    if (!SemesterCode) {
        res.render('', {});
    } else {
        var ClassTime = await Class.getClassTime(req.user.ID, SemesterCode[0].Code);
        var lst = [];
        var lstTeacher = [];
        for (i = 0; i < ClassTime.length; i++) {
            var getNoOfStudents = await Class.getNoOfStudents(ClassTime[i].SubjectCode, SemesterCode[0].Code, ClassTime[i].ClassName);
            var Teacher = await Class.getTeacher(ClassTime[i].SubjectCode, ClassTime[i].SemesterCode, ClassTime[i].ClassName);
            TotalCredit = TotalCredit + ClassTime[i].NoOfCredits;
            lst.push(getNoOfStudents[0].NoOfStudents);
            lstTeacher.push(Teacher);
        }
        TotalSubject = ClassTime.length;
        res.render('student/viewclass', {
            ClassTime,
            lstTeacher,
            lst,
            TotalCredit,
            TotalSubject,
            SubClass: [],
            SubTeacher: [],
            SubLst: []
        });
    }
}

exports.viewClass = async(req, res) => {
    var ClassTime = await Class.getClassTime(req.user.ID, req.body.SemesterCode);
    var lst = [];
    var lstTeacher = [];
    var TotalCredit = 0;
    var TotalSubject = 0;
    for (i = 0; i < ClassTime.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(ClassTime[i].SubjectCode, req.body.SemesterCode, ClassTime[i].ClassName);
        var Teacher = await Class.getTeacher(ClassTime[i].SubjectCode, ClassTime[i].SemesterCode, ClassTime[i].ClassName);
        lst.push(getNoOfStudents[0].NoOfStudents);
        TotalCredit = TotalCredit + ClassTime[i].NoOfCredits;
        lstTeacher.push(Teacher);
    } // quẻy kiểu này chết con db quá ông, lỡ vài nghìn vài triệu dòng s, hic tui chưa nghĩ tới :<, mình dùng join ấy, hôm trước có học r á , join trong mysql á hả ukm , tại tui quen 
    TotalSubject = ClassTime.length;
    var SubClass = await Class.getListClass(req.body.SubjectCode, req.body.SemesterCode);
    var SubLst = [];
    var SubTeacher = [];
    for (i = 0; i < SubClass.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);
        var Teacher = await Class.getTeacher(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);

        SubLst.push(getNoOfStudents[0].NoOfStudents);
        SubTeacher.push(Teacher);
    }
    res.render('student/viewclass', {
        ClassTime,
        lstTeacher,
        lst,
        TotalCredit,
        TotalSubject,
        SubClass,
        SubTeacher,
        SubLst
    });
}
exports.SignClass = async(req, res) => {
    var coincide = false;
    if (req.body.NoOfStudents < 60) {
        var ClassTime = await Class.getClassTime(req.user.ID, req.body.SemesterCode);
        for (i = 0; i < ClassTime.length; i++) {
            if (req.body.SubjectCode != ClassTime[i].SubjectCode) {

                if (req.body.Date == ClassTime[i].Date) {
                    if ((req.body.StartTime < ClassTime[i].StartTime && req.body.FinishTime <= ClassTime[i].StartTime) || (req.body.StartTime >= ClassTime[i].FinishTime && req.body.FinishTime > ClassTime[i].FinishTime)) {

                    } else {
                        coincide = true;
                        console.log(true);
                    }
                }
            }
            if (coincide) {
                res.redirect('/student/register');
                return;
            }
        }

        await Class.changeClass(req.body.ClassName, req.user.ID, req.body.SubjectCode, req.body.SemesterCode);
        res.redirect('/student/register');
    } else {
        res.redirect('/student/register');
    }
}

exports.SemesterInfo = async(req, res) => {
    res.render('student/SemesterInfo', {
        ClassTime: [],
        lst: [],
        Spec: false,
        lstTeacher: [],
        lstText: [],
        TotalCredit: [],
        TotalSubject: [],
        SubClass: [],
        SubLst: [],
        SubTeacher: [],
        SubText: []
    })
}

exports.getInfoSemester = async(req, res) => {
    var SemesterCode = await Semester.getSemester(req.body.SemesterCode);
    if (SemesterCode.length > 0) {
        var SemesterSign = await Semester.getSemesterSign();
        if (SemesterCode[0].Code != SemesterSign[0].Code) {
            var ClassTime = await Class.getClassTime(req.user.ID, SemesterCode[0].Code);
            var lst = [];
            var lstTeacher = [];
            var lstText = [];
            var TotalCredit = 0;
            var TotalSubject = 0;
            for (i = 0; i < ClassTime.length; i++) {
                var getNoOfStudents = await Class.getNoOfStudents(ClassTime[i].SubjectCode, req.body.SemesterCode, ClassTime[i].ClassName);
                var Teacher = await Class.getTeacher(ClassTime[i].SubjectCode, ClassTime[i].SemesterCode, ClassTime[i].ClassName);
                var Text = await Usefor.getTextbook(ClassTime[i].SubjectCode, SemesterCode[0].Code);
                TotalCredit = TotalCredit + ClassTime[i].NoOfCredits;
                lst.push(getNoOfStudents[0].NoOfStudents);
                lstTeacher.push(Teacher);
                lstText.push(Text);
            }
            TotalSubject = ClassTime.length;
            res.render('student/SemesterInfo', {
                ClassTime,
                lst,

                lstTeacher,
                lstText,
                TotalCredit,
                TotalSubject,
                SubClass: [],
                SubLst: [],
                SubTeacher: [],
                SubText: []
            })
        } else {
            res.render('student/SemesterInfo', {
                ClassTime: [],
                errorSemester: "Mã học kỳ sai hoặc chưa có thông tin về học kỳ",
                lst: [],
                lstTeacher: [],
                lstText: [],
                TotalCredit: [],
                TotalSubject: [],
                SubClass: [],
                SubLst: [],
                SubTeacher: [],
                SubText: []
            })
        }
    } else {
        res.render('student/SemesterInfo', {
            ClassTime: [],
            errorSemester: "Mã học kỳ sai hoặc chưa có thông tin về học kỳ",
            lst: [],
            lstTeacher: [],
            lstText: [],
            TotalCredit: [],
            TotalSubject: [],
            SubClass: [],
            SubLst: [],
            SubTeacher: [],
            SubText: []
        })
    }

}

exports.allclass = async(req, res) => {
    var ClassTime = await Class.getClassTime(req.user.ID, req.body.SemesterCode);
    var lst = [];
    var lstTeacher = [];
    var lstText = [];
    var TotalCredit = 0;
    var TotalSubject = 0;
    for (i = 0; i < ClassTime.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(ClassTime[i].SubjectCode, req.body.SemesterCode, ClassTime[i].ClassName);
        var Teacher = await Class.getTeacher(ClassTime[i].SubjectCode, ClassTime[i].SemesterCode, ClassTime[i].ClassName);
        var Text = await Usefor.getTextbook(ClassTime[i].SubjectCode, req.body.SemesterCode);
        TotalCredit = TotalCredit + ClassTime[i].NoOfCredits;
        lst.push(getNoOfStudents[0].NoOfStudents);
        lstTeacher.push(Teacher);
        lstText.push(Text);
    }
    TotalSubject = ClassTime.length;
    var SubClass = await Class.getListClass(req.body.SubjectCode, req.body.SemesterCode);
    var SubLst = [];
    var SubTeacher = [];
    var SubText = [];
    for (i = 0; i < SubClass.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);

        var Teacher = await Class.getTeacher(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);
        var Text = await Usefor.getTextbook(SubClass[i].SubjectCode, req.body.SemesterCode);
        SubLst.push(getNoOfStudents[0].NoOfStudents);
        console.log(SubLst);
        SubTeacher.push(Teacher);
        SubText.push(Text);
    }
    res.render('student/SemesterInfo', {
        ClassTime,
        lst,
        Spec: false,
        lstTeacher,
        lstText,
        TotalCredit,
        TotalSubject,
        SubClass,
        SubLst,
        SubTeacher,
        SubText
    })
}

exports.speclass = async(req, res) => {
    var ClassTime = await Class.getClassTime(req.user.ID, req.body.SemesterCode);
    var lst = [];
    var lstTeacher = [];
    var lstText = [];
    var TotalCredit = 0;
    var TotalSubject = 0;
    for (i = 0; i < ClassTime.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(ClassTime[i].SubjectCode, req.body.SemesterCode, ClassTime[i].ClassName);
        var Teacher = await Class.getTeacher(ClassTime[i].SubjectCode, ClassTime[i].SemesterCode, ClassTime[i].ClassName);
        var Text = await Usefor.getTextbook(ClassTime[i].SubjectCode, req.body.SemesterCode);
        TotalCredit = TotalCredit + ClassTime[i].NoOfCredits;
        lst.push(getNoOfStudents[0].NoOfStudents);
        lstTeacher.push(Teacher);
        lstText.push(Text);
    }
    TotalSubject = ClassTime.length;
    var SubClass = await Class.getListClass(req.body.SubjectCode, req.body.SemesterCode);
    var SubLst = [];
    var SubTeacher = [];
    var SubText = [];
    for (i = 0; i < SubClass.length; i++) {
        var getNoOfStudents = await Class.getNoOfStudents(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);
        var Teacher = await Class.getTeacher(SubClass[i].SubjectCode, req.body.SemesterCode, SubClass[i].ClassName);
        var Text = await Usefor.getTextbook(SubClass[i].SubjectCode, req.body.SemesterCode);
        SubLst.push(getNoOfStudents[0].NoOfStudents);
        SubTeacher.push(Teacher);
        SubText.push(Text);
    }
    res.render('student/SemesterInfo', {
        ClassTime,
        lst,
        Spec: true,
        lstTeacher,
        lstText,
        TotalCredit,
        TotalSubject,
        SubClass,
        SubLst,
        SubTeacher,
        SubText
    })
}

exports.getTop3Info = async(req, res) => {
    var count = 0;
    var Top3 = await Semester.getTop3Semester(req.user.ID);
    console.log(Top3);
    var SemesterSign = await Semester.getSemesterSign();
    var ClassTime = [];
    var lst = [];
    var lstTeacher = [];
    var lstText = [];
    var TotalCredit = [];
    var TotalSubject = [];
    for (x = 0; x < Top3.length; x++) {
        if (Top3[x].SemesterCode == SemesterSign[0].Code) {
            continue;
        }
        if (count == 3) {
            break;
        }
        var SubClass = await Class.getClassTime(req.user.ID, Top3[x].SemesterCode);

        var SubLst = [];
        var SubText = [];
        var SubTeacher = [];
        var SubCredits = 0;
        var SubSubject = SubClass.length;
        for (i = 0; i < SubClass.length; i++) {
            var getNoOfStudents = await Class.getNoOfStudents(SubClass[i].SubjectCode, Top3[x].SemesterCode, SubClass[i].ClassName);

            var Teacher = await Class.getTeacher(SubClass[i].SubjectCode, SubClass[i].SemesterCode, SubClass[i].ClassName);

            var Text = await Usefor.getTextbook(SubClass[i].SubjectCode, Top3[x].SemesterCode);

            SubCredits = SubCredits + SubClass[i].NoOfCredits;

            SubLst.push(getNoOfStudents[0].NoOfStudents);
            SubTeacher.push(Teacher);
            SubText.push(Text);
        }
        ClassTime.push(SubClass);
        lst.push(SubLst);
        lstTeacher.push(SubTeacher);
        lstText.push(SubText);
        TotalCredit.push(SubCredits);
        TotalSubject.push(SubSubject);
        count = count + 1;
    }
    res.render('student/top3Semester', {
        ClassTime,
        lst,
        lstTeacher,
        lstText,
        TotalCredit,
        TotalSubject
    })
}