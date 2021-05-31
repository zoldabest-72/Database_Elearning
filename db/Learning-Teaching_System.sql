DROP SCHEMA IF EXISTS Learning_Teaching;
CREATE SCHEMA Learning_Teaching;
USE Learning_Teaching;
CREATE TABLE User (
    ID VARCHAR(10) PRIMARY KEY,
    Fname VARCHAR(15),
    Mname VARCHAR(15),
    Lname VARCHAR(15),
    Email VARCHAR(30),
    Address VARCHAR(40),
    Bdate DATE,
    Username VARCHAR(40),
    Password VARCHAR(40)
);
CREATE TABLE Student (
    ID VARCHAR(10) PRIMARY KEY,
    Grade VARCHAR(5),
    Status VARCHAR(20) CHECK (Status IN ('Normal', 'Halting', 'Forced out')),
    FOREIGN KEY (ID) REFERENCES User (ID)
);
CREATE TABLE Staff (
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES User (ID)
);
CREATE TABLE Lecturer (
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Staff (ID)
);
CREATE TABLE AAOStaff (
    ID VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Staff (ID)
);
CREATE TABLE Faculty (
    Code VARCHAR(3) PRIMARY KEY,
    Name VARCHAR(50)
);
CREATE TABLE Semester (
    Code VARCHAR(10) PRIMARY KEY,
    StartDate DATE,
    FinishDate DATE,
    CHECK (FinishDate > StartDate)
);
CREATE TABLE Subject (
    Code VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(40),
    NoOfCredits INT CHECK (1 <= NoOfCredits <= 3)
);
CREATE TABLE Textbook (
    Code VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(40),
    Summary VARCHAR(100)
);
CREATE TABLE Publisher (
    Name VARCHAR(50) PRIMARY KEY,
    Phone VARCHAR(15),
    Address VARCHAR(40)
);
CREATE TABLE Class (
    SubjectCode VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName VARCHAR(10),
    StartTime TIME,
    FinishTime TIME,
    Room VARCHAR(10),
    PRIMARY KEY (SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code),
    CHECK (FinishTime > StartTime)
);
CREATE TABLE ContactAddress (
    FacultyCode VARCHAR(3),
    Phone VARCHAR(15),
    Location VARCHAR(40),
    Email VARCHAR(30),
    PRIMARY KEY (FacultyCode, Phone),
    FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code)
);
CREATE TABLE Author (
    TexbookCode VARCHAR(10),
    Name VARCHAR(45),
    FOREIGN KEY (TexbookCode) REFERENCES Textbook (Code)
);
ALTER TABLE Textbook
ADD (
        PublisherName VARCHAR(50),
        Edition INT CHECK (Edition > 0),
        Year YEAR,
        FOREIGN KEY (PublisherName) REFERENCES Publisher (Name)
    );
ALTER TABLE Lecturer
ADD (
        FacultyCode VARCHAR(3),
        FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code)
    );
ALTER TABLE Student
ADD (
        FacultyCode VARCHAR(3),
        FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code)
    );
ALTER TABLE Subject
ADD (
        FacultyCode VARCHAR(3),
        FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code)
    );
ALTER TABLE Class
ADD (
        MainLecturerID VARCHAR(10),
        FOREIGN KEY (MainLecturerID) REFERENCES Lecturer (ID)
    );
CREATE TABLE Teach (
    LectureID VARCHAR(10),
    SubjectCode VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName VARCHAR(10),
    Week INT CHECK (Week > 0),
    PRIMARY KEY (LectureID, SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (LectureID) REFERENCES Lecturer (ID),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName)
);
CREATE TABLE Learn (
    StudentID VARCHAR(10),
    SubjectCode VARCHAR(10),
    SemesterCode VARCHAR(10),
    ClassName VARCHAR(10),
    Attendance FLOAT CHECK (Attendance >= 0),
    Quiz FLOAT CHECK (Quiz >= 0),
    Assignment FLOAT CHECK (Assignment >= 0),
    Midterm FLOAT CHECK (Midterm >= 0),
    Final FLOAT CHECK (Final >= 0),
    PRIMARY KEY (StudentID, SubjectCode, SemesterCode, ClassName),
    FOREIGN KEY (StudentID) REFERENCES Student (ID),
    FOREIGN KEY (SubjectCode, SemesterCode, ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName)
);
CREATE TABLE UseFor (
    TexbookCode VARCHAR(10),
    SubjectCode VARCHAR(10),
    RecommendLecturerID VARCHAR(10) NOT NULL,
    PRIMARY KEY (TexbookCode, SubjectCode),
    UNIQUE (TexbookCode, RecommendLecturerID),
    FOREIGN KEY (TexbookCode) REFERENCES Textbook (Code),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (RecommendLecturerID) REFERENCES Lecturer (ID)
);
CREATE TABLE Register (
    StudentID VARCHAR(10),
    SubjectCode VARCHAR(10),
    SemesterCode VARCHAR(10),
    PRIMARY KEY (StudentID, SubjectCode),
    FOREIGN KEY (StudentID) REFERENCES Student (ID),
    FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
    FOREIGN KEY (SemesterCode) REFERENCES Semester (Code)
);
CREATE TABLE UserPhone (
    UserID VARCHAR(10),
    Phone VARCHAR(15),
    PRIMARY KEY (UserID, Phone),
    FOREIGN KEY (UserID) REFERENCES User (ID)
);
CREATE TABLE TextbookCategory (
    TextbookCode VARCHAR(10),
    Category VARCHAR(20)
);
CREATE TRIGGER CheckYearTextbook BEFORE
INSERT ON Textbook FOR EACH ROW BEGIN IF (NEW.Year + 10 <= YEAR(CURDATE())) THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'This textbook is obsolete.';
END IF;
END;
CREATE VIEW NoOfTextbooks AS
SELECT SubjectCode,
    COUNT(*) NoOfBooks
FROM UseFor
GROUP BY SubjectCode;
CREATE TRIGGER CheckNoOfTextbooks BEFORE
INSERT ON UseFor FOR EACH ROW BEGIN IF 1 + (
        SELECT NoOfBooks
        FROM NoOfTextbooks
        WHERE NEW.SubjectCode = SubjectCode
    ) > 3 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Too many textbooks for this subject.';
END IF;
END;
CREATE TRIGGER CheckStudent BEFORE
INSERT ON Register FOR EACH ROW BEGIN IF 'Normal' = (
        SELECT Status
        FROM Student
        WHERE NEW.StudentID = ID
    ) THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'This student can not register any subjects';
END IF;
END;
delimiter $$ DROP PROCEDURE IF EXISTS getRole $$ CREATE PROCEDURE getRole(IN ID VARCHAR(10), OUT role VARCHAR(10)) BEGIN
DECLARE numRow int(1) DEFAULT 0;
IF (
    SELECT count(*)
    FROM Student
    WHERE Student.ID = ID
) = 1 THEN
SET role = 'Student';
END IF;
IF (
    SELECT count(*)
    FROM Lecturer
    WHERE Lecturer.ID = ID
) = 1 THEN
SET role = 'Lecturer';
END IF;
IF (
    SELECT count(*)
    FROM AAOStaff
    WHERE AAOStaff.ID = ID
) = 1 THEN
SET role = 'AAOStaff';
END IF;
end $$ DELIMITER;