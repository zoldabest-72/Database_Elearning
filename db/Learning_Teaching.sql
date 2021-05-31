-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th12 21, 2020 lúc 04:21 PM
-- Phiên bản máy phục vụ: 8.0.22-0ubuntu0.20.04.3
-- Phiên bản PHP: 7.4.3
DROP SCHEMA IF EXISTS Learning_Teaching;
CREATE SCHEMA Learning_Teaching;
USE Learning_Teaching;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: Learning_Teaching
--
--
-- Thủ tục
--
DROP PROCEDURE IF EXISTS getRole;
DELIMITER |
CREATE PROCEDURE getRole (IN ID VARCHAR(10), OUT role VARCHAR(30))  
BEGIN
    DECLARE numRow int(1) DEFAULT 0;
    IF (
        SELECT COUNT(*)
        FROM Student
        WHERE Student.ID = ID
    ) = 1 THEN
    SET role = 'Student';
    END IF;
    IF (
        SELECT COUNT(*)
        FROM Lecturer
        WHERE Lecturer.ID = ID
    ) = 1 THEN
    SET role = 'Lecturer';
    END IF;
    IF (
        SELECT COUNT(*)
        FROM AAOStaff
        WHERE AAOStaff.ID = ID
    ) = 1 THEN
    SET role = 'AAOStaff';
    end if;
    IF (
        SELECT count(*)
        FROM FacultyOfficer
        WHERE FacultyOfficer.ID = ID
    ) = 1 THEN
    SET role = 'FacultyOfficer';
    END IF;
END |
DELIMITER ;
--
-- Các hàm
--
DROP FUNCTION IF EXISTS getUserFullName;
DELIMITER |
CREATE FUNCTION getUserFullname (userid VARCHAR(10))
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
    RETURN (SELECT CONCAT(Fname, " ", Mname, " ", Lname) FROM User WHERE ID = userid);
END |
DELIMITER ;

DROP FUNCTION IF EXISTS getPeriod;
DELIMITER |
CREATE FUNCTION getPeriod (starttime TIME, finishtime TIME)
RETURNS VARCHAR(13)
DETERMINISTIC
BEGIN
    RETURN (SELECT CONCAT(DATE_FORMAT(starttime, "%H:%i"), " - ", DATE_FORMAT(finishtime, "%H:%i")));
END |
DELIMITER ;
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng AAOStaff
--

DROP TABLE IF EXISTS AAOStaff;
CREATE TABLE IF NOT EXISTS AAOStaff (
  ID varchar(10) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Author
--

DROP TABLE IF EXISTS Author;
CREATE TABLE IF NOT EXISTS Author (
  TexbookCode varchar(10) DEFAULT NULL,
  Name varchar(45) DEFAULT NULL,
  KEY TexbookCode (TexbookCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Class
--

DROP TABLE IF EXISTS Class;
CREATE TABLE IF NOT EXISTS Class (
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  ClassName varchar(10) NOT NULL,
  MainLecturerID varchar(10) DEFAULT NULL,
  PRIMARY KEY (SubjectCode,SemesterCode,ClassName),
  KEY SemesterCode (SemesterCode),
  KEY MainLecturerID (MainLecturerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Class
--

INSERT INTO Class (SubjectCode, SemesterCode, ClassName, MainLecturerID) VALUES
('1001', '191', 'L01', NULL),
('1001', '191', 'L02', NULL),
('1001', '201', 'L01', NULL),
('1001', '202', 'demo', NULL),
('1001', '202', 'demo1', NULL),
('1001', '202', 'L01', NULL),
('1001', '202', 'L02', NULL),
('1002', '191', 'L01', NULL),
('1002', '202', 'abcxyz', NULL),
('1002', '202', 'demo123', NULL),
('1002', '202', 'demo1234', NULL),
('1002', '202', 'demo12345', NULL),
('1002', '202', 'Lớp hóa', NULL),
('1002', '202', 'qwe', NULL),
('1002', '202', 'qwer', NULL),
('1002', '202', 'ship', NULL),
('1003', '191', 'L01', NULL),
('1003', '202', 'demo12', NULL),
('1003', '202', 'lt', NULL),
('1003', '202', 'xyz', NULL),
('2002', '191', 'L01', NULL),
('2002', '191', 'L02', NULL),
('2002', '201', 'L01', NULL),
('2002', '202', 'abc', NULL),
('2008', '202', 'L01', NULL),
('2008', '202', 'L02', NULL),
('3005', '191', 'L01', NULL),
('3006', '191', 'L01', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng ClassTime
--

DROP TABLE IF EXISTS ClassTime;
CREATE TABLE IF NOT EXISTS ClassTime (
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  ClassName varchar(10) NOT NULL,
  Date enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  StartTime time NOT NULL,
  FinishTime time NOT NULL,
  Room varchar(10) NOT NULL,
  Week varchar(5) DEFAULT NULL,
  PRIMARY KEY (SubjectCode,SemesterCode,ClassName,Date,StartTime,FinishTime,Room)
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng ContactAddress
--

DROP TABLE IF EXISTS ContactAddress;
CREATE TABLE IF NOT EXISTS ContactAddress (
  FacultyCode varchar(3) NOT NULL,
  Phone varchar(15) NOT NULL,
  Location varchar(40) DEFAULT NULL,
  Email varchar(30) DEFAULT NULL,
  PRIMARY KEY (FacultyCode,Phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Enroll
--

DROP TABLE IF EXISTS Enroll;
CREATE TABLE IF NOT EXISTS Enroll (
  StudentID varchar(10) NOT NULL,
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) DEFAULT NULL,
  PRIMARY KEY (StudentID,SubjectCode),
  KEY SubjectCode (SubjectCode),
  KEY SemesterCode (SemesterCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Đang đổ dữ liệu cho bảng Enroll
--
INSERT INTO Enroll (StudentID, SubjectCode, SemesterCode) VALUES
('1814259','1001','191'),
('1814491','1001','202'),
('1814492','1001','201');


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Faculty
--

DROP TABLE IF EXISTS Faculty;
CREATE TABLE IF NOT EXISTS Faculty (
  Code varchar(3) NOT NULL,
  Name varchar(50) DEFAULT NULL,
  PRIMARY KEY (Code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Faculty
--

INSERT INTO Faculty (Code, Name) VALUES
('CE', 'Kỹ thuật'),
('CO', 'Máy tính'),
('CS', 'Khoa học'),
('CSE', 'Khoa Khoa học và Kỹ thuật Máy tính');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng FacultyOfficer
--

DROP TABLE IF EXISTS FacultyOfficer;
CREATE TABLE IF NOT EXISTS FacultyOfficer (
  ID varchar(10) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng FacultyOfficer
--

INSERT INTO FacultyOfficer (ID) VALUES
('off123');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng FacultyStaff
--

DROP TABLE IF EXISTS FacultyStaff;
CREATE TABLE IF NOT EXISTS FacultyStaff (
  ID varchar(10) NOT NULL,
  FacultyCode varchar(3) DEFAULT NULL,
  PRIMARY KEY (ID),
  KEY FacultyCode (FacultyCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng FacultyStaff
--

INSERT INTO FacultyStaff (ID, FacultyCode) VALUES
('GV12345', 'CO'),
('off123', 'CO'),
('LEC123', 'CO');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Learn
--

DROP TABLE IF EXISTS Learn;
CREATE TABLE IF NOT EXISTS Learn (
  StudentID varchar(10) NOT NULL,
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  ClassName varchar(10) NOT NULL,
  Attendance float DEFAULT NULL,
  Quiz float DEFAULT NULL,
  Assignment float DEFAULT NULL,
  Midterm float DEFAULT NULL,
  Final float DEFAULT NULL,
  PRIMARY KEY (StudentID,SubjectCode,SemesterCode,ClassName),
  KEY SubjectCode (SubjectCode,SemesterCode,ClassName)
) ;

--
-- Đang đổ dữ liệu cho bảng Learn
--

INSERT INTO Learn (StudentID, SubjectCode, SemesterCode, ClassName, Attendance, Quiz, Assignment, Midterm, Final) VALUES
('1814491', '1001', '191', 'L01', NULL, NULL, NULL, NULL, NULL),
('1814491', '1002', '191', 'L01', NULL, NULL, NULL, NULL, NULL),
('1814492', '1001', '191', 'L02', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Lecturer
--

DROP TABLE IF EXISTS Lecturer;
CREATE TABLE IF NOT EXISTS Lecturer (
  ID varchar(10) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Lecturer
--

INSERT INTO Lecturer (ID) VALUES
('GV12345'),
('LEC123');

-- --------------------------------------------------------



-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng OpenedIn
--

DROP TABLE IF EXISTS OpenedIn;
CREATE TABLE IF NOT EXISTS OpenedIn (
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  HeadOfSubjectID varchar(10),
  PRIMARY KEY (SubjectCode,SemesterCode),
  KEY SemesterCode (SemesterCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng OpenedIn
--

INSERT INTO OpenedIn (SubjectCode, SemesterCode, HeadOfSubjectID) VALUES
('1001', '191', 'LEC123'),
('2002', '191', null),
('1002', '202', null),
('1003', '202', null),
('2002', '202', null);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Publisher
--

DROP TABLE IF EXISTS Publisher;
CREATE TABLE IF NOT EXISTS Publisher (
  Name varchar(50) NOT NULL,
  Phone varchar(15) DEFAULT NULL,
  Address varchar(40) DEFAULT NULL,
  PRIMARY KEY (Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Publisher
--
INSERT INTO Publisher (Name, Phone, Address) VALUES
('Pearson', '19008486', 'Pearson PLC, 80 Strand, London');
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Semester
--

DROP TABLE IF EXISTS Semester;
CREATE TABLE IF NOT EXISTS Semester (
  Code varchar(10) NOT NULL,
  StartDate date DEFAULT NULL,
  FinishDate date DEFAULT NULL,
  PRIMARY KEY (Code)
) ;

--
-- Đang đổ dữ liệu cho bảng Semester
--

INSERT INTO Semester (Code, StartDate, FinishDate) VALUES
('191', '2019-06-01', '2019-12-31'),
('201', '2020-06-01', '2020-12-31'),
('202', '2021-01-01', '2021-07-01');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Staff
--

DROP TABLE IF EXISTS Staff;
CREATE TABLE IF NOT EXISTS Staff (
  ID varchar(10) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Staff
--

INSERT INTO Staff (ID) VALUES
('GV12345'),
('off123'),
('LEC123');


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Student
--

DROP TABLE IF EXISTS Student;
CREATE TABLE IF NOT EXISTS Student (
  ID varchar(10) NOT NULL,
  Grade varchar(5) DEFAULT NULL,
  Status varchar(20) DEFAULT NULL,
  FacultyCode varchar(3) DEFAULT NULL,
  PRIMARY KEY (ID),
  KEY FacultyCode (FacultyCode)
) ;

--
-- Đang đổ dữ liệu cho bảng Student
--

INSERT INTO Student (ID, Grade, Status, FacultyCode) VALUES
('1814259', 'K18', 'Normal', 'CSE'),
('1814491', 'K18', 'Normal', 'CO'),
('1814492', 'K18', 'Normal', 'CE');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Subject
--

DROP TABLE IF EXISTS Subject;
CREATE TABLE IF NOT EXISTS Subject (
  Code varchar(10) NOT NULL,
  Name varchar(40) DEFAULT NULL,
  NoOfCredits int DEFAULT NULL,
  FacultyCode varchar(3) DEFAULT NULL,
  PRIMARY KEY (Code),
  KEY FacultyCode (FacultyCode)
) ;

--
-- Đang đổ dữ liệu cho bảng Subject
--

INSERT INTO Subject (Code, Name, NoOfCredits, FacultyCode) VALUES
('1001', 'Giải tích', 3, 'CO'),
('1002', 'Hóa', 3, 'CO'),
('1003', 'Nhập môn lập trình', 4, 'CO'),
('2002', 'Hệ thống số ', 2, 'CE'),
('2008', 'Điện tử', 4, 'CE'),
('3005', 'Giải thuật', 3, 'CS'),
('3006', 'Cấu trúc dữ liệu', 9, 'CS'),
('973963', 'Lập trình web', 3, 'CO'),
('abc', 'demo', 4, 'CO'),
('CO2014', 'Hệ cơ sở dữ liệu', 4, 'CSE'),
('CO3003', 'Mạng máy tính', 4, 'CSE'),
('CO3005', 'Nguyên lý ngôn ngữ lập trình', 4, 'CSE'),
('CO3031', 'Phân tích và thiết kế giải thuật', 3, 'CSE'),
('CO3059', 'Đồ họa máy tính', 3, 'CSE'),
('CO3061', 'Nhập môn trí tuệ nhân tạo', 3, 'CSE'),
('CO3065', 'Công nghệ phần mềm nâng cao', 3, 'CSE'),
('CO3067', 'Tính toán song song', 3, 'CSE'),
('CO3069', 'Mật mã và an ninh mạng', 3, 'CSE'),
('CO3087', 'Thực tập đồ án đa ngành', 2, 'CSE');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Teach
--

DROP TABLE IF EXISTS Teach;
CREATE TABLE IF NOT EXISTS Teach (
  LecturerID varchar(10) NOT NULL,
  SubjectCode varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  ClassName varchar(10) NOT NULL,
  Week varchar(5) DEFAULT NULL,
  PRIMARY KEY (LecturerID,SubjectCode,SemesterCode,ClassName),
  KEY SubjectCode (SubjectCode,SemesterCode,ClassName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng Teach
--

INSERT INTO Teach (LecturerID, SubjectCode, SemesterCode, ClassName, Week) VALUES
('GV12345', '1001', '191', 'L01', '1-4'),
('LEC123','1001','191','L01','5-10');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng Textbook
--

DROP TABLE IF EXISTS Textbook;
CREATE TABLE IF NOT EXISTS Textbook (
  Code varchar(10) NOT NULL,
  Name varchar(40) DEFAULT NULL,
  Summary varchar(100) DEFAULT NULL,
  PublisherName varchar(50) DEFAULT NULL,
  Edition int DEFAULT NULL,
  Year year DEFAULT NULL,
  PRIMARY KEY (Code),
  KEY PublisherName (PublisherName)
) ;
--
-- Đang đổ dữ liệu cho bảng Textbook
--
INSERT INTO Textbook (Code, Name, Summary, PublisherName, Edition, Year) VALUES
('T1001','Calculus One' ,'Best Calculus book in the world!', 'Pearson', 1, 2020);
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng TextbookCategory
--

DROP TABLE IF EXISTS TextbookCategory;
CREATE TABLE IF NOT EXISTS TextbookCategory (
  TextbookCode varchar(10) DEFAULT NULL,
  Category varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng UseFor
--

DROP TABLE IF EXISTS UseFor;
CREATE TABLE IF NOT EXISTS UseFor (
  TextbookCode varchar(10) NOT NULL,
  SubjectCode varchar(10) NOT NULL,
  RecommendLecturerID varchar(10) NOT NULL,
  SemesterCode varchar(10) NOT NULL,
  PRIMARY KEY (TextbookCode,SubjectCode, SemesterCode),
  UNIQUE KEY TextbookCode (TextbookCode,RecommendLecturerID,SemesterCode),
  KEY SubjectCode (SubjectCode),
  KEY RecommendLecturerID (RecommendLecturerID),
  KEY SemesterCode (SemesterCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng UseFor
--
INSERT INTO UseFor (TextbookCode, SubjectCode, RecommendLecturerID, SemesterCode) VALUES 
('T1001', '1001', 'LEC123', '191');
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng User
--

DROP TABLE IF EXISTS User;
CREATE TABLE IF NOT EXISTS User (
  ID varchar(10) NOT NULL,
  role varchar(14) DEFAULT NULL,
  Fname varchar(15) DEFAULT NULL,
  Mname varchar(15) DEFAULT NULL,
  Lname varchar(15) DEFAULT NULL,
  Email varchar(30) DEFAULT NULL,
  Address varchar(40) DEFAULT NULL,
  Bdate date DEFAULT NULL,
  Username varchar(40) DEFAULT NULL,
  Password varchar(40) DEFAULT NULL,
  PRIMARY KEY (ID)
) ;

--
-- Đang đổ dữ liệu cho bảng User
--

INSERT INTO User (ID, role, Fname, Mname, Lname, Email, Address, Bdate, Username, Password) VALUES
('1814259', 'Student', 'Trần', 'Đình', 'Vĩnh Thụy', 'trandinhvinhthuy@gmail.com', 'Ho Chi Minh', '2000-01-07', 'nouisme', '123456'),
('LEC123','Lecturer','demo', 'lecturer','one','demolecturer@gmail.com','HCM','1990-01-01','demolecturer','123456'),
('1814491', 'Student', 'vo', 'ngoc', 'trong', 'trong.vo102@hcmut.edu.vn', NULL, NULL, 'vnt', 'vnt'),
('1814492', 'Student', 'abc', 'abc', 'abc', 'abc.abc123@hcmut.edu.vn', NULL, NULL, 'abc', 'abc'),
('GV12345', 'Lecturer', 'xyz', 'xyz', 'xyz', 'xyz.xyz102@hcmut.edu.vn', NULL, NULL, 'xyz', 'xyz'),
('off123', 'FacultyOfficer', 'offfuc', 'offfuc', 'offfuc', 'offfuc.off102@hcmut.edu.vn', NULL, NULL, 'offfuc', 'offfuc');



-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng UserPhone
--

DROP TABLE IF EXISTS UserPhone;
CREATE TABLE IF NOT EXISTS UserPhone (
  UserID varchar(10) NOT NULL,
  Phone varchar(15) NOT NULL,
  PRIMARY KEY (UserID,Phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng UserPhone
--

INSERT INTO UserPhone VALUES
('1814259', '0123454545'),
('LEC123', '0135724680'),
('1814491', '0123577977'),
('1814492', '0167872426'),
('GV12345', '0326260752'),
('off123',  '0186213435');
--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng AAOStaff
--
ALTER TABLE AAOStaff
  ADD CONSTRAINT AAOStaff_ibfk_1 FOREIGN KEY (ID) REFERENCES Staff (ID);

--
-- Các ràng buộc cho bảng Author
--
ALTER TABLE Author
  ADD CONSTRAINT Author_ibfk_1 FOREIGN KEY (TexbookCode) REFERENCES Textbook (Code);

--
-- Các ràng buộc cho bảng Class
--
ALTER TABLE Class
  ADD CONSTRAINT Class_ibfk_1 FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
  ADD CONSTRAINT Class_ibfk_2 FOREIGN KEY (SemesterCode) REFERENCES Semester (Code),
  ADD CONSTRAINT Class_ibfk_3 FOREIGN KEY (MainLecturerID) REFERENCES Lecturer (ID);

--
-- Các ràng buộc cho bảng ClassTime
--
ALTER TABLE ClassTime
  ADD CONSTRAINT ClassTime_ibfk_1 FOREIGN KEY (SubjectCode,SemesterCode,ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName);

--
-- Các ràng buộc cho bảng ContactAddress
--
ALTER TABLE ContactAddress
  ADD CONSTRAINT ContactAddress_ibfk_1 FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code);

--
-- Các ràng buộc cho bảng Enroll
--
ALTER TABLE Enroll
  ADD CONSTRAINT Enroll_ibfk_1 FOREIGN KEY (StudentID) REFERENCES Student (ID),
  ADD CONSTRAINT Enroll_ibfk_2 FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
  ADD CONSTRAINT Enroll_ibfk_3 FOREIGN KEY (SemesterCode) REFERENCES Semester (Code);

--
-- Các ràng buộc cho bảng FacultyOfficer
--
ALTER TABLE FacultyOfficer
  ADD CONSTRAINT FacultyOfficer_ibfk_1 FOREIGN KEY (ID) REFERENCES FacultyStaff (ID);

--
-- Các ràng buộc cho bảng FacultyStaff
--
ALTER TABLE FacultyStaff
  ADD CONSTRAINT FacultyStaff_ibfk_1 FOREIGN KEY (ID) REFERENCES Staff (ID),
  ADD CONSTRAINT FacultyStaff_ibfk_2 FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code);

--
-- Các ràng buộc cho bảng Learn
--
ALTER TABLE Learn
  ADD CONSTRAINT Learn_ibfk_1 FOREIGN KEY (StudentID) REFERENCES Student (ID),
  ADD CONSTRAINT Learn_ibfk_2 FOREIGN KEY (SubjectCode,SemesterCode,ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName);

--
-- Các ràng buộc cho bảng Lecturer
--
ALTER TABLE Lecturer
  ADD CONSTRAINT Lecturer_ibfk_1 FOREIGN KEY (ID) REFERENCES FacultyStaff (ID);



--
-- Các ràng buộc cho bảng OpenedIn
--
ALTER TABLE OpenedIn
  ADD CONSTRAINT OpenedIn_ibfk_1 FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
  ADD CONSTRAINT OpenedIn_ibfk_2 FOREIGN KEY (SemesterCode) REFERENCES Semester (Code),
  ADD CONSTRAINT OpenedIn_ibfk_3 FOREIGN KEY (HeadOfSubjectID) REFERENCES Lecturer (ID);

--
-- Các ràng buộc cho bảng Staff
--
ALTER TABLE Staff
  ADD CONSTRAINT Staff_ibfk_1 FOREIGN KEY (ID) REFERENCES User (ID);

--
-- Các ràng buộc cho bảng Student
--
ALTER TABLE Student
  ADD CONSTRAINT Student_ibfk_1 FOREIGN KEY (ID) REFERENCES User (ID),
  ADD CONSTRAINT Student_ibfk_2 FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code);

--
-- Các ràng buộc cho bảng Subject
--
ALTER TABLE Subject
  ADD CONSTRAINT Subject_ibfk_1 FOREIGN KEY (FacultyCode) REFERENCES Faculty (Code);

--
-- Các ràng buộc cho bảng Teach
--
ALTER TABLE Teach
  ADD CONSTRAINT Teach_ibfk_1 FOREIGN KEY (LecturerID) REFERENCES Lecturer (ID),
  ADD CONSTRAINT Teach_ibfk_2 FOREIGN KEY (SubjectCode,SemesterCode,ClassName) REFERENCES Class (SubjectCode, SemesterCode, ClassName);

--
-- Các ràng buộc cho bảng Textbook
--
ALTER TABLE Textbook
  ADD CONSTRAINT Textbook_ibfk_1 FOREIGN KEY (PublisherName) REFERENCES Publisher (Name);

--
-- Các ràng buộc cho bảng UseFor
--
ALTER TABLE UseFor
  ADD CONSTRAINT UseFor_ibfk_1 FOREIGN KEY (TextbookCode) REFERENCES Textbook (Code),
  ADD CONSTRAINT UseFor_ibfk_2 FOREIGN KEY (SubjectCode) REFERENCES Subject (Code),
  ADD CONSTRAINT UseFor_ibfk_3 FOREIGN KEY (RecommendLecturerID) REFERENCES Lecturer (ID),
  ADD CONSTRAINT UseFor_ibfk_4 FOREIGN KEY (SemesterCode) REFERENCES Semester (Code);

--
-- Các ràng buộc cho bảng UserPhone
--
ALTER TABLE UserPhone
  ADD CONSTRAINT UserPhone_ibfk_1 FOREIGN KEY (UserID) REFERENCES User (ID);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- ################### VIEW - FUNCTION - PROCEDURE ###############
DROP VIEW IF EXISTS LecturersOfClass;
CREATE VIEW LecturersOfClass AS
SELECT SubjectCode, ClassName, SemesterCode, GROUP_CONCAT(DISTINCT fullname SEPARATOR ', ') Lecturers, GROUP_CONCAT(DISTINCT Week SEPARATOR ', ') Weeks
FROM (SELECT SubjectCode, ClassName, SemesterCode, LecturerID, getUserFullName(LecturerID) fullname, Week 
     FROM Teach) T;
-- 
DROP VIEW IF EXISTS LecturersInfo;
CREATE VIEW LecturersInfo AS
SELECT L.ID LecturerID, getUserFullName(L.ID) Fullname, U.Email, U.Address, U.Bdate, P.Phone
FROM Lecturer L, User U, UserPhone P
WHERE L.ID = U.ID AND U.ID = P.UserID;
--
DROP PROCEDURE IF EXISTS SemesterCodeNYearAgo;
DELIMITER |
CREATE PROCEDURE SemesterCodeNYearAgo(
	IN nyear INT)
BEGIN
	SELECT Code FROM Semester
    WHERE StartDate >= (NOW() - INTERVAL nyear YEAR) AND FinishDate <= NOW();
END |
DELIMITER ;
--
DROP FUNCTION IF EXISTS SemesterInRangeNYear;
DELIMITER |
CREATE FUNCTION SemesterInRangeNYear(semestercode VARCHAR(10),
	nyear INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
	RETURN semestercode = ANY (SELECT Code FROM Semester
    WHERE StartDate >= (NOW() - INTERVAL nyear YEAR) AND FinishDate <= NOW());
END |
DELIMITER ;
--
DELIMITER |
CREATE FUNCTION CountStudentsInClass(subjectcode VARCHAR(10), semestercode VARCHAR(10), classname VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN (SELECT nstudents FROM (SELECT SubjectCode, SemesterCode, ClassName, COUNT(StudentID) nstudents FROM Learn
GROUP BY SubjectCode, SemesterCode, ClassName) t
			WHERE SubjectCode = subjectcode 
            AND SemesterCode = semestercode
            AND ClassName = classname);
END |
DELIMITER ;
