USE [master]
GO
/****** Object:  Database [MyAssignment]    Script Date: 3/15/2025 8:51:53 PM ******/
CREATE DATABASE [MyAssignment]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyAssignment', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HOANGANH\MSSQL\DATA\MyAssignment.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MyAssignment_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HOANGANH\MSSQL\DATA\MyAssignment_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MyAssignment].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MyAssignment] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyAssignment] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyAssignment] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyAssignment] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyAssignment] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyAssignment] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MyAssignment] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyAssignment] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyAssignment] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyAssignment] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyAssignment] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyAssignment] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyAssignment] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyAssignment] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyAssignment] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MyAssignment] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyAssignment] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyAssignment] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MyAssignment] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MyAssignment] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyAssignment] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyAssignment] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MyAssignment] SET RECOVERY FULL 
GO
ALTER DATABASE [MyAssignment] SET  MULTI_USER 
GO
ALTER DATABASE [MyAssignment] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyAssignment] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MyAssignment] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MyAssignment] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MyAssignment] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MyAssignment] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MyAssignment', N'ON'
GO
ALTER DATABASE [MyAssignment] SET QUERY_STORE = ON
GO
ALTER DATABASE [MyAssignment] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MyAssignment]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[did] [int] IDENTITY(1,1) NOT NULL,
	[dname] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[did] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[eid] [int] IDENTITY(1,1) NOT NULL,
	[ename] [nvarchar](255) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[managerid] [int] NULL,
	[did] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Features]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Features](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[url] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LeaveRequests]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeaveRequests](
	[lrid] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[reason] [text] NOT NULL,
	[from] [date] NOT NULL,
	[to] [date] NOT NULL,
	[status] [nvarchar](40) NOT NULL,
	[createby] [nvarchar](50) NOT NULL,
	[createddate] [datetime] NOT NULL,
	[owner_eid] [int] NOT NULL,
	[processedby] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[lrid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleFeature]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleFeature](
	[rid] [int] NOT NULL,
	[fid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rid] ASC,
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[rid] [int] IDENTITY(1,1) NOT NULL,
	[rname] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[username] [nvarchar](50) NOT NULL,
	[rid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/15/2025 8:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[username] [nvarchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[displayname] [nvarchar](50) NOT NULL,
	[eid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Departments] ON 

INSERT [dbo].[Departments] ([did], [dname]) VALUES (3, N'Accounting')
INSERT [dbo].[Departments] ([did], [dname]) VALUES (1, N'IT')
INSERT [dbo].[Departments] ([did], [dname]) VALUES (2, N'Marketing')
INSERT [dbo].[Departments] ([did], [dname]) VALUES (4, N'Sales')
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([eid], [ename], [email], [managerid], [did]) VALUES (1, N'Tam', N'tam@gmail.com', NULL, 1)
INSERT [dbo].[Employees] ([eid], [ename], [email], [managerid], [did]) VALUES (2, N'Hung', N'hung@gmail.com', 1, 1)
INSERT [dbo].[Employees] ([eid], [ename], [email], [managerid], [did]) VALUES (3, N'Toan', N'toan@gmail.com', 2, 1)
INSERT [dbo].[Employees] ([eid], [ename], [email], [managerid], [did]) VALUES (4, N'Trang', N'trang@gmail.com', 3, 1)
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
SET IDENTITY_INSERT [dbo].[Features] ON 

INSERT [dbo].[Features] ([fid], [url]) VALUES (7, N'/agenda')
INSERT [dbo].[Features] ([fid], [url]) VALUES (1, N'/home')
INSERT [dbo].[Features] ([fid], [url]) VALUES (2, N'/leaverequest')
INSERT [dbo].[Features] ([fid], [url]) VALUES (3, N'/leaverequest/create')
INSERT [dbo].[Features] ([fid], [url]) VALUES (6, N'/leaverequest/delete')
INSERT [dbo].[Features] ([fid], [url]) VALUES (5, N'/leaverequest/detail')
INSERT [dbo].[Features] ([fid], [url]) VALUES (4, N'/leaverequest/update')
SET IDENTITY_INSERT [dbo].[Features] OFF
GO
SET IDENTITY_INSERT [dbo].[LeaveRequests] ON 

INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (1, N'testupdate', N'Tai vi em bi om', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-06' AS Date), N'Approved', N'tam', CAST(N'2025-03-11T15:22:59.210' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (2, N'test 1', N'test 1', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:20:39.120' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (3, N'test 2', N'test 2', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:20:45.790' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (4, N'test 3', N'test 3', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:20:51.950' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (5, N'test 4', N'test 4', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:20:57.707' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (6, N'test 5', N'test 5 ', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:21:01.593' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (7, N'test 6', N'test 6', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:21:06.227' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (8, N'test 7', N'test 7', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-15' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-11T16:21:10.833' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (9, N'teamlead', N'teamlead', CAST(N'2025-03-05' AS Date), CAST(N'2025-03-14' AS Date), N'Inprogress', N'teamleader', CAST(N'2025-03-11T17:03:23.233' AS DateTime), 3, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (10, N'staff', N'staff', CAST(N'2025-03-12' AS Date), CAST(N'2025-03-13' AS Date), N'Approved', N'staff', CAST(N'2025-03-11T19:16:18.640' AS DateTime), 4, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (11, N'Test 4', N'asdfasdf', CAST(N'2025-03-04' AS Date), CAST(N'2025-03-21' AS Date), N'Approved', N'staff', CAST(N'2025-03-15T15:21:38.600' AS DateTime), 4, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (12, N'Test 444', N'qwerqwer', CAST(N'2025-02-27' AS Date), CAST(N'2025-03-22' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:22:22.050' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (13, N'test 444444', N'444444', CAST(N'2025-03-07' AS Date), CAST(N'2025-03-01' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:24:14.717' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (14, N'test 444444', N'444444', CAST(N'2025-03-07' AS Date), CAST(N'2025-03-01' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:25:02.727' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (15, N'test 444444', N'444444', CAST(N'2025-03-07' AS Date), CAST(N'2025-03-01' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:25:44.573' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (16, N'test 444444', N'444444', CAST(N'2025-03-07' AS Date), CAST(N'2025-03-01' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:26:08.217' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (17, N'test 444444 up 2', N'444444', CAST(N'2025-03-07' AS Date), CAST(N'2025-03-01' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:27:03.570' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (18, N'Test 123123 update page 2', N'asdfasdf', CAST(N'2025-03-01' AS Date), CAST(N'2025-03-29' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T15:33:19.290' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (19, N'team lead 2 test', N'awer', CAST(N'2025-03-01' AS Date), CAST(N'2025-03-22' AS Date), N'Rejected', N'teamleader', CAST(N'2025-03-15T16:39:55.290' AS DateTime), 3, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (20, N'test', N'test', CAST(N'2025-03-17' AS Date), CAST(N'2025-03-17' AS Date), N'Approved', N'staff', CAST(N'2025-03-15T18:18:01.013' AS DateTime), 4, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (21, N'Test LR Edit', N'ádfasdf', CAST(N'2025-03-15' AS Date), CAST(N'2025-03-20' AS Date), N'Inprogress', N'tam', CAST(N'2025-03-15T20:29:25.103' AS DateTime), 1, NULL)
INSERT [dbo].[LeaveRequests] ([lrid], [title], [reason], [from], [to], [status], [createby], [createddate], [owner_eid], [processedby]) VALUES (22, N'Staff 10', N'test', CAST(N'2025-03-08' AS Date), CAST(N'2025-03-22' AS Date), N'Rejected', N'staff', CAST(N'2025-03-15T20:34:53.303' AS DateTime), 4, NULL)
SET IDENTITY_INSERT [dbo].[LeaveRequests] OFF
GO
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 1)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 4)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 5)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 6)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 7)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 1)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 4)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 5)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 6)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 1)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 4)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 5)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 6)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 1)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 4)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 5)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (4, 6)
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([rid], [rname]) VALUES (1, N'Division Leader')
INSERT [dbo].[Roles] ([rid], [rname]) VALUES (2, N'Mid Manager')
INSERT [dbo].[Roles] ([rid], [rname]) VALUES (4, N'Staff')
INSERT [dbo].[Roles] ([rid], [rname]) VALUES (3, N'Team Leader')
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
INSERT [dbo].[UserRole] ([username], [rid]) VALUES (N'midmanager', 2)
INSERT [dbo].[UserRole] ([username], [rid]) VALUES (N'staff', 4)
INSERT [dbo].[UserRole] ([username], [rid]) VALUES (N'tam', 1)
INSERT [dbo].[UserRole] ([username], [rid]) VALUES (N'teamleader', 3)
GO
INSERT [dbo].[Users] ([username], [password], [displayname], [eid]) VALUES (N'midmanager', N'1', N'Mid Manager', 2)
INSERT [dbo].[Users] ([username], [password], [displayname], [eid]) VALUES (N'staff', N'1', N'Staff', 4)
INSERT [dbo].[Users] ([username], [password], [displayname], [eid]) VALUES (N'tam', N'tam', N'Tam', 1)
INSERT [dbo].[Users] ([username], [password], [displayname], [eid]) VALUES (N'teamleader', N'1', N'Team Leader', 3)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Departme__6B0C41AD52005664]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Departments] ADD UNIQUE NONCLUSTERED 
(
	[dname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__0E8FC1F0EEBDD1D7]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Employees] ADD UNIQUE NONCLUSTERED 
(
	[ename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__AB6E6164DA4E5004]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Employees] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Features__DD778417E621CB25]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Features] ADD UNIQUE NONCLUSTERED 
(
	[url] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Roles__DDD673519DEBB5E8]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED 
(
	[rname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__1D56C86C2EDFCD5C]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[displayname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Users__D9509F6CF1A917C9]    Script Date: 3/15/2025 8:51:53 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LeaveRequests] ADD  DEFAULT ('Inprogress') FOR [status]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD FOREIGN KEY([did])
REFERENCES [dbo].[Departments] ([did])
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD FOREIGN KEY([managerid])
REFERENCES [dbo].[Employees] ([eid])
GO
ALTER TABLE [dbo].[LeaveRequests]  WITH CHECK ADD FOREIGN KEY([createby])
REFERENCES [dbo].[Users] ([username])
GO
ALTER TABLE [dbo].[LeaveRequests]  WITH CHECK ADD FOREIGN KEY([owner_eid])
REFERENCES [dbo].[Employees] ([eid])
GO
ALTER TABLE [dbo].[LeaveRequests]  WITH CHECK ADD FOREIGN KEY([processedby])
REFERENCES [dbo].[Users] ([username])
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD FOREIGN KEY([fid])
REFERENCES [dbo].[Features] ([fid])
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD FOREIGN KEY([rid])
REFERENCES [dbo].[Roles] ([rid])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([rid])
REFERENCES [dbo].[Roles] ([rid])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([username])
REFERENCES [dbo].[Users] ([username])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([eid])
REFERENCES [dbo].[Employees] ([eid])
GO
USE [master]
GO
ALTER DATABASE [MyAssignment] SET  READ_WRITE 
GO
