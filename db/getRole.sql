USE Learning_Teaching;

DROP PROCEDURE IF EXISTS getRole;

DELIMITER $$
CREATE PROCEDURE getRole(IN ID VARCHAR(10), OUT role VARCHAR(30))
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
END $$
DELIMITER ;