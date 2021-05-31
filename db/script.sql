create table faculty
(
    Code varchar(3)  not null
        primary key,
    Name varchar(50) null
);

create table contactaddress
(
    FacultyCode varchar(3)  not null,
    Phone       varchar(15) not null,
    Location    varchar(40) null,
    Email       varchar(30) null,
    primary key (FacultyCode, Phone),
    constraint contactaddress_ibfk_1
        foreign key (FacultyCode) references faculty (Code)
);

create table publisher
(
    Name    varchar(50) not null
        primary key,
    Phone   varchar(15) null,
    Address varchar(40) null
);

create table semester
(
    Code       varchar(10) not null
        primary key,
    StartDate  date        null,
    FinishDate date        null
);

create table subject
(
    Code        varchar(10) not null
        primary key,
    Name        varchar(40) null,
    NoOfCredits int         null,
    FacultyCode varchar(3)  null,
    constraint subject_ibfk_1
        foreign key (FacultyCode) references faculty (Code)
);

create index FacultyCode
    on subject (FacultyCode);

create table textbook
(
    Code          varchar(10)  not null
        primary key,
    Name          varchar(40)  null,
    Summary       varchar(100) null,
    PublisherName varchar(50)  null,
    Edition       int          null,
    Year          year         null,
    constraint textbook_ibfk_1
        foreign key (PublisherName) references publisher (Name)
);

create table author
(
    TexbookCode varchar(10) null,
    Name        varchar(45) null,
    constraint author_ibfk_1
        foreign key (TexbookCode) references textbook (Code)
);

create index TexbookCode
    on author (TexbookCode);

create index PublisherName
    on textbook (PublisherName);

create definer = root@localhost trigger CheckYearTextbook
    before insert
    on textbook
    for each row
BEGIN
    IF (NEW.Year + 10 <= YEAR(CURDATE())) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This textbook is obsolete.';
    END IF;
END;

create table textbookcategory
(
    TextbookCode varchar(10) null,
    Category     varchar(20) null
);

create table user
(
    ID       varchar(10) not null
        primary key,
    Fname    varchar(15) null,
    Mname    varchar(15) null,
    Lname    varchar(15) null,
    Email    varchar(30) null,
    Address  varchar(40) null,
    Bdate    date        null,
    Username varchar(40) null,
    Password varchar(40) null
);

create table staff
(
    ID varchar(10) not null
        primary key,
    constraint staff_ibfk_1
        foreign key (ID) references user (ID)
);

create table aaostaff
(
    ID varchar(10) not null
        primary key,
    constraint aaostaff_ibfk_1
        foreign key (ID) references staff (ID)
);

create table lecturer
(
    ID          varchar(10) not null
        primary key,
    FacultyCode varchar(3)  null,
    constraint lecturer_ibfk_1
        foreign key (ID) references staff (ID),
    constraint lecturer_ibfk_2
        foreign key (FacultyCode) references faculty (Code)
);

create table class
(
    SubjectCode    varchar(10) not null,
    SemesterCode   varchar(10) not null,
    ClassName      varchar(10) not null,
    StartTime      time        null,
    FinishTime     time        null,
    Room           varchar(10) null,
    MainLecturerID varchar(10) null,
    primary key (SubjectCode, SemesterCode, ClassName),
    constraint class_ibfk_1
        foreign key (SubjectCode) references subject (Code),
    constraint class_ibfk_2
        foreign key (SemesterCode) references semester (Code),
    constraint class_ibfk_3
        foreign key (MainLecturerID) references lecturer (ID)
);

create index MainLecturerID
    on class (MainLecturerID);

create index SemesterCode
    on class (SemesterCode);

create index FacultyCode
    on lecturer (FacultyCode);

create table student
(
    ID          varchar(10) not null
        primary key,
    Grade       varchar(5)  null,
    Status      varchar(20) null,
    FacultyCode varchar(3)  null,
    constraint student_ibfk_1
        foreign key (ID) references user (ID),
    constraint student_ibfk_2
        foreign key (FacultyCode) references faculty (Code)
);

create table learn
(
    StudentID    varchar(10) not null,
    SubjectCode  varchar(10) not null,
    SemesterCode varchar(10) not null,
    ClassName    varchar(10) not null,
    Attendance   float       null,
    Quiz         float       null,
    Assignment   float       null,
    Midterm      float       null,
    Final        float       null,
    primary key (StudentID, SubjectCode, SemesterCode, ClassName),
    constraint learn_ibfk_1
        foreign key (StudentID) references student (ID),
    constraint learn_ibfk_2
        foreign key (SubjectCode, SemesterCode, ClassName) references class (SubjectCode, SemesterCode, ClassName)
);

create index SubjectCode
    on learn (SubjectCode, SemesterCode, ClassName);

create table register
(
    StudentID    varchar(10) not null,
    SubjectCode  varchar(10) not null,
    SemesterCode varchar(10) null,
    primary key (StudentID, SubjectCode),
    constraint register_ibfk_1
        foreign key (StudentID) references student (ID),
    constraint register_ibfk_2
        foreign key (SubjectCode) references subject (Code),
    constraint register_ibfk_3
        foreign key (SemesterCode) references semester (Code)
);

create index SemesterCode
    on register (SemesterCode);

create index SubjectCode
    on register (SubjectCode);

create definer = root@localhost trigger CheckStudent
    before insert
    on register
    for each row
BEGIN
    IF 'Normal' = (SELECT Status FROM Student WHERE NEW.StudentID = ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This student can not register any subjects';
    END IF;
END;

create index FacultyCode
    on student (FacultyCode);

create table teach
(
    LectureID    varchar(10) not null,
    SubjectCode  varchar(10) not null,
    SemesterCode varchar(10) not null,
    ClassName    varchar(10) not null,
    Week         int         null,
    primary key (LectureID, SubjectCode, SemesterCode, ClassName),
    constraint teach_ibfk_1
        foreign key (LectureID) references lecturer (ID),
    constraint teach_ibfk_2
        foreign key (SubjectCode, SemesterCode, ClassName) references class (SubjectCode, SemesterCode, ClassName)
);

create index SubjectCode
    on teach (SubjectCode, SemesterCode, ClassName);

create table usefor
(
    TexbookCode         varchar(10) not null,
    SubjectCode         varchar(10) not null,
    RecommendLecturerID varchar(10) not null,
    primary key (TexbookCode, SubjectCode),
    constraint TexbookCode
        unique (TexbookCode, RecommendLecturerID),
    constraint usefor_ibfk_1
        foreign key (TexbookCode) references textbook (Code),
    constraint usefor_ibfk_2
        foreign key (SubjectCode) references subject (Code),
    constraint usefor_ibfk_3
        foreign key (RecommendLecturerID) references lecturer (ID)
);

create index RecommendLecturerID
    on usefor (RecommendLecturerID);

create index SubjectCode
    on usefor (SubjectCode);

create definer = root@localhost trigger CheckNoOfTextbooks
    before insert
    on usefor
    for each row
BEGIN
    IF 1 + (SELECT NoOfBooks FROM NoOfTextbooks WHERE NEW.SubjectCode = SubjectCode) > 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Too many textbooks for this subject.';
    END IF;
END;

create table userphone
(
    UserID varchar(10) not null,
    Phone  varchar(15) not null,
    primary key (UserID, Phone),
    constraint userphone_ibfk_1
        foreign key (UserID) references user (ID)
);

create definer = root@localhost view nooftextbooks as
select `learning_teaching`.`usefor`.`SubjectCode` AS `SubjectCode`, count(0) AS `NoOfBooks`
from `learning_teaching`.`usefor`
group by `learning_teaching`.`usefor`.`SubjectCode`;


