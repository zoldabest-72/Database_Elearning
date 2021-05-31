-- List of Lecturers teaching a class
USE Learning_Teaching;

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