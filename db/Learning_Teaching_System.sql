DROP SCHEMA IF EXISTS Learning_Teaching;

CREATE SCHEMA Learning_Teaching;

USE Learning_Teaching;

CREATE TABLE User
(
    ID       VARCHAR(10) PRIMARY KEY,
    role     VARCHAR(14) CHECK (role IN ('Student','AAOStaff','FacultyOfficer','Lecturer')),
    Fname    VARCHAR(15),
    Mname    VARCHAR(15),
    Lname    VARCHAR(15),
    Email    VARCHAR(30),
    Address  VARCHAR(40),
    Bdate    DATE,
    Username VARCHAR(40),
    Password VARCHAR(40)
);

CREATE TABLE Student
(
    ID     VARCHAR(10) PRIMARY KEY,
    Grade  VARCHAR(5),
    Status VARCHAR(20) CHECK (Status IN ('Normal', 'Halting', 'Forced out')),
    FOREIGN KEY (ID) REFERENCES User (ID)
);

CREATE TABLE Staff
(
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES User (ID)
);

CREATE TABLE FacultyStaff
(
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Staff (ID)
);

CREATE TABLE AAOStaff
(
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Staff (ID)
);

CREATE TABLE FacultyOfficer
(
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES FacultyStaff (ID)
);

CREATE TABLE Lecturer
(
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES FacultyStaff (ID)
);
CREATE TABLE Faculty
(
    Code VARCHAR(3) PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Semester
(
    Code       VARCHAR(10) PRIMARY KEY,
    StartDate  DATE,
    FinishDate DATE,
    CHECK (FinishDate > StartDate)
);

CREATE TABLE Subject
(
    Code        VARCHAR(10) PRIMARY KEY,
    Name        VARCHAR(40),
    NoOfCredits INT CHECK (1 <= NoOfCredits <= 3)
);

CREATE TABLE OpenedIn
(
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    PRIMARY KEY (SubjectCode, SemesterCode),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code)
);
CREATE TABLE Textbook
(
    Code    VARCHAR(10) PRIMARY KEY,
    Name    VARCHAR(40),
    Summary VARCHAR(100)
);

CREATE TABLE Publisher
(
    Name    VARCHAR(50) PRIMARY KEY,
    Phone   VARCHAR(15),
    Address VARCHAR(40)
);

CREATE TABLE Class
(
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName    VARCHAR(10),
    PRIMARY KEY (SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code)
);

CREATE TABLE ClassTime
(
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName    VARCHAR(10),
    Date         ENUM ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    StartTime    TIME,
    FinishTime   TIME,
    Room         VARCHAR(10),
    Week         VARCHAR(5),
    PRIMARY KEY (SubjectCode, SemesterCode, ClassName, Date, StartTime, FinishTime, Room),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName),
    Check (FinishTime > StartTime)
);

CREATE TABLE ContactAddress
(
    FacultyCode VARCHAR(3),
    Phone       VARCHAR(15),
    Location    VARCHAR(40),
    Email       VARCHAR(30),
    PRIMARY KEY (FacultyCode, Phone),
    FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code)
);

CREATE TABLE Author
(
    TexbookCode VARCHAR(10),
    Name        VARCHAR(45),
    FOREIGN KEY (TexbookCode) REFERENCES Textbook (Code)
);

ALTER TABLE Textbook
    ADD (PublisherName VARCHAR(50),
         Edition INT CHECK (Edition > 0),
         Year YEAR, FOREIGN KEY (PublisherName) REFERENCES Publisher (Name));

ALTER TABLE FacultyStaff
    ADD (FacultyCode VARCHAR(3), FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code));

ALTER TABLE Student
    ADD (FacultyCode VARCHAR(3), FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code));

ALTER TABLE Subject
    ADD (FacultyCode VARCHAR(3), FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code));

ALTER TABLE Class
    ADD (MainLecturerID VARCHAR(10), FOREIGN KEY (MainLecturerID) REFERENCES Lecturer (ID));

CREATE TABLE Teach
(
    LecturerID   VARCHAR(10),
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName    VARCHAR(10),
    Week         VARCHAR(5),
    PRIMARY KEY (LecturerID, SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (LecturerID) REFERENCES Lecturer (ID),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName)
);

CREATE TABLE Manage
(
    LecturerID   VARCHAR(10),
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName    VARCHAR(10),
    PRIMARY KEY (LecturerID, SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (LecturerID) REFERENCES Lecturer (ID),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName)
);

CREATE TABLE Learn
(
    StudentID    VARCHAR(10),
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName    VARCHAR(10),
    Attendance   FLOAT CHECK (Attendance >= 0),
    Quiz         FLOAT CHECK (Quiz >= 0),
    Assignment   FLOAT CHECK (Assignment >= 0),
    Midterm      FLOAT CHECK (Midterm >= 0),
    Final        FLOAT CHECK (Final >= 0),
    PRIMARY KEY (StudentID, SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (StudentID) REFERENCES Student (ID),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName)
);

CREATE TABLE UseFor
(
    TextbookCode        VARCHAR(10),
    SubjectCode         VARCHAR(10),
    RecommendLecturerID VARCHAR(10) NOT NULL,
    SemesterCode        VARCHAR(10),
    PRIMARY KEY (TextbookCode, SubjectCode),
    UNIQUE (TextbookCode, RecommendLecturerID, SemesterCode),
    FOREIGN KEY (TextbookCode) REFERENCES Textbook (Code),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (RecommendLecturerID) REFERENCES Lecturer (ID),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code)
);

CREATE TABLE Enroll
(
    StudentID    VARCHAR(10),
    SubjectCode  VARCHAR(10),
    SemesterCode VARCHAR(10),
    PRIMARY KEY (StudentID, SubjectCode),
    FOREIGN KEY (StudentID) REFERENCES Student (ID),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code)
);



CREATE TABLE UserPhone
(
    UserID VARCHAR(10),
    Phone  VARCHAR(15),
    PRIMARY KEY (UserID, Phone),
    FOREIGN KEY (UserID) REFERENCES User (ID)
);

CREATE TABLE TextbookCategory
(
    TextbookCode VARCHAR(10),
    Category     VARCHAR(20)
);