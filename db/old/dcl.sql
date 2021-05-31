CREATE USER 'aao'@'localhost' IDENTIFIED BY 'Aao.aao102';
CREATE USER 'student'@'localhost' IDENTIFIED BY 'Student.student102';
CREATE USER 'lecturer'@'localhost' IDENTIFIED BY 'Lecturer.Lecturer102';
CREATE USER 'facultyofficer'@'localhost' IDENTIFIED BY 'FacultyOfficer.FacultyOfficer102';

CREATE ROLE 'roleaao', 'rolestudent', 'rolelecturer', 'rolefacultyofficer';
# AAO
GRANT SELECT ON * to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Class to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Faculty to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON FacultyStaff to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON FacultyOfficer to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Learn to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Lecturer to 'roleaao';
GRANT SELECT,UPDATE,DELETE ON Register to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Semester to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Staff to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON Student to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON User to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON UserPhone to 'roleaao';
GRANT INSERT,SELECT,UPDATE,DELETE ON ClassTime to 'roleaao';

# student
GRANT SELECT ON * to 'rolestudent';
GRANT INSERT,SELECT,DELETE ON Register to 'rolestudent';
GRANT UPDATE ON Student to 'rolestudent';
GRANT UPDATE(Phone) ON UserPhone to 'rolestudent';
GRANT INSERT,SELECT,UPDATE,DELETE ON Learn to 'rolestudent';
GRANT UPDATE(Email, Address, Password) ON User to 'rolestudent';


# Lecturer
GRANT SELECT ON * TO 'rolelecturer';
GRANT INSERT, DELETE, UPDATE , SELECT ON UseFor TO 'rolelecturer';
GRANT UPDATE (Email, Address, Password), SELECT ON User TO 'rolelecturer';
GRANT UPDATE (Phone), SELECT ON UserPhone TO 'rolelecturer';

# FacultyOfficer
GRANT SELECT ON * TO 'rolefacultyofficer';
GRANT INSERT, DELETE, UPDATE ON ContactAddress TO 'rolefacultyofficer';
GRANT INSERT, DELETE, UPDATE ON Subject TO 'rolefacultyofficer';
GRANT INSERT, DELETE, UPDATE ON Teach TO 'rolefacultyofficer';
GRANT UPDATE (Email, Address, Password) ON User TO 'rolefacultyofficer';
GRANT UPDATE (Phone) ON UserPhone TO 'rolefacultyofficer';
GRANT INSERT, DELETE, UPDATE ON Manage TO 'rolefacultyofficer';
GRANT INSERT, DELETE, UPDATE ON OpenedIn TO 'rolefacultyofficer';




GRANT 'rolelecturer' to 'lecturer'@'localhost';
GRANT 'rolefacultyofficer' to 'facultyofficer'@'localhost';
GRANT 'roleaao' to 'aao'@'localhost';
GRANT 'rolestudent' to 'student'@'localhost';