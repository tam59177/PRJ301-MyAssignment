CREATE DATABASE [MyAssignment]
USE [MyAssignment]

CREATE TABLE Departments (
	did int primary key identity(1,1),
	dname nvarchar(255) unique not null
);

CREATE TABLE Employees (
	eid int primary key identity(1,1),
	ename nvarchar(255) not null unique,
	email varchar(255) not null unique,
	managerid int,
	did int not null,
	foreign key (did) references Departments(did),
	foreign key (managerid) references Employees(eid)
);

CREATE TABLE Users (
	username nvarchar(50) primary key,
	password varchar(50) not null,
	displayname nvarchar(50) not null unique,
	eid int not null unique,
	foreign key (eid) references Employees(eid)
);

CREATE TABLE LeaveRequests (
	lrid int primary key identity(1,1),
	title nvarchar(255) not null,
	reason text not null,
	[from] date not null,
	[to] date not null,
	status nvarchar(40) not null default('Inprogress'),
	createby nvarchar(50) not null,
	createddate datetime not null,
	owner_eid int not null,
	processedby nvarchar(50) null,
	foreign key (createby) references Users(username),
	foreign key (owner_eid) references Employees(eid),
	foreign key (processedby) references Users(username)
);

CREATE TABLE Features (
	fid int primary key identity(1,1),
	url varchar(255) not null unique
);

CREATE TABLE Roles (
	rid int primary key identity(1,1),
	rname varchar(255) not null unique
);

CREATE TABLE RoleFeature (
	rid int,
	fid int,
	primary key (rid, fid),
	foreign key (rid) references Roles(rid),
	foreign key (fid) references Features(fid)
);

CREATE TABLE UserRole (
	username nvarchar(50),
	rid int,
	primary key (username, rid),
	foreign key (username) references Users(username),
	foreign key (rid) references Roles(rid)
);

INSERT INTO Departments(dname) VALUES ('IT'), ('Marketing'), ('Accounting'), ('Sales')

INSERT INTO Employees(ename, email, did) VALUES ('Tam', 'tam@gmail.com', 1)

INSERT INTO Users(username, password, eid, displayname) VALUES ('tam', 'tam', 1, 'Tam')

INSERT INTO Roles(rname) VALUES ('Division Leader'), ('Mid Manager'), ('Team Leader'), ('Staff')

INSERT INTO Features(url) VALUES ('/home')

INSERT INTO RoleFeature(rid, fid) VALUES (1, 1), (2, 1), (3, 1), (4, 1)

INSERT INTO UserRole(rid, username) VALUES (1, 'tam')