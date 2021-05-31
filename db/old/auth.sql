
-- # 1Cập nhật đăng ký môn học
DROP FUNCTION IF EXISTS ModifyClassForSubject;

DELIMITER |
CREATE FUNCTION ModifyClassForSubject(
    role VARCHAR(14),
    mani_type VARCHAR(6),
    subject_code VARCHAR(10),
    semester_code VARCHAR(10),
    class_name VARCHAR(10),
    main_lecturerID VARCHAR(10),
    date VARCHAR(9),
    start_time TIME,
    finish_time TIME,
    room VARCHAR(10)
	)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Class' OR model = 'ClassTime')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	INSERT INTO Class
    	VALUES (subject_code, semester_code, class_name, main_lecturerID);

        INSERT INTO ClassTime
        VALUES (subject_code, semester_code, class_name, date, start_time, finish_time, room);

        RETURN 'Successful!';
    ELSEIF mani_type = 'UPDATE' THEN
		UPDATE Class
        SET MainLecturerID = main_lecturerID
		WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;

        UPDATE ClassTime
        SET Date = date, StartTime = start_time, FinishTime = finish_time, Room = room
        WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;

        RETURN 'Successful!';
    ELSEIF mani_type = 'DELETE' THEN
    	IF main_lecturerID IS NULL AND date IS NULL AND start_time IS NULL AND finish_time IS NULL AND room IS NULL THEN
        	DELETE FROM Class
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;

            DELETE FROM ClassTime
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;
        ELSE
        	DELETE FROM ClassTime
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name
            AND Date = date AND StartTime = start_time AND FinishTime = finish_time AND Room = room;
        END IF;

        RETURN 'Successful!';
    END IF;
	RETURN 'Nothing has changed!';
END |
DELIMITER ;

# Cập nhật lớp của môn học đã đăng ký của mỗi sinh viên ở mỗi học kỳ
DROP PROCEDURE IF EXISTS ModifyClassOfSubjectOfStudent;

DELIMITER |
CREATE FUNCTION ModifyClassOfSubjectOfStudent(
    role VARCHAR(14),
    mani_type VARCHAR(6),
    subject_code VARCHAR(10),
    class_name VARCHAR(10),
    student_id VARCHAR(10),
    semester_code VARCHAR(10)
	)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Learn')
	OR subject_code <> ALL (SELECT SubjectCode
                            FROM OpenedIn)
	OR class_name <> ALL (SELECT ClassName
                          FROM Class
                          WHERE SubjectCode = subject_code)
	OR 'Normal' <> (SELECT Status
                    FROM Student
                    WHERE ID = student_id)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	INSERT INTO Learn (StudentID, SubjectCode, SemesterCode, ClassName)
        VALUES (student_id, subject_code, semester_code, class_name);

        RETURN 'Successful!';
    ELSEIF mani_type = 'DELETE' THEN
    	DELETE FROM Learn
        WHERE StudentID = student_id AND SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;

        RETURN 'Successful!';
    # ELSEIF mani_type = 'UPDATE' THEN , nothing to update ?
    END IF;
    RETURN 'Nothing has changed!';
END |
DELIMITER ;

-- # 2Cập nhật danh sách môn học được mở trước đầu mỗi học kỳ
DROP FUNCTION IF EXISTS ModifySubject;

DELIMITER |
CREATE FUNCTION ModifySubject(
    role VARCHAR(14),
    mani_type VARCHAR(6),
    subject_code VARCHAR(10),
    semester_code VARCHAR(10)
    )
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'OpenedIn')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	INSERT INTO OpenedIn
        VALUES (subject_code, semester_code);

        RETURN 'Successful!';
    ELSEIF mani_type = 'DELETE' THEN
    	DELETE FROM OpenedIn
        WHERE SubjectCode = subject_code AND SemesterCode = semester_code;

        RETURN 'Successful!';
    # ELSEIF mani_type = 'UPDATE' THEN , nothing to update ?
    END IF;
    RETURN 'Nothing has changed!';
END |
DELIMITER ;

-- # 3Cập nhật danh sách giảng viên phụ trách mỗi lớp học được mở trước đầu mỗi học kỳ
DROP FUNCTION IF EXISTS ModifyLecturerForClass;

DELIMITER |
CREATE FUNCTION ModifyLecturerForClass(
    role VARCHAR(14),
    mani_type VARCHAR(6),
    lecturerID VARCHAR(10),
    main_lecturerID VARCHAR(10),
    subject_code VARCHAR(10),
    semester_code VARCHAR(10),
    class_name VARCHAR(10),
    week VARCHAR(5)
    )
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Teach')
    OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Manage')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	IF lecturerID IS NOT NULL THEN
	    	INSERT INTO Teach
    	    VALUES (lecturerID, subject_code, semester_code, class_name, week);
        ELSEIF main_lecturerID IS NOT NULL THEN
        	INSERT INTO Teach
            VALUES (main_lecturerID, subject_code, semester_code, class_name, week);

            INSERT INTO Manage
            VALUES (main_lecturerID, subject_code, semester_code, class_name);
        END IF;

        RETURN 'Successful!';
    ELSEIF mani_type = 'DELETE' THEN
    	IF lecturerID IS NOT NULL THEN
	    	DELETE FROM Teach
    	    WHERE LecturerID = lecturerID AND SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name AND Week = week;
        ELSEIF main_lecturerID IS NOT NULL THEN
        	DELETE FROM Teach
            WHERE LecturerID = main_lecturerID AND SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name AND Week = week;

            DELETE FROM Manage
            WHERE LecturerID = main_lecturerID AND SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;
        END IF;

        RETURN 'Successful!';
    ELSEIF mani_type = 'UPDATE' THEN
    	IF lecturerID IS NOT NULL THEN
	    	UPDATE Teach
    	    SET LecturerID = lecturerID, Week = week
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;
        ELSEIF main_lecturerID IS NOT NULL THEN
        	UPDATE Teach
    	    SET LecturerID = main_lecturerID, Week = week
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;

            UPDATE Manage
    	    SET LecturerID = main_lecturerID
            WHERE SubjectCode = subject_code AND SemesterCode = semester_code AND ClassName = class_name;
        END IF;

        RETURN 'Successful!';
    END IF;
    RETURN 'Nothing has changed!';
END |
DELIMITER ;

-- # 4Cập nhật giáo trình chính cho môn học (do mình phụ trách chính)
DROP FUNCTION IF EXISTS ModifyTextbookForSubject;

DELIMITER |
CREATE FUNCTION ModifyTextbookForSubject (
    role VARCHAR(14),
    mani_type VARCHAR(6),
	book_code VARCHAR(10),
    book_name VARCHAR(40),
    summary VARCHAR(100),
    publisher_name VARCHAR(50),
    edition INT,
    year YEAR,
    category VARCHAR(20),
    subject_code VARCHAR(10),
    recommend_lecturerID VARCHAR(10)
	)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Textbook')
	OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'TextbookCategory')
	OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'UseFor')
	OR subject_code <> ALL (SELECT SubjectCode
                            FROM Manage
                            WHERE LecturerID = recommend_lecturerID)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	INSERT INTO Textbook
        VALUES (book_code, book_name, summary, publisher_name, edition, year);

        INSERT INTO TextbookCategory
        VALUES (book_code, category);

        INSERT INTO UseFor
        VALUES (book_code, subject_code, recommend_lecturerID);

        RETURN 'Successful!';
    ELSEIF mani_type = 'DELETE' THEN
    	DELETE FROM Textbook
        WHERE Code = book_code;

        DELETE FROM TextbookCategory
        WHERE TextbookCode = book_code;

        DELETE FROM UseFor
        WHERE TexbookCode= book_code;

        RETURN 'Successful!';
    ELSEIF mani_type = 'UPDATE' THEN
    	UPDATE Textbook
        SET Name = book_name, Summary = summary, PublisherName = publisher_name, Edition = edition, Year = year
        WHERE Code = book_code;

        UPDATE TextbookCategory
        SET Category = category
        WHERE TextbookCode = book_code;

        RETURN 'Successful!';
    END IF;

    RETURN 'Nothing has changed!';
END |
DELIMITER ;

-- # 5Đăng ký môn học ở học kỳ được đăng ký
DROP FUNCTION IF EXISTS RegisterSubject;

DELIMITER |
CREATE FUNCTION RegisterSubject (
    role VARCHAR(14),
    mani_type VARCHAR(6),
    student_id VARCHAR(10),
    subject_code VARCHAR(10),
    semester_code VARCHAR(10)
    )
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = mani_type AND model = 'Register')
	OR 'Normal' <> (SELECT Status
                    FROM Student
                    WHERE ID = student_id)
	OR subject_code <> ALL (SELECT SubjectCode
                            FROM OpenedIn
                            WHERE SemesterCode = semester_code)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    IF mani_type = 'INSERT' THEN
    	INSERT INTO Register
        VALUES (student_id, subject_code, semester_code);

        RETURN 'Succesful!';
    ELSEIF mani_type = 'DELETE' THEN
    	DELETE FROM Register
        WHERE StudentID = student_id AND SubjectCode = subject_code;

        RETURN 'Successful!';
    # ELSEIF mani_type = 'UPDATE' THEN , nothing to update ?

    END IF;
    RETURN 'Nothing has changed!';
END |
DELIMITER ;

-- # 6Xem danh sách lớp đã được đăng ký bởi một sinh viên ở một học kỳ
DROP PROCEDURE IF EXISTS RegisteredClassOfStudent;

DELIMITER |
CREATE PROCEDURE RegisteredClassOfStudent(
    IN role VARCHAR(14),
    IN student_id VARCHAR(10),
    IN semester_code VARCHAR(10)
	)
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'Register')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

	SELECT *
    FROM Class
    WHERE SubjectCode IN (SELECT SubjectCode
                          FROM Register
                          WHERE StudentID = student_id AND SemesterCode = semester_code)
	AND SemesterCode = semester_code;
END |
DELIMITER ;

-- # 7Xem danh sách lớp được phụ trách bởi một giảng viên ở một học kỳ
DROP PROCEDURE IF EXISTS ClassOfLecturer;
DELIMITER |
CREATE PROCEDURE ClassOfLecturer(
    IN role VARCHAR(14),
    IN lecturerID VARCHAR(10),
    IN semester_code VARCHAR(10)
    )
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'Teach')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

	SELECT SubjectCode, ClassName, SemesterCode
    FROM Teach
    WHERE LecturerID = lecturerID;
END |
DELIMITER ;

-- # 8Xem danh sách sinh viên đăng ký ở mỗi lớp ở mỗi học kỳ ở mỗi khoa
DROP PROCEDURE IF EXISTS StudentsInClassOfFaculty;

DELIMITER |
CREATE PROCEDURE StudentsInClassOfFaculty(
    IN role VARCHAR(14),
    IN subject_code VARCHAR(10),
    IN class_name VARCHAR(10),
    IN semester_code VARCHAR(10),
    IN faculty_code VARCHAR(10)
	)
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'Learn')
    OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'Student')
	OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'User')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    SELECT U.ID, Fname, Mname, Lname, Grade
    FROM User U join Student S ON U.ID = S.ID
    WHERE S.FacultyCode = faculty_code
    AND S.ID IN (SELECT StudentID
               FROM Learn
               WHERE SubjectCode = subject_code AND ClassName = class_name AND SemesterCode = semester_code);
END |
DELIMITER ;

-- # 9Xem danh sách giảng viên phụ trách ở mỗi lớp ở mỗi học kỳ ở mỗi khoa
DROP PROCEDURE IF EXISTS LecturersInClassOfFaculty;
DELIMITER |
CREATE PROCEDURE LecturersInClassOfFaculty(
    IN role VARCHAR(14),
    IN subject_code VARCHAR(10),
    IN class_name VARCHAR(10),
    IN semester_code VARCHAR(10),
    IN faculty_code VARCHAR(10)
	)
BEGIN
	IF role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'Teach')
    OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'User')
	OR role <> ALL (SELECT role
                    FROM Permission
                    WHERE manipulator = 'SELECT' AND model = 'FacultyStaff')
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permission denied!';
    END IF;

    SELECT U.ID, Fname, Mname, Lname
    FROM User U JOIN FacultyStaff FS ON U.ID = FS.ID
    WHERE FS.FacultyCode = faculty_code
    AND FS.ID IN (SELECT LecturerID
               FROM Teach
               WHERE SubjectCode = subject_code AND ClassName = class_name AND SemesterCode = semester_code);
END |
DELIMITER ;

-- # 10 Xem các giáo trình được chỉ định cho mỗi môn học ở mỗi học kỳ ở mỗi khoa
DELIMITER $$

DROP PROCEDURE IF EXISTS textbooksEachSubEachSemEachFac $$
CREATE PROCEDURE textbooksEachSubEachSemEachFac(IN r varchar(14))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Faculty')
           and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject')
            and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Textbook') then
        select * from ((Textbook join UseFor on Textbook.Code = UseFor.TexbookCode) join Subject on UseFor.SubjectCode = Subject.Code) join Faculty on Subject.FacultyCode = Faculty.Code;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;
END; $$
DELIMITER ;

call nSubPerSemesterEachFaculty('AAOSta');
-- 11. Xem tổng số môn học được đăng ký ở mỗi học kỳ ở mỗi khoa
DELIMITER $$

DROP PROCEDURE IF EXISTS nSubPerSemesterEachFaculty $$
CREATE PROCEDURE nSubPerSemesterEachFaculty(IN r varchar(14))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Faculty') and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject') then
        select Faculty.code, Faculty.name, OpenedIn.SemesterCode, count(*) as nSub from (Faculty join Subject on Subject.FacultyCode = Faculty.Code) join OpenedIn on OpenedIn.SubjectCode = Subject.Code group by OpenedIn.SemesterCode,Faculty.code, Faculty.name;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;
END; $$
DELIMITER ;

call nSubPerSemesterEachFaculty('AAOSta');
-- # 12 Xem tổng số lớp được mở ở mỗi học kỳ ở mỗi khoa
DELIMITER $$

DROP PROCEDURE IF EXISTS nClassPerSemesterEachFaculty $$
CREATE PROCEDURE nClassPerSemesterEachFaculty(IN r varchar(14))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Faculty') and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject') then
        select Subject.FacultyCode, Faculty.Name, SemesterCode ,count(*) as nClass
        from (Subject join Faculty on Subject.FacultyCode = Faculty.Code) join Class C on Subject.Code = C.SubjectCode
        group by SemesterCode,Subject.FacultyCode;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;
END; $$
DELIMITER ;

-- # 13 Xem tổng số sinh viên đăng ký ở mỗi lớp của một môn học ở một học kỳ
DELIMITER $$

DROP PROCEDURE IF EXISTS nStdEachClassInSem $$
CREATE PROCEDURE nStdEachClassInSem(IN r varchar(14), IN semesterCode varchar(10), in subjectCode varchar(10))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Learn') then
        select Learn.ClassName ,count(*) as nStudent
        from Learn
        where Learn.SemesterCode = semesterCode
          and Learn.SubjectCode = subjectCode
        group by Learn.ClassName;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;
END; $$
DELIMITER ;

call nStdEachClassInSem('Student', '191','1001');
-- # 14 Xem tổng số sinh viên đăng ký ở mỗi môn học ở một học kỳ
DELIMITER $$

DROP PROCEDURE IF EXISTS nStdEachSubInSem $$
CREATE PROCEDURE nStdEachSubInSem(IN r varchar(14), IN semesterCode varchar(10))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Learn') then
        select Learn.SubjectCode ,count(*) as nStudent
        from Learn
        where Learn.SemesterCode = semesterCode
        group by Learn.SubjectCode;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;

END; $$
DELIMITER ;

call nStdEachSubInSem('Student', '191');
-- # 15 Xem tổng số sinh viên đăng ký ở mỗi học kỳ ở mỗi khoa
DELIMITER $$

DROP PROCEDURE IF EXISTS nStdEachSemEachFac $$
CREATE PROCEDURE nStdEachSemEachFac(IN r varchar(14))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Learn') and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject') then
        select Subject.FacultyCode,SemesterCode,count(*) as nStudent from Learn join Subject on SubjectCode = Subject.Code group by Subject.FacultyCode,SemesterCode;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;
END; $$
DELIMITER ;

-- # 16 - 18 chức năng của khoa
-- # 16 Xem danh sách môn học ở một học kỳ
DELIMITER $$

DROP PROCEDURE IF EXISTS subjectsInSemOfFac $$
CREATE PROCEDURE subjectsInSemOfFac(IN r varchar(14), IN facultyCode varchar(3),IN semesterCode varchar(10))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject') and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Class')then
        select *
        from Subject
        where Subject.FacultyCode = facultyCode
          and Subject.Code in (
              select SubjectCode
              from Class
              where Class.SemesterCode = semesterCode
              );
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;

END; $$
DELIMITER ;
call subjectsInSemOfFac('CO','202');
-- # 17 Xem danh sách giảng viên ở một học kỳ
DELIMITER $$

DROP PROCEDURE IF EXISTS lecturersInSemOfFac $$
CREATE PROCEDURE lecturersInSemOfFac(IN r varchar(14), IN FacCode varchar(3),IN semesterCode varchar(10))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Lecturer')
            and r in (select role from Permission where manipulator = 'SELECT' AND model = 'User')
            and r in (select role from Permission where manipulator = 'SELECT' AND model = 'FacultyStaff')
            and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Teach') then
        select *
        from (
            Lecturer join FacultyStaff
                on Lecturer.ID = FacultyStaff.ID
            )
            join User
                on FacultyStaff.ID = User.ID
        where FacultyStaff.FacultyCode = FacCode
          and Lecturer.ID in (select Teach.LecturerID from Teach where Teach.SemesterCode = semesterCode);
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;

END; $$
DELIMITER ;
-- # 18 Xem những môn có nhiều giảng viên cùng phụ trách nhất ở một học kỳ
-- # số giảng viên dạy của mỗi môn ở một học kỳ
DELIMITER $$

DROP PROCEDURE IF EXISTS subjectsInSemOfFac $$
CREATE PROCEDURE subjectsInSemOfFac(IN r varchar(14), IN FacCode varchar(3),IN semesterCode varchar(10))
BEGIN
    if r in (select role from Permission where manipulator = 'SELECT' AND model = 'Subject')
            and r in (select role from Permission where manipulator = 'SELECT' AND model = 'Teach') then
        select Subject.Code,Subject.Name, count(*) as nLecturer
        from Subject join (
            select Teach.SubjectCode,Teach.SemesterCode,Teach.LecturerID
            from Teach
            where Teach.SemesterCode = semesterCode
            group by Teach.SubjectCode,Teach.SemesterCode,Teach.LecturerID
            ) as T
            on Subject.Code = T.SubjectCode
        where Subject.FacultyCode = FacCode
        group by Subject.Code;
    else
        signal sqlstate '45000' set message_text = 'Permission denied!';
    end if;

END; $$
DELIMITER ;

-- #19.Xem số học sinh đăng ký trung bình trong 3 năm gần nhất cho một môn học ở một học kỳ
drop procedure if exists GetAvgStudents;
delimiter |
create procedure GetAvgStudents (in r varchar(14), in Faculty_id varchar(10), in subject_code varchar(10))
begin
	if r in (select role from Permission where manipulator='SELECT' and model='Register')
		and r in (select role from Permission where manipulator='SELECT' and model='Semester') then
		select count(*) from Register as r, (select Code from Semester where(StartDate like concat('%',year(curdate()),'%') or StartDate like concat('%',year(curdate()-1),'%') or StartDate like concat('%',year(curdate()-2),'%') )) as s
		where r.SubjectCode = subject_code and r.SemesterCode = s.Code;
	else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #20. Xem so lop hoc do minh phu trach o moi hoc ky trong 3 nam lien tiep gan day nhat
drop procedure if exists GetNoOfClass;
delimiter |
create procedure GetNoOfClass (in r varchar(14), in lecturer_id varchar(10))
begin
	if r in (select role from Permission where manipulator='SELECT' and model='Teach')
		and r in (select role from Permission where manipulator='SELECT' and model='Semester') then
		select count(*) from Teach as t, (select Code from Semester where(StartDate like concat('%',year(curdate()),'%') or StartDate like concat('%',year(curdate()-1),'%') or StartDate like concat('%',year(curdate()-2),'%') )) as s
		where t.LecturerID = lecturer_id and t.SemesterCode = s.Code;
	else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #21. Xem 5 lop hoc co so sinh vien cao nhat ma giang vien tung phu trach
drop procedure if exists FiveHighestClass;
delimiter |
create procedure FiveHighestClass (in r varchar(14), in lecturer_id varchar(10))
begin
	if r in (select role from Permission where manipulator='SELECT' and model='Class')
		and r in (select role from Permission where manipulator='SELECT' and model='Learn')
        and r in (select role from Permission where manipulator='SELECT' and model='Teach') then
		select * from (select Class.ClassName, Class.SubjectCode,Count(*) as NoOfStudent from ((Class join Learn on Class.ClassName = Learn.ClassName))
		group by Class.ClassName order by NoOfStudent desc) as d, Teach as t
		where t.LecturerID = lecturer_id and t.ClassName = d.ClassName
		LIMIT 5;
    else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;
-- #22.Xem 5 học kỳ có so lop nhieu nhat ma giang vien giang day
drop procedure if exists FiveSemesterWithClasses;
delimiter |
create procedure FiveSemesterWithClasses (in r varchar(14), in lecturer_id varchar(10))
begin
	if r in (select role from Permission where manipulator='SELECT' and model='Teach') then
			select  x.SemesterCode,x.NoOfClasses from (select SemesterCode, Count(*) as NoOfClasses from Teach where LecturerID = lecturer_id
			group by SemesterCode order by NoOfClasses desc)  as x
			LIMIT 5;
    else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #23. Xem danh sach lop hoc cua moi mon hoc ma minh dang ky co nhieu hon 1 giang vien phu trach
drop procedure if exists GetListSubject;
delimiter |
create procedure GetListSubject (in r varchar(14), in student_id varchar(10), in semester_code varchar(10))
begin
	if  r in (select role from Permission where manipulator='SELECT' and model='Learn')
        and r in (select role from Permission where manipulator='SELECT' and model='Teach') then
			select c.SemesterCode, c.SubjectCode, c.ClassName, c.NoOfLecturer
			from (select SemesterCode,SubjectCode,ClassName,Count(*) as NoOfLecturer
			from Teach where SemesterCode=semester_code
			group by SemesterCode,SubjectCode,ClassName
			having NoOfLecturer > 1) as c, Learn as l where l.StudentID = student_id and l.ClassName = c.ClassName;
	else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #24.Xem tong so tin chi da dang ky duoc o mot hoc ky
drop procedure if exists TotalCredits;
delimiter |
create procedure TotalCredits (in r varchar(14), in student_id varchar(10), in semester_code varchar(10))
begin
	if  r in (select role from Permission where manipulator='SELECT' and model='Learn')
        and r in (select role from Permission where manipulator='SELECT' and model='Subject') then
		select SUM(NoOfCredits)
		from (select SubjectCode from Learn where StudentID = student_id and SemesterCode = semester_code) as x,
		Subject as s where x.SubjectCode = s.Code;
    else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #25.Xem tong so mon hoc da dang ky o mot hoc ky
drop procedure if exists TotalSubject;
delimiter |
create procedure TotalSubject (in r varchar(14), in student_id varchar(10), in semester_code varchar(10))
begin
	if  r in (select role from Permission where manipulator='SELECT' and model='Learn') then
		select COUNT(*) as NoOfSubject from Learn where StudentID = student_id and SemesterCode = semester_code;
     else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;

-- #26.Xem 3 học kỳ có tổng số tính chỉ cao nhất
drop procedure if exists ThreeHighestCreditsSemester;
delimiter |
create procedure ThreeHighestCreditsSemester (in r varchar(14), in student_id varchar(10))
begin
	if  r in (select role from Permission where manipulator='SELECT' and model='Learn')
        and r in (select role from Permission where manipulator='SELECT' and model='Subject') then
        select x.SemesterCode, x.NoOfCredits from (select SemesterCode, TotalCredits(r,student_id,SemesterCode) as NoOfCredits from Learn where StudentID = student_id order by NoOfCredits desc) as x  LIMIT 3;
	else
		signal sqlstate '45000' set message_text = 'Permission denied';
	end if;
end |
delimiter ;