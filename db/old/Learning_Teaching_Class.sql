INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1001', '191', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1001', '191', 'L02', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1001', '201', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1001', '202', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1001', '202', 'L02', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1002', '191', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('1003', '191', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('2002', '191', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('2002', '191', 'L02', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('2002', '201', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('2008', '202', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('2008', '202', 'L02', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('3005', '191', 'L01', null);
INSERT INTO Learning_Teaching.Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES ('3006', '191', 'L01', null);

INSERT INTO Learning_Teaching.Faculty (Code, Name) VALUES ('CE', 'Kỹ thuật');
INSERT INTO Learning_Teaching.Faculty (Code, Name) VALUES ('CO', 'Máy tính');
INSERT INTO Learning_Teaching.Faculty (Code, Name) VALUES ('CS', 'Khoa học');

INSERT INTO Learning_Teaching.FacultyStaff (ID, FacultyCode) VALUES ('GV12345', 'CO');

INSERT INTO Learning_Teaching.Learn (StudentID, SubjectCode, SemesterCode, ClassName, Attendance, Quiz, Assignment, Midterm, Final) VALUES ('1814491', '1001', '191', 'L01', null, null, null, null, null);
INSERT INTO Learning_Teaching.Learn (StudentID, SubjectCode, SemesterCode, ClassName, Attendance, Quiz, Assignment, Midterm, Final) VALUES ('1814491', '1002', '191', 'L01', null, null, null, null, null);
INSERT INTO Learning_Teaching.Learn (StudentID, SubjectCode, SemesterCode, ClassName, Attendance, Quiz, Assignment, Midterm, Final) VALUES ('1814492', '1001', '191', 'L02', null, null, null, null, null);

INSERT INTO Learning_Teaching.Lecturer (ID) VALUES ('GV12345');


INSERT INTO Learning_Teaching.OpenedIn (SubjectCode, SemesterCode) VALUES ('1001', '191');
INSERT INTO Learning_Teaching.OpenedIn (SubjectCode, SemesterCode) VALUES ('1002', '191');
INSERT INTO Learning_Teaching.OpenedIn (SubjectCode, SemesterCode) VALUES ('1003', '191');
INSERT INTO Learning_Teaching.OpenedIn (SubjectCode, SemesterCode) VALUES ('2002', '191');
INSERT INTO Learning_Teaching.OpenedIn (SubjectCode, SemesterCode) VALUES ('2002', '202');

INSERT INTO Learning_Teaching.Semester (Code, StartDate, FinishDate) VALUES ('191', '2016-12-06', '2017-12-06');
INSERT INTO Learning_Teaching.Semester (Code, StartDate, FinishDate) VALUES ('201', '2017-12-06', '2018-12-06');
INSERT INTO Learning_Teaching.Semester (Code, StartDate, FinishDate) VALUES ('202', '2019-12-06', '2020-12-06');
INSERT INTO Learning_Teaching.Staff (ID) VALUES ('GV12345');

INSERT INTO Learning_Teaching.Student (ID, Grade, Status, FacultyCode) VALUES ('1814491', null, null, 'CO');
INSERT INTO Learning_Teaching.Student (ID, Grade, Status, FacultyCode) VALUES ('1814492', null, null, 'CE');

INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('1001', 'Giải tích', 3, 'CO');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('1002', 'Hóa', 3, 'CO');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('1003', 'Nhập môn lập trình', 4, 'CO');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('2002', 'Hệ thống số ', 2, 'CE');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('2008', 'Điện tử', 4, 'CE');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('3005', 'Giải thuật', 3, 'CS');
INSERT INTO Learning_Teaching.Subject (Code, Name, NoOfCredits, FacultyCode) VALUES ('3006', 'Cấu trúc dữ liệu', 9, 'CS');

INSERT INTO Learning_Teaching.Teach (LectureID, SubjectCode, SemesterCode, ClassName, Week) VALUES ('GV12345', '1001', '191', 'L01', null);

INSERT INTO Learning_Teaching.User (ID, Fname, Mname, Lname, Email, Address, Bdate, Username, Password) VALUES ('1814491', 'vo', 'ngoc', 'trong', 'trong.vo102@hcmut.edu.vn', null, null, 'vnt', 'vnt');
INSERT INTO Learning_Teaching.User (ID, Fname, Mname, Lname, Email, Address, Bdate, Username, Password) VALUES ('1814492', 'abc', 'abc', 'abc', 'abc.abc123@hcmut.edu.vn', null, null, 'abc', 'abc');
INSERT INTO Learning_Teaching.User (ID, Fname, Mname, Lname, Email, Address, Bdate, Username, Password) VALUES ('GV12345', 'xyz', 'xyz', 'xyz', 'xyz.xyz102@hcmut.edu.vn', null, null, 'xyz', 'xyz');