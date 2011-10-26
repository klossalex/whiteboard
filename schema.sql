CREATE TABLE Users (
    caseid varchar(6) NOT NULL,

    PRIMARY KEY (caseid)
);

CREATE TABLE LoginLog (
    timestamp timestamp NOT NULL,
    caseid varchar(6) NOT NULL,
    ip_address inet NOT NULL,
    cas_ticket varchar(256) NOT NULL,

    PRIMARY KEY (timestamp, cas_ticket),
    FOREIGN KEY (caseid) REFERENCES Users ON DELETE RESTRICT
);

CREATE TABLE Courses (
    courseid serial NOT NULL,
    code varchar(7) NOT NULL,
    term varchar(10) NOT NULL,
    title varchar(256) NOT NULL,

    PRIMARY KEY (courseid)
);

CREATE TABLE Announcements (
    announcementid serial NOT NULL,
    "date" date NOT NULL,
    content text NOT NULL,
    courseid integer NOT NULL,
    caseid varchar(6) NOT NULL,

    PRIMARY KEY (announcementid),
    FOREIGN KEY (courseid) REFERENCES Courses ON DELETE CASCADE,
    FOREIGN KEY (caseid) REFERENCES Users ON DELETE SET NULL
);


CREATE TABLE Assignments (
    assignmentid serial NOT NULL,
    title varchar(256) NOT NULL,
    due date NOT NULL,
    points integer NOT NULL,
    courseid integer NOT NULL,

    PRIMARY KEY (assignmentid),
    FOREIGN KEY (courseid) REFERENCES Courses ON DELETE CASCADE
);

CREATE TABLE Documents (
    documentid serial NOT NULL,
    isfolder boolean NOT NULL,
    name varchar(256) NOT NULL,
    path varchar(256) NOT NULL,
    courseid integer NOT NULL,
    assignmentid integer,
    parent integer,


    PRIMARY KEY (documentid),
    FOREIGN KEY (courseid) REFERENCES Courses ON DELETE CASCADE,
    FOREIGN KEY (assignmentid) REFERENCES Assignments ON DELETE CASCADE,
    FOREIGN KEY (parent) REFERENCES Documents ON DELETE CASCADE
);

CREATE TABLE Grades (
    assignmentid integer NOT NULL,
    caseid varchar(6) NOT NULL,
    score integer NOT NULL,

    PRIMARY KEY (assignmentid, caseid),
    FOREIGN KEY (assignmentid) REFERENCES Assignments ON DELETE CASCADE,
    FOREIGN KEY (caseid) REFERENCES Users ON DELETE CASCADE
);

CREATE TABLE Roles (
    caseid varchar(6) NOT NULL,
    courseid integer,
    rolename varchar(256),

    PRIMARY KEY (caseid, courseid, rolename),
    FOREIGN KEY (caseid) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (courseid) REFERENCES Courses ON DELETE CASCADE
);