USE [master]
GO
/****** Object:  Database [FinanceA]    Script Date: 5/10/2024 11:12:20 AM ******/
CREATE DATABASE [FinanceA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FinanceA', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FinanceA.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FinanceA_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FinanceA_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [FinanceA] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FinanceA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FinanceA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FinanceA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FinanceA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FinanceA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FinanceA] SET ARITHABORT OFF 
GO
ALTER DATABASE [FinanceA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FinanceA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FinanceA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FinanceA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FinanceA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FinanceA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FinanceA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FinanceA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FinanceA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FinanceA] SET  ENABLE_BROKER 
GO
ALTER DATABASE [FinanceA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FinanceA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FinanceA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FinanceA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FinanceA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FinanceA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FinanceA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FinanceA] SET RECOVERY FULL 
GO
ALTER DATABASE [FinanceA] SET  MULTI_USER 
GO
ALTER DATABASE [FinanceA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FinanceA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FinanceA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FinanceA] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FinanceA] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FinanceA] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'FinanceA', N'ON'
GO
ALTER DATABASE [FinanceA] SET QUERY_STORE = ON
GO
ALTER DATABASE [FinanceA] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [FinanceA]
GO
/****** Object:  Table [dbo].[Audit]    Script Date: 5/10/2024 11:12:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[Timestamp] [datetime] NULL,
	[AuditorID] [int] NOT NULL,
	[AuditType] [varchar](50) NULL,
	[AuditStatus] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Auditor]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auditor](
	[AuditorID] [int] NOT NULL,
	[Role] [varchar](50) NULL,
	[JoinedDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditorAction]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditorAction](
	[ActionID] [int] IDENTITY(1,1) NOT NULL,
	[AlertID] [int] NULL,
	[ActionDate] [date] NULL,
	[TransactionID] [int] NOT NULL,
	[AuditID] [int] NOT NULL,
	[ActionReason] [varchar](50) NULL,
	[AuditAction] [varchar](50) NULL,
	[AuditResult] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Budget]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Budget](
	[BudgetID] [int] IDENTITY(1,1) NOT NULL,
	[BudgetStatus] [varchar](20) NULL,
	[Timeframe] [varchar](50) NULL,
	[BudgetType] [varchar](50) NULL,
	[BudgetName] [varchar](50) NULL,
	[DepartmentID] [int] NOT NULL,
	[AllocatedAmount] [decimal](10, 2) NULL,
	[RemainingAmount] [decimal](10, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[BudgetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cheque]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cheque](
	[ChequeID] [int] IDENTITY(1,1) NOT NULL,
	[ChequeNumber] [varchar](50) NOT NULL,
	[BankName] [varchar](100) NOT NULL,
	[IssuerName] [varchar](100) NULL,
	[ReceiverName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ChequeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CreditCard]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditCard](
	[CreditCardID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](100) NOT NULL,
	[CardNumber] [varchar](16) NOT NULL,
	[ExpiryDate] [date] NOT NULL,
	[CVV] [varchar](3) NOT NULL,
	[TransactionReference] [varchar](100) NULL,
	[CardHolderName] [varchar](100) NULL,
	[ReceiverName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CreditCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [varchar](255) NULL,
	[TotalAmount] [decimal](10, 2) NULL,
	[LastTransactionDate] [date] NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FraudAlerts]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FraudAlerts](
	[AlertID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionID] [int] NULL,
	[AlertDate] [date] NULL,
	[AlertReason] [varchar](255) NULL,
	[AuditID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InstallmentPlan]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstallmentPlan](
	[InstallmentPlanID] [int] IDENTITY(1,1) NOT NULL,
	[PartnerID] [int] NULL,
	[MerchantID] [int] NULL,
	[MaxInstallments] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InstallmentPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Installments]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Installments](
	[InstallmentID] [int] IDENTITY(1,1) NOT NULL,
	[InstallmentPlanID] [int] NOT NULL,
	[TransactionID] [int] NULL,
	[InstallmentNumber] [int] NOT NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[PaidAmount] [decimal](10, 2) NULL,
	[DueDate] [date] NOT NULL,
	[PaymentStatus] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InstallmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[InvoiceID] [int] NOT NULL,
	[Amount] [decimal](10, 2) NULL,
	[Date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Merchant]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Merchant](
	[MerchantID] [int] NOT NULL,
	[MerchantStatus] [varchar](50) NULL,
	[MerchantType] [varchar](50) NULL,
	[LastTransactionDate] [date] NULL,
	[PartnerID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MerchantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Onlines]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Onlines](
	[OnlineID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](100) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[TransactionReference] [varchar](100) NULL,
	[SenderName] [varchar](100) NULL,
	[ReceiverName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[OnlineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partner](
	[PartnerID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[TotalInvestment] [int] NULL,
	[WithdrawalThreshold] [int] NULL,
	[Role] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PartnerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentMethod]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethod](
	[PaymentMethodID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentType] [varchar](50) NOT NULL,
	[CreditCardID] [int] NULL,
	[ChequeID] [int] NULL,
	[OnlineID] [int] NULL,
	[PartnerID] [int] NULL,
	[MerchantID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Gender] [varchar](10) NULL,
	[Contact] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionType] [varchar](50) NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
	[Date] [date] NOT NULL,
	[PaymentMethodID] [int] NOT NULL,
	[InstallmentPlanID] [int] NULL,
	[BudgetID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCredentials]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCredentials](
	[CredentialID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [nvarchar](64) NOT NULL,
	[PersonID] [int] NOT NULL,
	[LastLoginDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[CredentialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Audit] ON 

INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (1, CAST(N'2024-05-10T10:50:28.907' AS DateTime), 6, N'Internal ', N'complete')
INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (2, CAST(N'2024-05-10T10:50:28.907' AS DateTime), 6, N'Internal ', N'Undergoing')
INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (3, CAST(N'2024-05-10T10:53:37.440' AS DateTime), 6, N'Internal ', N'complete')
INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (4, CAST(N'2024-05-10T10:53:37.440' AS DateTime), 6, N'Internal ', N'Undergoing')
INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (5, CAST(N'2024-05-10T10:54:49.633' AS DateTime), 6, N'Internal ', N'complete')
INSERT [dbo].[Audit] ([AuditID], [Timestamp], [AuditorID], [AuditType], [AuditStatus]) VALUES (6, CAST(N'2024-05-10T10:54:49.633' AS DateTime), 6, N'Internal ', N'Undergoing')
SET IDENTITY_INSERT [dbo].[Audit] OFF
GO
INSERT [dbo].[Auditor] ([AuditorID], [Role], [JoinedDate]) VALUES (6, N'Lead Auditor', CAST(N'2024-10-17' AS Date))
INSERT [dbo].[Auditor] ([AuditorID], [Role], [JoinedDate]) VALUES (7, N'Junior Auditor', CAST(N'2020-02-17' AS Date))
INSERT [dbo].[Auditor] ([AuditorID], [Role], [JoinedDate]) VALUES (8, N'Senior Auditor', CAST(N'2023-04-03' AS Date))
GO
SET IDENTITY_INSERT [dbo].[AuditorAction] ON 

INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (1, 1, CAST(N'2024-05-10' AS Date), 75, 1, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (2, NULL, CAST(N'2024-05-10' AS Date), 81, 1, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (3, NULL, CAST(N'2024-05-10' AS Date), 82, 1, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (4, 2, CAST(N'2024-05-10' AS Date), 83, 1, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (5, NULL, CAST(N'2024-05-10' AS Date), 88, 1, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (6, NULL, CAST(N'2024-05-10' AS Date), 90, 1, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (7, NULL, CAST(N'2024-05-10' AS Date), 92, 1, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (8, 3, CAST(N'2024-05-10' AS Date), 95, 1, N'High Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (9, NULL, CAST(N'2024-05-10' AS Date), 69, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (10, 4, CAST(N'2024-05-10' AS Date), 71, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (11, 5, CAST(N'2024-05-10' AS Date), 79, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (12, NULL, CAST(N'2024-05-10' AS Date), 84, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (13, NULL, CAST(N'2024-05-10' AS Date), 85, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (14, NULL, CAST(N'2024-05-10' AS Date), 86, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (15, 6, CAST(N'2024-05-10' AS Date), 87, 3, N'High Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (16, NULL, CAST(N'2024-05-10' AS Date), 94, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (17, NULL, CAST(N'2024-05-10' AS Date), 72, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (18, NULL, CAST(N'2024-05-10' AS Date), 76, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (19, 7, CAST(N'2024-05-10' AS Date), 77, 3, N'Anomaly', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (20, NULL, CAST(N'2024-05-10' AS Date), 78, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (21, 8, CAST(N'2024-05-10' AS Date), 80, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (22, NULL, CAST(N'2024-05-10' AS Date), 89, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (23, NULL, CAST(N'2024-05-10' AS Date), 91, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (24, NULL, CAST(N'2024-05-10' AS Date), 96, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (25, NULL, CAST(N'2024-05-10' AS Date), 69, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (26, NULL, CAST(N'2024-05-10' AS Date), 71, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (27, 9, CAST(N'2024-05-10' AS Date), 76, 3, N'High Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (28, NULL, CAST(N'2024-05-10' AS Date), 77, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (29, 10, CAST(N'2024-05-10' AS Date), 78, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (30, NULL, CAST(N'2024-05-10' AS Date), 79, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (31, NULL, CAST(N'2024-05-10' AS Date), 83, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (32, NULL, CAST(N'2024-05-10' AS Date), 84, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (33, 11, CAST(N'2024-05-10' AS Date), 86, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (34, 12, CAST(N'2024-05-10' AS Date), 87, 3, N'Moderate Risk Fraud', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (35, NULL, CAST(N'2024-05-10' AS Date), 88, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (36, NULL, CAST(N'2024-05-10' AS Date), 96, 3, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (37, NULL, CAST(N'2024-05-10' AS Date), 69, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (38, NULL, CAST(N'2024-05-10' AS Date), 71, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (39, NULL, CAST(N'2024-05-10' AS Date), 72, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (40, NULL, CAST(N'2024-05-10' AS Date), 75, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (41, NULL, CAST(N'2024-05-10' AS Date), 76, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (42, NULL, CAST(N'2024-05-10' AS Date), 77, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (43, 13, CAST(N'2024-05-10' AS Date), 78, 5, N'Anomaly', N'Not fair', N'Qualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (44, NULL, CAST(N'2024-05-10' AS Date), 79, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (45, NULL, CAST(N'2024-05-10' AS Date), 80, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (46, NULL, CAST(N'2024-05-10' AS Date), 81, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (47, NULL, CAST(N'2024-05-10' AS Date), 82, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (48, NULL, CAST(N'2024-05-10' AS Date), 83, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (49, NULL, CAST(N'2024-05-10' AS Date), 84, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (50, NULL, CAST(N'2024-05-10' AS Date), 85, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (51, NULL, CAST(N'2024-05-10' AS Date), 86, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (52, NULL, CAST(N'2024-05-10' AS Date), 87, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (53, NULL, CAST(N'2024-05-10' AS Date), 88, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (54, NULL, CAST(N'2024-05-10' AS Date), 89, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (55, NULL, CAST(N'2024-05-10' AS Date), 90, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (56, NULL, CAST(N'2024-05-10' AS Date), 91, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (57, NULL, CAST(N'2024-05-10' AS Date), 92, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (58, NULL, CAST(N'2024-05-10' AS Date), 94, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (59, NULL, CAST(N'2024-05-10' AS Date), 95, 5, N'Normal', N'True and fair', N'Unqualified')
INSERT [dbo].[AuditorAction] ([ActionID], [AlertID], [ActionDate], [TransactionID], [AuditID], [ActionReason], [AuditAction], [AuditResult]) VALUES (60, NULL, CAST(N'2024-05-10' AS Date), 96, 5, N'Normal', N'True and fair', N'Unqualified')
SET IDENTITY_INSERT [dbo].[AuditorAction] OFF
GO
SET IDENTITY_INSERT [dbo].[Budget] ON 

INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (1, N'Active', N'Q1 2024', N'Office', N'Operations', 2, CAST(72200.00 AS Decimal(10, 2)), CAST(47470.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (2, N'Active', N'Q2 2024', N'External', N'Marketing', 2, CAST(381110.00 AS Decimal(10, 2)), CAST(339756.3000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (3, N'Inactive', N'Q3 2024', N'Office', N'Research', 2, CAST(549590.00 AS Decimal(10, 2)), CAST(506224.4000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (4, N'Active', N'Q4 2024', N'External', N'Development', 2, CAST(420000.00 AS Decimal(10, 2)), CAST(350956.4000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (5, N'Active', N'Q1 2024', N'Office', N'HR', 2, CAST(84260.00 AS Decimal(10, 2)), CAST(44204.5000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (6, N'Active', N'Q2 2024', N'Office', N'Finance', 2, CAST(900000.00 AS Decimal(10, 2)), CAST(887600.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (7, N'Active', N'Q3 2024', N'External', N'IT', 2, CAST(187303.10 AS Decimal(10, 2)), CAST(-114907.2000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (8, N'Inactive', N'Q4 2024', N'Office', N'Customer Care', 2, CAST(376304.00 AS Decimal(10, 2)), CAST(376304.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (9, N'Active', N'Q1 2024', N'External', N'Sales', 1, CAST(237907.00 AS Decimal(10, 2)), CAST(237907.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (10, N'Active', N'Q2 2024', N'Office', N'Procurement', 3, CAST(419100.00 AS Decimal(10, 2)), CAST(403031.8000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (11, N'Active', N'Q3 2024', N'Office', N'Marketing', 1, CAST(817162.30 AS Decimal(10, 2)), CAST(728687.1000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (12, N'Active', N'Q4 2024', N'External', N'Research', 1, CAST(120000.00 AS Decimal(10, 2)), CAST(79500.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (13, N'Inactive', N'Q1 2024', N'Office', N'HR', 2, CAST(111317.00 AS Decimal(10, 2)), CAST(73449.6000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (14, N'Active', N'Q2 2024', N'External', N'Legal', 1, CAST(234340.00 AS Decimal(10, 2)), CAST(234340.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (15, N'Active', N'Q3 2024', N'Office', N'Operations', 1, CAST(149799.60 AS Decimal(10, 2)), CAST(25472.5000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (16, N'Active', N'Q4 2024', N'Office', N'Sales', 1, CAST(531645.20 AS Decimal(10, 2)), CAST(363487.4000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (17, N'Active', N'Q1 2024', N'Office', N'Revenue', 2, CAST(293240.70 AS Decimal(10, 2)), CAST(197795.9000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (18, N'Active', N'Q2 2024', N'External', N'Grants', 1, CAST(111594.40 AS Decimal(10, 2)), CAST(79636.8000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (19, N'Active', N'Q3 2024', N'External', N'Investments', 1, CAST(13123.00 AS Decimal(10, 2)), CAST(32416.2000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (20, N'Active', N'Q4 2024', N'Office', N'Donations', 3, CAST(150000.00 AS Decimal(10, 2)), CAST(119142.5000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (21, N'Active', N'FY 2024', N'Office', N'Sponsorships', 1, CAST(75000.00 AS Decimal(10, 2)), CAST(54485.2000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (22, N'Active', N'Q2 2025', N'External', N'Fundraising', 1, CAST(850000.00 AS Decimal(10, 2)), CAST(815996.4000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (23, N'Active', N'Q3 2025', N'Office', N'Grants', 1, CAST(32423.00 AS Decimal(10, 2)), CAST(32423.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (24, N'Active', N'Q4 2025', N'External', N'Endowments', 1, CAST(122969.40 AS Decimal(10, 2)), CAST(90636.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (25, N'Active', N'Q1 2026', N'Office', N'Investments', 2, CAST(231299.90 AS Decimal(10, 2)), CAST(156555.9000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (26, N'Active', N'Q1 2024', N'External', N'Operations', 2, CAST(38314.80 AS Decimal(10, 2)), CAST(-81585.9000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (27, N'Active', N'Q2 2024', N'External', N'Marketing', 3, CAST(40130.00 AS Decimal(10, 2)), CAST(41182.6000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (28, N'Active', N'Q3 2024', N'External', N'Research', 1, CAST(450000.00 AS Decimal(10, 2)), CAST(450000.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (29, N'Active', N'Q4 2024', N'External', N'Development', 2, CAST(450000.00 AS Decimal(10, 2)), CAST(387560.3000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (30, N'Active', N'Q1 2024', N'External', N'HR', 3, CAST(124630.00 AS Decimal(10, 2)), CAST(100873.4000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (31, N'Active', N'Q2 2024', N'Office', N'Finance', 2, CAST(200000.00 AS Decimal(10, 2)), CAST(104980.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (32, N'Active', N'Q3 2024', N'External', N'IT', 2, CAST(230000.00 AS Decimal(10, 2)), CAST(-613501.8000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (33, N'Active', N'Q4 2024', N'Office', N'Customer Care', 2, CAST(450000.00 AS Decimal(10, 2)), CAST(389762.5000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (34, N'Active', N'Q3 2024', N'External', N'Sales', 1, CAST(560000.00 AS Decimal(10, 2)), CAST(195475.2000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (35, N'Active', N'Q4 2024', N'External', N'Procurement', 1, CAST(780000.00 AS Decimal(10, 2)), CAST(635804.1000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (36, N'Active', N'Q1 2024', N'Office', N'Marketing', 2, CAST(340000.00 AS Decimal(10, 2)), CAST(223177.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (37, N'Active', N'Q2 2024', N'External', N'Research', 3, CAST(230000.00 AS Decimal(10, 2)), CAST(183200.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (38, N'Active', N'Q3 2024', N'Office', N'Sponsorships', 1, CAST(453567.00 AS Decimal(10, 2)), CAST(362318.0000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (39, N'Active', N'Q4 2024', N'External', N'Fundraising', 3, CAST(935762.50 AS Decimal(10, 2)), CAST(762486.5000 AS Decimal(10, 4)))
INSERT [dbo].[Budget] ([BudgetID], [BudgetStatus], [Timeframe], [BudgetType], [BudgetName], [DepartmentID], [AllocatedAmount], [RemainingAmount]) VALUES (40, N'Active', N'FY 2024', N'External', N'Grants', 2, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.0000 AS Decimal(10, 4)))
SET IDENTITY_INSERT [dbo].[Budget] OFF
GO
SET IDENTITY_INSERT [dbo].[Cheque] ON 

INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (1, N'0271713796', N'Askari Bank', N'Mitchell', N'Kevin')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (2, N'4600097109', N'Bank Alfalah', N'Gregory', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (3, N'4275921796', N'HBL', N'Erica', N'Lisa')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (4, N'8864861164', N'Askari Bank', N'Rodney', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (5, N'4424477846', N'Askari Bank', N'Tyler', N'Lisa')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (6, N'0418921302', N'UBL', N'Amber', N'Lisa ')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (7, N'0323309937', N'Bank Alfalah', N'Cory', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (8, N'9990738212', N'Bank Alfalah', N'Ryan', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (9, N'2605147971', N'HBL', N'Dana', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (10, N'4116149309', N'Askari Bank', N'Dana', N'Lisa')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (11, N'8912981095', N'UBL', N'Ebony', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (12, N'1370448229', N'Bank Alfalah', N'Gregory', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (13, N'0790871831', N'Bank Alfalah', N'Tommy', N'Kevin')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (14, N'5634441736', N'Faysal Bank', N'Ryan', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (15, N'1810820665', N'Bank Alfalah', N'Rodney', N'Kevin')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (16, N'0328146174', N'MCB Bank', N'Ebony', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (17, N'8406640855', N'Bank Alfalah', N'Dana', N'Patricia')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (18, N'5025920532', N'Bank Alfalah', N'Dana', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (19, N'4522186287', N'Bank Al Habib', N'Maria', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (20, N'0358186823', N'MCB Bank', N'Erica', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (21, N'9532144812', N'Bank Alfalah', N'Erica', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (22, N'6684109165', N'UBL', N'Erica', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (23, N'9885473549', N'Askari Bank', N'Steven', N'Kevin')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (24, N'6114984591', N'Bank Al Habib', N'Amber', N'Nancy')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (25, N'6975244560', N'Bank Al Habib', N'Tyler', N'Kevin')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (26, N'7137547218', N'Bank Al Habib', N'Dana', N'Anthony')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (27, N'0200538413', N'Askari Bank', N'Rodney', N'Nancy')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (28, N'4310375273', N'Faysal Bank', N'Rodney', N'Lisa')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (29, N'3975895595', N'Askari Bank', N'Ryan', N'Nancy')
INSERT [dbo].[Cheque] ([ChequeID], [ChequeNumber], [BankName], [IssuerName], [ReceiverName]) VALUES (30, N'1919013040', N'Bank Alfalah', N'Dana', N'Anthony')
SET IDENTITY_INSERT [dbo].[Cheque] OFF
GO
SET IDENTITY_INSERT [dbo].[CreditCard] ON 

INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (1, N'Faysal Bank', N'4221628670503220', CAST(N'2026-02-05' AS Date), N'286', N'38BF53E0-DFE6-4BB3-', N'Mitchell', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (2, N'UBL', N'4270335519412090', CAST(N'2027-06-23' AS Date), N'924', N'5043D345-7712-44B4-', N'Amber', N'Patricia')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (3, N'Bank Alfalah', N'4375518978845002', CAST(N'2026-08-31' AS Date), N'697', N'89EA46D9-2057-47B5-', N'Erica', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (4, N'MCB Bank', N'4416062078107785', CAST(N'2026-08-06' AS Date), N'387', N'C41126C1-FEA1-4258-', N'Rodney', N'Rodney')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (5, N'Bank Al Habib', N'4199916835691460', CAST(N'2027-11-13' AS Date), N'798', N'E1BEE429-365F-48E2-', N'Tyler', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (6, N'Bank Al Habib', N'4868078278158577', CAST(N'2029-04-04' AS Date), N'307', N'6DB8D073-7F0B-4A8E-', N'Amber', N'Lisa ')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (7, N'Bank Alfalah', N'4866741441728973', CAST(N'2028-06-19' AS Date), N'029', N'18636A33-DB2F-46BA-', N'Cory', N'Patricia')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (8, N'HBL', N'4095851317083890', CAST(N'2026-06-24' AS Date), N'744', N'2338469B-CA97-454D-', N'Ryan', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (9, N'MCB Bank', N'4174681876891379', CAST(N'2028-04-09' AS Date), N'594', N'63EB61A0-A666-4D4D-', N'Ebony', N'Nancy')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (10, N'HBL', N'4101295398803161', CAST(N'2027-04-21' AS Date), N'139', N'CB00C308-5604-4152-', N'Dana', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (11, N'HBL', N'4495995936792098', CAST(N'2024-07-28' AS Date), N'117', N'B6BABF45-1082-4F47-', N'Erica', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (12, N'Bank Al Habib', N'4827194133293027', CAST(N'2028-09-06' AS Date), N'114', N'1699EC20-6670-42C5-', N'Ebony', N'Patricia')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (13, N'Askari Bank', N'4686282237263257', CAST(N'2026-08-31' AS Date), N'099', N'33D37151-6E4D-40A1-', N'Tommy', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (14, N'Bank Al Habib', N'4997918365156355', CAST(N'2028-05-09' AS Date), N'543', N'D8F00C53-AF59-483F-', N'Steven', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (15, N'UBL', N'4113976925239042', CAST(N'2025-06-22' AS Date), N'526', N'4BE26BB1-9FE2-4FA5-', N'Rodney', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (16, N'MCB Bank', N'4251003667054375', CAST(N'2029-03-11' AS Date), N'075', N'C86190C5-3E86-46D3-', N'Ebony', N'Patricia')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (17, N'Bank Alfalah', N'4954724609082343', CAST(N'2024-12-27' AS Date), N'687', N'6283431F-E371-4EF1-', N'Marilyn', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (18, N'Faysal Bank', N'4883185288236510', CAST(N'2025-06-26' AS Date), N'449', N'19A6A5AA-7327-43B5-', N'Dana', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (19, N'MCB Bank', N'4173251229785537', CAST(N'2027-10-26' AS Date), N'229', N'2F73D7BA-5DE4-4064-', N'Maria', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (20, N'MCB Bank', N'4274047971921972', CAST(N'2028-07-21' AS Date), N'537', N'7A714025-F162-4F71-', N'Ryan', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (21, N'Faysal Bank', N'4531651951132217', CAST(N'2026-07-30' AS Date), N'743', N'0487EC5F-930C-4143-', N'Ebony', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (22, N'UBL', N'4030999139592615', CAST(N'2028-04-06' AS Date), N'300', N'F30B6DCF-0C45-4CFC-', N'Erica', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (23, N'Faysal Bank', N'4745402650576790', CAST(N'2029-04-24' AS Date), N'282', N'D8F550A6-683F-4996-', N'Steven', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (24, N'UBL', N'4188783174477496', CAST(N'2024-09-18' AS Date), N'009', N'15A31E12-AF96-47BD-', N'Amber', N'Nancy')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (25, N'UBL', N'4970836708153592', CAST(N'2029-03-22' AS Date), N'941', N'949EDEAC-7027-4077-', N'Cassandra', N'Anthony')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (26, N'MCB Bank', N'4707742401751875', CAST(N'2027-11-29' AS Date), N'603', N'808DB062-1A34-4A68-', N'Tyler', N'Kevin')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (27, N'MCB Bank', N'4037171168099437', CAST(N'2027-05-27' AS Date), N'756', N'6120455B-3B93-4050-', N'Rodney', N'Nancy')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (28, N'Bank Alfalah', N'4805475044348351', CAST(N'2028-01-24' AS Date), N'881', N'8096B168-2F3D-4E31-', N'Rodney', N'Lisa')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (29, N'Bank Alfalah', N'4979909699813732', CAST(N'2026-08-23' AS Date), N'551', N'18FE4106-38E7-4728-', N'Ryan', N'Nancy')
INSERT [dbo].[CreditCard] ([CreditCardID], [BankName], [CardNumber], [ExpiryDate], [CVV], [TransactionReference], [CardHolderName], [ReceiverName]) VALUES (30, N'Askari Bank', N'4944122835049018', CAST(N'2028-05-10' AS Date), N'256', N'79BD5FA3-4928-4078-', N'Dana', N'Anthony')
SET IDENTITY_INSERT [dbo].[CreditCard] OFF
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [TotalAmount], [LastTransactionDate], [UpdatedDate]) VALUES (1, N'Accounting', CAST(73843625.40 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), CAST(N'2024-05-10T10:41:35.370' AS DateTime))
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [TotalAmount], [LastTransactionDate], [UpdatedDate]) VALUES (2, N'Finance', CAST(8646181.40 AS Decimal(10, 2)), CAST(N'2024-04-22' AS Date), CAST(N'2024-05-10T10:41:35.420' AS DateTime))
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [TotalAmount], [LastTransactionDate], [UpdatedDate]) VALUES (3, N'Marketing', CAST(90525174.10 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), CAST(N'2024-05-10T10:41:36.453' AS DateTime))
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[FraudAlerts] ON 

INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (1, 75, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 1)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (2, 83, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 1)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (3, 95, CAST(N'2024-05-10' AS Date), N'High Risk Fraud', 1)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (4, 71, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (5, 79, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (6, 87, CAST(N'2024-05-10' AS Date), N'High Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (7, 77, CAST(N'2024-05-10' AS Date), N'Anomaly', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (8, 80, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (9, 76, CAST(N'2024-05-10' AS Date), N'High Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (10, 78, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (11, 86, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (12, 87, CAST(N'2024-05-10' AS Date), N'Moderate Risk Fraud', 3)
INSERT [dbo].[FraudAlerts] ([AlertID], [TransactionID], [AlertDate], [AlertReason], [AuditID]) VALUES (13, 78, CAST(N'2024-05-10' AS Date), N'Anomaly', 5)
SET IDENTITY_INSERT [dbo].[FraudAlerts] OFF
GO
SET IDENTITY_INSERT [dbo].[InstallmentPlan] ON 

INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (1, 5, 32, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (2, 3, 13, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (3, 3, 14, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (4, 1, 25, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (5, 2, 17, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (6, 1, 21, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (7, 3, 34, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (8, 4, 32, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (9, 5, 32, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (10, 3, 12, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (11, 2, 38, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (12, 5, 12, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (13, 1, 12, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (14, 4, 17, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (15, 2, 25, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (16, 2, 25, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (17, 2, 36, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (18, 4, 29, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (19, 5, 31, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (20, 3, 32, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (21, 4, 36, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (22, 4, 34, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (23, 2, 38, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (24, 5, 34, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (25, 3, 24, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (26, 5, 34, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (27, 1, 25, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (28, 5, 29, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (29, 5, 29, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (30, 5, 19, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (31, 1, 18, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (32, 2, 30, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (33, 2, 12, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (34, 3, 33, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (35, 2, 10, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (36, 3, 36, 3)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (37, 2, 13, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (38, 2, 26, 2)
INSERT [dbo].[InstallmentPlan] ([InstallmentPlanID], [PartnerID], [MerchantID], [MaxInstallments]) VALUES (39, 2, 25, 2)
SET IDENTITY_INSERT [dbo].[InstallmentPlan] OFF
GO
SET IDENTITY_INSERT [dbo].[Installments] ON 

INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (1, 12, 3, 1, CAST(39277.50 AS Decimal(10, 2)), CAST(36082.50 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (2, 1, 9, 1, CAST(101769.00 AS Decimal(10, 2)), CAST(20130.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (3, 33, 10, 1, CAST(146223.00 AS Decimal(10, 2)), CAST(48410.10 AS Decimal(10, 2)), CAST(N'2024-03-09' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (4, 26, 15, 1, CAST(248437.00 AS Decimal(10, 2)), CAST(27996.70 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (5, 10, 16, 1, CAST(110560.00 AS Decimal(10, 2)), CAST(17590.00 AS Decimal(10, 2)), CAST(N'2024-02-17' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (6, 33, 19, 2, CAST(146223.00 AS Decimal(10, 2)), CAST(32333.40 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (7, 21, 20, 1, CAST(54172.00 AS Decimal(10, 2)), CAST(46800.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (8, 1, 24, 2, CAST(101769.00 AS Decimal(10, 2)), CAST(42440.00 AS Decimal(10, 2)), CAST(N'2024-03-06' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (9, 39, 26, 1, CAST(49137.00 AS Decimal(10, 2)), CAST(33069.90 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (10, 37, 27, 1, CAST(109436.00 AS Decimal(10, 2)), CAST(20024.00 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (11, 2, 29, 1, CAST(121108.00 AS Decimal(10, 2)), CAST(30378.20 AS Decimal(10, 2)), CAST(N'2024-02-25' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (12, 2, 32, 2, CAST(121108.00 AS Decimal(10, 2)), CAST(90730.20 AS Decimal(10, 2)), CAST(N'2024-02-25' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (13, 18, 35, 1, CAST(57174.00 AS Decimal(10, 2)), CAST(39850.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (14, 15, 36, 1, CAST(99213.00 AS Decimal(10, 2)), CAST(29220.00 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (15, 5, 37, 1, CAST(96207.00 AS Decimal(10, 2)), CAST(48374.80 AS Decimal(10, 2)), CAST(N'2024-03-24' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (16, 3, 38, 1, CAST(135008.00 AS Decimal(10, 2)), CAST(37903.00 AS Decimal(10, 2)), CAST(N'2024-03-09' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (17, 29, 40, 1, CAST(233021.00 AS Decimal(10, 2)), CAST(97303.10 AS Decimal(10, 2)), CAST(N'2024-03-13' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (18, 11, 41, 1, CAST(132520.00 AS Decimal(10, 2)), CAST(87008.90 AS Decimal(10, 2)), CAST(N'2024-03-20' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (19, 12, 46, 2, CAST(39277.50 AS Decimal(10, 2)), CAST(31957.60 AS Decimal(10, 2)), CAST(N'2024-03-23' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (20, 39, 47, 2, CAST(49137.00 AS Decimal(10, 2)), CAST(16068.20 AS Decimal(10, 2)), CAST(N'2024-03-29' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (21, 7, 48, 1, CAST(52166.00 AS Decimal(10, 2)), CAST(29215.60 AS Decimal(10, 2)), CAST(N'2024-03-19' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (22, 24, 50, 1, CAST(91295.00 AS Decimal(10, 2)), CAST(12969.40 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (23, 13, 51, 1, CAST(99176.00 AS Decimal(10, 2)), CAST(19200.00 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (24, 10, 54, 2, CAST(110560.00 AS Decimal(10, 2)), CAST(41353.70 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (25, 16, 61, 1, CAST(101537.00 AS Decimal(10, 2)), CAST(13567.00 AS Decimal(10, 2)), CAST(N'2024-03-25' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (26, 1, 62, 3, CAST(101769.00 AS Decimal(10, 2)), CAST(39199.80 AS Decimal(10, 2)), CAST(N'2024-04-21' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (27, 22, 65, 1, CAST(106060.00 AS Decimal(10, 2)), CAST(13982.30 AS Decimal(10, 2)), CAST(N'2024-03-29' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (28, 18, 66, 2, CAST(57174.00 AS Decimal(10, 2)), CAST(16815.20 AS Decimal(10, 2)), CAST(N'2024-04-07' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (29, 7, 69, 2, CAST(52166.00 AS Decimal(10, 2)), CAST(22955.10 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (30, 28, 71, 1, CAST(84095.00 AS Decimal(10, 2)), CAST(83502.30 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (31, 20, 76, 1, CAST(316540.00 AS Decimal(10, 2)), CAST(25732.30 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (32, 9, 77, 1, CAST(82051.00 AS Decimal(10, 2)), CAST(257320.30 AS Decimal(10, 2)), CAST(N'2024-04-07' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (33, 29, 78, 2, CAST(233021.00 AS Decimal(10, 2)), CAST(40213.50 AS Decimal(10, 2)), CAST(N'2024-04-14' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (34, 34, 79, 1, CAST(141541.00 AS Decimal(10, 2)), CAST(10296.60 AS Decimal(10, 2)), CAST(N'2024-04-13' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (35, 32, 83, 1, CAST(50000.00 AS Decimal(10, 2)), CAST(12400.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (36, 14, 84, 1, CAST(100704.00 AS Decimal(10, 2)), CAST(33676.80 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (37, 26, 86, 2, CAST(248437.00 AS Decimal(10, 2)), CAST(22044.10 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (38, 29, 87, 1, CAST(233021.00 AS Decimal(10, 2)), CAST(95505.10 AS Decimal(10, 2)), CAST(N'2024-04-23' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (39, 3, 88, 2, CAST(135008.00 AS Decimal(10, 2)), CAST(28186.00 AS Decimal(10, 2)), CAST(N'2024-05-02' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (40, 33, 96, 3, CAST(146223.00 AS Decimal(10, 2)), CAST(65480.60 AS Decimal(10, 2)), CAST(N'2024-04-27' AS Date), N'Paid')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (41, 34, NULL, 2, CAST(141541.00 AS Decimal(10, 2)), CAST(131245.00 AS Decimal(10, 2)), CAST(N'2024-05-01' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (42, 13, NULL, 1, CAST(99176.00 AS Decimal(10, 2)), CAST(99176.00 AS Decimal(10, 2)), CAST(N'2024-05-02' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (43, 27, NULL, 1, CAST(967000.00 AS Decimal(10, 2)), CAST(967000.00 AS Decimal(10, 2)), CAST(N'2024-05-03' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (44, 37, NULL, 2, CAST(109436.00 AS Decimal(10, 2)), CAST(89412.00 AS Decimal(10, 2)), CAST(N'2024-05-04' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (45, 16, NULL, 2, CAST(101537.00 AS Decimal(10, 2)), CAST(87970.00 AS Decimal(10, 2)), CAST(N'2024-05-05' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (46, 30, NULL, 1, CAST(714029.00 AS Decimal(10, 2)), CAST(714029.00 AS Decimal(10, 2)), CAST(N'2024-05-09' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (47, 8, NULL, 1, CAST(349870.00 AS Decimal(10, 2)), CAST(349870.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), N'Pending')
INSERT [dbo].[Installments] ([InstallmentID], [InstallmentPlanID], [TransactionID], [InstallmentNumber], [TotalAmount], [PaidAmount], [DueDate], [PaymentStatus]) VALUES (48, 19, NULL, 1, CAST(58028.00 AS Decimal(10, 2)), CAST(58028.00 AS Decimal(10, 2)), CAST(N'2024-05-12' AS Date), N'Pending')
SET IDENTITY_INSERT [dbo].[Installments] OFF
GO
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (1, CAST(284714.00 AS Decimal(10, 2)), CAST(N'2024-01-01' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (3, CAST(36082.50 AS Decimal(10, 2)), CAST(N'2024-01-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (4, CAST(40070.00 AS Decimal(10, 2)), CAST(N'2024-01-29' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (5, CAST(34003.60 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (6, CAST(40400.00 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (7, CAST(1594.40 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (8, CAST(15694.40 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (9, CAST(20130.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (10, CAST(4810.10 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (11, CAST(18546.50 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (12, CAST(12490.60 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (13, CAST(32061.50 AS Decimal(10, 2)), CAST(N'2024-02-04' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (14, CAST(24630.00 AS Decimal(10, 2)), CAST(N'2024-02-05' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (15, CAST(27996.70 AS Decimal(10, 2)), CAST(N'2024-02-05' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (16, CAST(17590.00 AS Decimal(10, 2)), CAST(N'2024-02-06' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (17, CAST(44890.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (18, CAST(20514.80 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (19, CAST(32333.40 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (20, CAST(46800.00 AS Decimal(10, 2)), CAST(N'2024-02-08' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (21, CAST(31110.00 AS Decimal(10, 2)), CAST(N'2024-02-09' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (22, CAST(90650.30 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (23, CAST(54180.30 AS Decimal(10, 2)), CAST(N'2024-02-14' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (24, CAST(42440.00 AS Decimal(10, 2)), CAST(N'2024-02-15' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (25, CAST(35762.50 AS Decimal(10, 2)), CAST(N'2024-02-15' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (26, CAST(33069.90 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (27, CAST(20024.00 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (28, CAST(37867.40 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (29, CAST(30378.20 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (30, CAST(26304.00 AS Decimal(10, 2)), CAST(N'2024-02-20' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (31, CAST(13460.00 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (32, CAST(90730.20 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (33, CAST(31645.20 AS Decimal(10, 2)), CAST(N'2024-02-26' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (34, CAST(35925.60 AS Decimal(10, 2)), CAST(N'2024-02-26' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (35, CAST(39850.00 AS Decimal(10, 2)), CAST(N'2024-02-27' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (36, CAST(29220.00 AS Decimal(10, 2)), CAST(N'2024-02-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (37, CAST(48374.80 AS Decimal(10, 2)), CAST(N'2024-03-01' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (38, CAST(37903.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (39, CAST(12790.30 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (40, CAST(97303.10 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (41, CAST(87008.90 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (42, CAST(14330.20 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (43, CAST(804302.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (44, CAST(36620.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (45, CAST(27870.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (46, CAST(31957.60 AS Decimal(10, 2)), CAST(N'2024-03-06' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (47, CAST(16068.20 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (48, CAST(29215.60 AS Decimal(10, 2)), CAST(N'2024-03-08' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (49, CAST(40055.50 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (50, CAST(12969.40 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (51, CAST(19200.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (52, CAST(95020.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (53, CAST(16352.20 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (54, CAST(41353.70 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (55, CAST(15215.20 AS Decimal(10, 2)), CAST(N'2024-03-17' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (56, CAST(4260.00 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (57, CAST(14150.00 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (58, CAST(27200.00 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (59, CAST(6114.80 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (60, CAST(13150.00 AS Decimal(10, 2)), CAST(N'2024-03-24' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (61, CAST(13567.00 AS Decimal(10, 2)), CAST(N'2024-03-25' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (62, CAST(39199.80 AS Decimal(10, 2)), CAST(N'2024-03-26' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (63, CAST(40500.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (64, CAST(13982.30 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (65, CAST(13982.30 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (66, CAST(16815.20 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (67, CAST(49584.90 AS Decimal(10, 2)), CAST(N'2024-03-29' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (68, CAST(3180.00 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (69, CAST(22955.10 AS Decimal(10, 2)), CAST(N'2024-04-02' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (71, CAST(83502.30 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (72, CAST(37907.00 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (75, CAST(16317.00 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (76, CAST(25732.30 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (77, CAST(257320.30 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (78, CAST(4023.50 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (79, CAST(10296.60 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (80, CAST(79500.70 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (81, CAST(38850.00 AS Decimal(10, 2)), CAST(N'2024-04-15' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (82, CAST(33118.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (83, CAST(12400.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (84, CAST(33676.80 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (85, CAST(46747.30 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (86, CAST(22044.10 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (87, CAST(95505.10 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (88, CAST(28186.00 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (89, CAST(30857.50 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (90, CAST(79820.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (91, CAST(49067.30 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (92, CAST(24291.00 AS Decimal(10, 2)), CAST(N'2024-04-22' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (94, CAST(45539.20 AS Decimal(10, 2)), CAST(N'2024-04-23' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (95, CAST(185100.00 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date))
INSERT [dbo].[Invoice] ([InvoiceID], [Amount], [Date]) VALUES (96, CAST(65480.60 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date))
GO
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (9, N'Active', N'Purchase', CAST(N'2024-04-06' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (10, N'Active', N'Purchase', CAST(N'2024-04-10' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (11, N'Active', N'Sale', CAST(N'2024-04-14' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (12, N'Active', N'Sale', CAST(N'2024-04-24' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (13, N'Active', N'Purchase', CAST(N'2024-02-26' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (14, N'Active', N'Sale', CAST(N'2024-04-09' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (15, N'Active', N'Sale', CAST(N'2024-02-22' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (16, N'Active', N'Sale', CAST(N'2024-04-16' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (17, N'Active', N'Purchase', CAST(N'2024-04-19' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (18, N'Active', N'Purchase', CAST(N'2024-01-23' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (19, N'Active', N'Sale', CAST(N'2024-04-18' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (20, N'Active', N'Sale', CAST(N'2024-01-18' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (21, N'Active', N'Sale', CAST(N'2024-04-22' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (22, N'Active', N'Purchase', CAST(N'2024-03-03' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (23, N'Active', N'Purchase', CAST(N'2024-03-05' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (24, N'Active', N'Sale', CAST(N'2024-04-05' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (25, N'Active', N'Sale', CAST(N'2024-04-16' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (26, N'Active', N'Purchase', CAST(N'2024-02-02' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (27, N'Active', N'Sale', CAST(N'2024-03-28' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (28, N'Active', N'Sale', CAST(N'2024-02-06' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (29, N'Active', N'Purchase', CAST(N'2024-04-18' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (30, N'Active', N'Purchase', CAST(N'2024-04-16' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (31, N'Active', N'Sale', CAST(N'2024-04-09' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (32, N'Active', N'Sale', CAST(N'2024-04-23' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (33, N'Active', N'Purchase', CAST(N'2024-04-24' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (34, N'Active', N'Purchase', CAST(N'2024-04-17' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (35, N'Active', N'Purchase', CAST(N'2024-01-09' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (36, N'Active', N'Sale', CAST(N'2024-02-08' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (37, N'Active', N'Sale', CAST(N'2024-03-25' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (38, N'Active', N'Sale', CAST(N'2024-04-15' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (39, N'Active', N'Purchase', CAST(N'2024-04-18' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (40, N'Active', N'Sale', CAST(N'2024-02-12' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (41, N'Active', N'Sale', CAST(N'2024-04-05' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (42, N'Active', N'Sale', CAST(N'2024-04-09' AS Date), 3)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (43, N'Active', N'Purchase', CAST(N'2024-04-18' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (44, N'Active', N'Purchase', CAST(N'2024-01-21' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (45, N'Active', N'Purchase', CAST(N'2024-02-05' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (46, N'Active', N'Purchase', CAST(N'2024-01-01' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (47, N'Active', N'Sale', CAST(N'2024-04-06' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (48, N'Active', N'Sale', CAST(N'2024-02-04' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (49, N'Active', N'Purchase', CAST(N'2024-04-09' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (50, N'Active', N'Sale', CAST(N'2024-02-26' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (51, N'Active', N'Purchase', CAST(N'2024-02-29' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (52, N'Active', N'Sale', CAST(N'2024-03-08' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (53, N'Active', N'Sale', CAST(N'2024-01-21' AS Date), 1)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (54, N'Active', N'Sale', CAST(N'2024-04-05' AS Date), 5)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (55, N'Active', N'Purchase', CAST(N'2024-02-01' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (56, N'Active', N'Purchase', CAST(N'2024-02-11' AS Date), 4)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (57, N'Active', N'Purchase', CAST(N'2024-03-14' AS Date), 2)
INSERT [dbo].[Merchant] ([MerchantID], [MerchantStatus], [MerchantType], [LastTransactionDate], [PartnerID]) VALUES (58, N'Active', N'Sale', CAST(N'2024-01-11' AS Date), 2)
GO
SET IDENTITY_INSERT [dbo].[Onlines] ON 

INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (1, N'Bank Al Habib', N'8701575895', N'Ref626707', N'Mitchell', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (2, N'Faysal Bank', N'3111527677', N'Ref542129', N'Gregory', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (3, N'Faysal Bank', N'7771446326', N'Ref196294', N'Erica', N'Lisa')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (4, N'UBL', N'7114937354', N'Ref009293', N'Rodney', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (5, N'Bank Al Habib', N'0413323626', N'Ref088773', N'Tyler', N'Lisa')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (6, N'MCB Bank', N'1717336498', N'Ref926946', N'Rodney', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (7, N'Bank Al Habib', N'1654261387', N'Ref154403', N'Ryan', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (8, N'Askari Bank', N'3473088705', N'Ref005679', N'Ebony', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (9, N'Askari Bank', N'5418602120', N'Ref396119', N'Dana', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (10, N'UBL', N'0883994885', N'Ref324573', N'Dana', N'Lisa')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (11, N'Bank Al Habib', N'0534539206', N'Ref534192', N'Ebony', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (12, N'Askari Bank', N'5691258521', N'Ref871235', N'Paul', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (13, N'Askari Bank', N'8615938210', N'Ref803142', N'Tommy', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (14, N'Askari Bank', N'1269346715', N'Ref675878', N'Amber', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (15, N'HBL', N'6195136662', N'Ref515393', N'Rodney', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (16, N'Bank Alfalah', N'0232997641', N'Ref082181', N'Ebony', N'Patricia')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (17, N'Bank Alfalah', N'3360288804', N'Ref997506', N'Ebony', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (18, N'MCB Bank', N'0617535271', N'Ref444622', N'Dana', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (19, N'Bank Al Habib', N'5616069344', N'Ref641339', N'Maria', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (20, N'Faysal Bank', N'2078009003', N'Ref397126', N'Ryan', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (21, N'HBL', N'3304386127', N'Ref072972', N'Ebony', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (22, N'Bank Al Habib', N'7486615718', N'Ref389392', N'Erica', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (23, N'Bank Al Habib', N'5857292990', N'Ref334970', N'Maria', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (24, N'HBL', N'3307680028', N'Ref114786', N'Amber', N'Nancy')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (25, N'UBL', N'9629561455', N'Ref168323', N'Cassandra', N'Anthony')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (26, N'Bank Al Habib', N'1047840715', N'Ref817619', N'Tyler', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (27, N'Bank Alfalah', N'9266900945', N'Ref578548', N'Rodney', N'Nancy')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (28, N'Bank Alfalah', N'6235119208', N'Ref514888', N'Rodney', N'Lisa')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (29, N'Bank Al Habib', N'5482923965', N'Ref266868', N'Ebony', N'Kevin')
INSERT [dbo].[Onlines] ([OnlineID], [BankName], [AccountNumber], [TransactionReference], [SenderName], [ReceiverName]) VALUES (30, N'Bank Al Habib', N'1785468572', N'Ref059978', N'Dana', N'Anthony')
SET IDENTITY_INSERT [dbo].[Onlines] OFF
GO
INSERT [dbo].[Partner] ([PartnerID], [DepartmentID], [TotalInvestment], [WithdrawalThreshold], [Role]) VALUES (1, 1, 7800000, 5315000, N'CEO')
INSERT [dbo].[Partner] ([PartnerID], [DepartmentID], [TotalInvestment], [WithdrawalThreshold], [Role]) VALUES (2, 3, 5500000, 5085000, N'Manager')
INSERT [dbo].[Partner] ([PartnerID], [DepartmentID], [TotalInvestment], [WithdrawalThreshold], [Role]) VALUES (3, 2, 2800000, 4815000, N'Assistant')
INSERT [dbo].[Partner] ([PartnerID], [DepartmentID], [TotalInvestment], [WithdrawalThreshold], [Role]) VALUES (4, 3, 480000, 4583000, N'Assistant')
INSERT [dbo].[Partner] ([PartnerID], [DepartmentID], [TotalInvestment], [WithdrawalThreshold], [Role]) VALUES (5, 2, 290000, 4564000, N'Assistant')
GO
SET IDENTITY_INSERT [dbo].[PaymentMethod] ON 

INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (1, N'Credit Card', 1, NULL, NULL, 2, 16)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (2, N'Cheque', NULL, 1, NULL, 2, 16)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (3, N'Cheque', NULL, 2, NULL, 3, 13)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (4, N'Cheque', NULL, 3, NULL, 4, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (5, N'Credit Card', 2, NULL, NULL, 3, 14)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (6, N'Online', NULL, NULL, 1, 2, 16)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (7, N'Cheque', NULL, 4, NULL, 5, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (8, N'Cheque', NULL, 5, NULL, 4, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (9, N'Online', NULL, NULL, 2, 3, 13)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (10, N'Cheque', NULL, 6, NULL, 4, 21)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (11, N'Online', NULL, NULL, 3, 4, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (12, N'Online', NULL, NULL, 4, 5, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (13, N'Credit Card', 3, NULL, NULL, 4, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (14, N'Online', NULL, NULL, 5, 4, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (15, N'Online', NULL, NULL, 6, 2, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (16, N'Cheque', NULL, 7, NULL, 3, 33)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (17, N'Credit Card', 4, NULL, NULL, 5, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (18, N'Online', NULL, NULL, 7, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (19, N'Cheque', NULL, 8, NULL, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (20, N'Cheque', NULL, 9, NULL, 3, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (21, N'Credit Card', 5, NULL, NULL, 4, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (22, N'Online', NULL, NULL, 8, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (23, N'Online', NULL, NULL, 9, 3, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (24, N'Online', NULL, NULL, 10, 4, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (25, N'Cheque', NULL, 10, NULL, 4, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (26, N'Online', NULL, NULL, 11, 5, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (27, N'Online', NULL, NULL, 12, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (28, N'Cheque', NULL, 11, NULL, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (29, N'Cheque', NULL, 12, NULL, 3, 13)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (30, N'Cheque', NULL, 13, NULL, 2, 30)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (31, N'Cheque', NULL, 14, NULL, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (32, N'Online', NULL, NULL, 13, 3, 30)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (33, N'Cheque', NULL, 15, NULL, 2, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (34, N'Online', NULL, NULL, 14, 2, 14)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (35, N'Credit Card', 6, NULL, NULL, 4, 21)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (36, N'Cheque', NULL, 16, NULL, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (37, N'Cheque', NULL, 17, NULL, 3, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (38, N'Credit Card', 7, NULL, NULL, 3, 33)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (39, N'Credit Card', 8, NULL, NULL, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (40, N'Cheque', NULL, 18, NULL, 5, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (41, N'Online', NULL, NULL, 15, 2, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (42, N'Online', NULL, NULL, 16, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (43, N'Cheque', NULL, 19, NULL, 5, 31)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (44, N'Online', NULL, NULL, 17, 2, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (45, N'Credit Card', 9, NULL, NULL, 1, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (46, N'Online', NULL, NULL, 18, 5, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (47, N'Online', NULL, NULL, 19, 5, 31)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (48, N'Cheque', NULL, 20, NULL, 5, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (49, N'Cheque', NULL, 21, NULL, 5, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (50, N'Credit Card', 10, NULL, NULL, 4, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (51, N'Cheque', NULL, 22, NULL, 5, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (52, N'Online', NULL, NULL, 20, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (53, N'Credit Card', 11, NULL, NULL, 4, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (54, N'Credit Card', 12, NULL, NULL, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (55, N'Credit Card', 13, NULL, NULL, 2, 30)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (56, N'Cheque', NULL, 23, NULL, 2, 38)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (57, N'Credit Card', 14, NULL, NULL, 5, 38)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (58, N'Online', NULL, NULL, 21, 2, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (59, N'Cheque', NULL, 24, NULL, 1, 14)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (60, N'Online', NULL, NULL, 22, 5, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (61, N'Cheque', NULL, 25, NULL, 2, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (62, N'Credit Card', 15, NULL, NULL, 2, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (63, N'Credit Card', 16, NULL, NULL, 3, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (64, N'Online', NULL, NULL, 23, 2, 38)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (65, N'Online', NULL, NULL, 24, 1, 14)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (66, N'Credit Card', 17, NULL, NULL, 4, 36)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (67, N'Cheque', NULL, 26, NULL, 5, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (68, N'Cheque', NULL, 27, NULL, 1, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (69, N'Online', NULL, NULL, 25, 5, 24)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (70, N'Credit Card', 18, NULL, NULL, 5, 34)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (71, N'Credit Card', 19, NULL, NULL, 5, 31)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (72, N'Credit Card', 20, NULL, NULL, 5, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (73, N'Credit Card', 21, NULL, NULL, 2, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (74, N'Credit Card', 22, NULL, NULL, 5, 29)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (75, N'Online', NULL, NULL, 26, 2, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (76, N'Credit Card', 23, NULL, NULL, 2, 38)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (77, N'Online', NULL, NULL, 27, 1, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (78, N'Cheque', NULL, 28, NULL, 4, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (79, N'Credit Card', 24, NULL, NULL, 1, 14)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (80, N'Cheque', NULL, 29, NULL, 1, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (81, N'Online', NULL, NULL, 28, 4, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (82, N'Credit Card', 25, NULL, NULL, 5, 24)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (83, N'Credit Card', 26, NULL, NULL, 2, 17)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (84, N'Online', NULL, NULL, 29, 2, 12)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (85, N'Cheque', NULL, 30, NULL, 5, 19)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (86, N'Credit Card', 27, NULL, NULL, 1, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (87, N'Credit Card', 28, NULL, NULL, 4, 25)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (88, N'Online', NULL, NULL, 30, 5, 19)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (89, N'Credit Card', 29, NULL, NULL, 1, 32)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentType], [CreditCardID], [ChequeID], [OnlineID], [PartnerID], [MerchantID]) VALUES (90, N'Credit Card', 30, NULL, NULL, 5, 19)
SET IDENTITY_INSERT [dbo].[PaymentMethod] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (1, N'Nancy', N'Lewis', N'Female', N'+91 3812897302', N'katie98@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (2, N'Kevin', N'Marsh', N'Male', N'+92 9012600945', N'lauramoore@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (3, N'Patricia', N'Gray', N'Female', N'+61 6479922899', N'thompsonbenjamin@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (4, N'Lisa', N'Cook', N'Male', N'+86 73497812491', N'eileenhill@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (5, N'Anthony', N'Ponce', N'Male', N'+91 5627190916', N'calvin53@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (6, N'Daniel', N'Perez', N'Male', N'+92 8998113862', N'brianna69@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (7, N'Yolanda', N'Heath', N'Male', N'+86 71906191234', N'rioszachary@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (8, N'Bradley', N'Castro', N'Female', N'+61 2506046312', N'kimpatricia@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (9, N'Belinda', N'Rivera', N'Male', N'+86 96829659474', N'alexanderteresa@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (10, N'Brandon', N'Mcmahon', N'Female', N'+61 8006097016', N'kimberlymcneil@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (11, N'Christine', N'Williams', N'Female', N'+86 93044608244', N'patrickreed@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (12, N'Ebony', N'Moses', N'Male', N'+86 41944271911', N'brianhull@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (13, N'Gregory', N'Bullock', N'Male', N'+91 3220923628', N'reginald91@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (14, N'Amber', N'Nguyen', N'Male', N'+92 8051245277', N'danielgibson@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (15, N'Jessica', N'Austin', N'Male', N'+92 7929020585', N'zavalatony@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (16, N'Mitchell', N'Hoover', N'Male', N'+86 49898666135', N'kristenmiller@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (17, N'Tyler', N'Moore', N'Female', N'+92 2842534435', N'andersontyler@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (18, N'Russell', N'Smith', N'Male', N'+44 637632832', N'bondallen@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (19, N'Dana', N'Mckay', N'Female', N'+86 9409632865', N'howellpatrick@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (20, N'Paul', N'Mason', N'Male', N'+61 4271411429', N'nelsonrobert@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (21, N'Deborah', N'Hall', N'Female', N'+61 6851637061', N'nbarry@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (22, N'Caitlyn', N'Schmidt', N'Female', N'+92 477702686', N'theresasanders@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (23, N'Michelle', N'Francis', N'Male', N'+91 2831643171', N'webbjoseph@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (24, N'Cassandra', N'Larsen', N'Male', N'+92 7787866273', N'ehouse@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (25, N'Rodney', N'Moore', N'Male', N'+91 1478675800', N'garnerpatricia@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (26, N'Aaron', N'Morris', N'Male', N'+91 6169901570', N'yharris@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (27, N'Peter', N'Anderson', N'Female', N'+61 7173002989', N'rebecca83@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (28, N'Kelsey', N'Smith', N'Female', N'+61 5661795066', N'carralexandra@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (29, N'Erica', N'Schneider', N'Female', N'+61 3266778052', N'danny86@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (30, N'Tommy', N'Cole', N'Female', N'+44 8986715889', N'jenniferwoods@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (31, N'Maria', N'Moore', N'Female', N'+86 48792356232', N'amyconner@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (32, N'Ryan', N'Long', N'Male', N'+92 782048343', N'pbeck@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (33, N'Cory', N'Cole', N'Male', N'+86 77982067383', N'hernandezjessica@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (34, N'Dana', N'Butler', N'Female', N'+61 3377210036', N'darrell48@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (35, N'Wendy', N'Aguilar', N'Female', N'+91 7656120284', N'rlynch@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (36, N'Marilyn', N'Murphy', N'Male', N'+61 8671905197', N'emily68@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (37, N'Ashley', N'Dean', N'Male', N'+86 79258529947', N'daltondana@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (38, N'Steven', N'Lloyd', N'Male', N'+61 1012294586', N'nicole85@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (39, N'Monica', N'Barber', N'Female', N'+61 8150726707', N'david29@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (40, N'Shannon', N'Martin', N'Male', N'+61 9349807744', N'meredith29@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (41, N'Donald', N'Mcdonald', N'Male', N'+92 7612231369', N'mortonkelly@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (42, N'Wendy', N'Wilson', N'Male', N'+86 72051519241', N'yvettejames@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (43, N'Joseph', N'Bartlett', N'Female', N'+92 3089906009', N'alexaalvarado@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (44, N'Patrick', N'Johnston', N'Female', N'+92 286513685', N'cummingssamantha@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (45, N'Dana', N'Whitehead', N'Female', N'+44 9876052357', N'fwright@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (46, N'Rodney', N'Ayers', N'Male', N'+86 52322655554', N'aprilmorgan@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (47, N'Linda', N'Phillips', N'Male', N'+92 3200392220', N'meghanjohnson@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (48, N'Emily', N'Hudson', N'Female', N'+86 57109194511', N'zjacobs@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (49, N'Brian', N'Jimenez', N'Female', N'+91 8435310466', N'matthew99@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (50, N'Kim', N'Moore', N'Female', N'+92 2646841053', N'william39@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (51, N'Richard', N'Lynch', N'Male', N'+92 7780599275', N'velazquezamber@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (52, N'Alexandra', N'Campbell', N'Male', N'+61 1950308404', N'john92@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (53, N'Robert', N'Jones', N'Male', N'+44 8439383969', N'patriciarobinson@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (54, N'Patricia', N'Smith', N'Female', N'+86 4941782571', N'zmcguire@example.net')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (55, N'Raven', N'Poole', N'Female', N'+91 4834765336', N'ubarrera@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (56, N'Regina', N'Gallagher', N'Female', N'+91 2638368634', N'mcdowelltimothy@example.org')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (57, N'Daniel', N'Stafford', N'Female', N'+61 3895150148', N'mcintyrekelly@example.com')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [Gender], [Contact], [Email]) VALUES (58, N'Steven', N'Washington', N'Female', N'+44 7322991880', N'christophergonzalez@example.com')
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[Transactions] ON 

INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (1, N'Expense', CAST(284714.00 AS Decimal(10, 2)), CAST(N'2024-01-01' AS Date), 89, NULL, 34)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (3, N'Expense', CAST(36082.50 AS Decimal(10, 2)), CAST(N'2024-01-28' AS Date), 7, 12, 38)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (4, N'Expense', CAST(40070.00 AS Decimal(10, 2)), CAST(N'2024-01-29' AS Date), 86, NULL, 36)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (5, N'Expense', CAST(34003.60 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date), 36, NULL, 22)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (6, N'Expense', CAST(40400.00 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date), 87, NULL, 26)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (7, N'Income', CAST(1594.40 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date), 78, NULL, 18)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (8, N'Expense', CAST(15694.40 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date), 80, NULL, 35)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (9, N'Income', CAST(20130.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), 39, 1, 27)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (10, N'Income', CAST(48410.10 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), 58, 33, 17)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (11, N'Expense', CAST(18546.50 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date), 30, NULL, 38)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (12, N'Income', CAST(12490.60 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date), 6, NULL, 17)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (13, N'Expense', CAST(32061.50 AS Decimal(10, 2)), CAST(N'2024-02-04' AS Date), 4, NULL, 29)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (14, N'Income', CAST(24630.00 AS Decimal(10, 2)), CAST(N'2024-02-05' AS Date), 21, NULL, 30)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (15, N'Expense', CAST(27996.70 AS Decimal(10, 2)), CAST(N'2024-02-05' AS Date), 67, 26, 25)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (16, N'Income', CAST(17590.00 AS Decimal(10, 2)), CAST(N'2024-02-06' AS Date), 54, 10, 3)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (17, N'Expense', CAST(44890.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), 53, NULL, 7)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (18, N'Expense', CAST(20514.80 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), 43, NULL, 21)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (19, N'Expense', CAST(32333.40 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), 44, 33, 24)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (20, N'Expense', CAST(46800.00 AS Decimal(10, 2)), CAST(N'2024-02-08' AS Date), 66, 21, 37)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (21, N'Income', CAST(31110.00 AS Decimal(10, 2)), CAST(N'2024-02-09' AS Date), 82, NULL, 2)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (22, N'Expense', CAST(90650.30 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), 65, NULL, 15)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (23, N'Expense', CAST(54180.30 AS Decimal(10, 2)), CAST(N'2024-02-14' AS Date), 42, NULL, 27)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (24, N'Expense', CAST(42440.00 AS Decimal(10, 2)), CAST(N'2024-02-15' AS Date), 57, 1, 11)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (25, N'Income', CAST(35762.50 AS Decimal(10, 2)), CAST(N'2024-02-15' AS Date), 31, NULL, 39)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (26, N'Expense', CAST(33069.90 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date), 15, 39, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (27, N'Expense', CAST(20024.00 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date), 32, 37, 33)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (28, N'Expense', CAST(37867.40 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date), 8, NULL, 13)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (29, N'Expense', CAST(30378.20 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date), 29, 2, 29)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (30, N'Income', CAST(26304.00 AS Decimal(10, 2)), CAST(N'2024-02-20' AS Date), 27, NULL, 8)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (31, N'Expense', CAST(13460.00 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date), 79, NULL, 30)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (32, N'Expense', CAST(90730.20 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date), 9, 2, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (33, N'Income', CAST(31645.20 AS Decimal(10, 2)), CAST(N'2024-02-26' AS Date), 3, NULL, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (34, N'Expense', CAST(35925.60 AS Decimal(10, 2)), CAST(N'2024-02-26' AS Date), 77, NULL, 4)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (35, N'Expense', CAST(39850.00 AS Decimal(10, 2)), CAST(N'2024-02-27' AS Date), 50, 18, 1)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (36, N'Expense', CAST(29220.00 AS Decimal(10, 2)), CAST(N'2024-02-28' AS Date), 41, 15, 11)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (37, N'Expense', CAST(48374.80 AS Decimal(10, 2)), CAST(N'2024-03-01' AS Date), 61, 5, 17)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (38, N'Expense', CAST(37903.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), 34, 3, 36)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (39, N'Expense', CAST(12790.30 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), 10, NULL, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (40, N'Income', CAST(97303.10 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), 49, 29, 7)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (41, N'Income', CAST(87008.90 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), 56, 11, 25)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (42, N'Expense', CAST(14330.20 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), 59, NULL, 34)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (43, N'Expense', CAST(804302.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), 87, NULL, 32)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (44, N'Expense', CAST(36620.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), 73, NULL, 38)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (45, N'Expense', CAST(27870.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), 74, NULL, 17)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (46, N'Expense', CAST(31957.60 AS Decimal(10, 2)), CAST(N'2024-03-06' AS Date), 26, 12, 18)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (47, N'Expense', CAST(16068.20 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date), 33, 39, 10)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (48, N'Expense', CAST(29215.60 AS Decimal(10, 2)), CAST(N'2024-03-08' AS Date), 23, 7, 3)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (49, N'Expense', CAST(40055.50 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date), 24, NULL, 5)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (50, N'Income', CAST(12969.40 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date), 46, 24, 24)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (51, N'Expense', CAST(19200.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date), 45, 13, 17)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (52, N'Expense', CAST(95020.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date), 72, NULL, 31)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (53, N'Expense', CAST(16352.20 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date), 85, NULL, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (54, N'Expense', CAST(41353.70 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date), 22, 10, 2)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (55, N'Expense', CAST(15215.20 AS Decimal(10, 2)), CAST(N'2024-03-17' AS Date), 81, NULL, 16)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (56, N'Income', CAST(4260.00 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date), 17, NULL, 5)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (57, N'Expense', CAST(14150.00 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date), 70, NULL, 3)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (58, N'Income', CAST(27200.00 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date), 89, NULL, 1)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (59, N'Income', CAST(6114.80 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date), 75, NULL, 26)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (60, N'Expense', CAST(13150.00 AS Decimal(10, 2)), CAST(N'2024-03-24' AS Date), 90, NULL, 27)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (61, N'Income', CAST(13567.00 AS Decimal(10, 2)), CAST(N'2024-03-25' AS Date), 62, 16, 38)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (62, N'Expense', CAST(39199.80 AS Decimal(10, 2)), CAST(N'2024-03-26' AS Date), 18, 1, 32)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (63, N'Expense', CAST(40500.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), 83, NULL, 12)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (64, N'Expense', CAST(13982.30 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), 20, NULL, 27)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (65, N'Income', CAST(13982.30 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), 25, 22, 11)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (66, N'Expense', CAST(16815.20 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), 11, 18, 11)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (67, N'Expense', CAST(49584.90 AS Decimal(10, 2)), CAST(N'2024-03-29' AS Date), 12, NULL, 39)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (68, N'Income', CAST(3180.00 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date), 71, NULL, 11)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (69, N'Expense', CAST(22955.10 AS Decimal(10, 2)), CAST(N'2024-04-02' AS Date), 37, 7, 35)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (71, N'Expense', CAST(83502.30 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date), 51, 28, 35)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (72, N'Income', CAST(37907.00 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date), 69, NULL, 9)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (75, N'Income', CAST(16317.00 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), 5, NULL, 13)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (76, N'Income', CAST(25732.30 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), 47, 20, 15)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (77, N'Expense', CAST(257320.30 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), 52, 9, 7)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (78, N'Expense', CAST(40213.50 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date), 60, 29, 33)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (79, N'Expense', CAST(10296.60 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), 16, 34, 30)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (80, N'Expense', CAST(79500.70 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), 64, NULL, 26)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (81, N'Expense', CAST(38850.00 AS Decimal(10, 2)), CAST(N'2024-04-15' AS Date), 76, NULL, 36)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (82, N'Expense', CAST(33118.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), 1, NULL, 4)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (83, N'Expense', CAST(12400.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), 55, 32, 6)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (84, N'Expense', CAST(33676.80 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), 68, 14, 15)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (85, N'Expense', CAST(46747.30 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), 28, NULL, 25)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (86, N'Expense', CAST(22044.10 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), 40, 26, 35)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (87, N'Expense', CAST(95505.10 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), 48, 29, 39)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (88, N'Expense', CAST(28186.00 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date), 13, 3, 39)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (89, N'Expense', CAST(30857.50 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date), 88, NULL, 20)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (90, N'Expense', CAST(79820.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), 63, NULL, 1)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (91, N'Income', CAST(49067.30 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), 14, NULL, 15)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (92, N'Income', CAST(24291.00 AS Decimal(10, 2)), CAST(N'2024-04-22' AS Date), 35, NULL, 25)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (94, N'Expense', CAST(45539.20 AS Decimal(10, 2)), CAST(N'2024-04-23' AS Date), 19, NULL, 19)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (95, N'Income', CAST(185100.00 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), 38, NULL, 10)
INSERT [dbo].[Transactions] ([TransactionID], [TransactionType], [Amount], [Date], [PaymentMethodID], [InstallmentPlanID], [BudgetID]) VALUES (96, N'Expense', CAST(65480.60 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), 84, 33, 34)
SET IDENTITY_INSERT [dbo].[Transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[UserCredentials] ON 

INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (1, N'richardlynch', N'S1eH@fG3', 1, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (2, N'alexandracampbell', N'P@ssw0rd!2024', 2, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (3, N'robertjones', N'R0b3rtJ#21', 3, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (4, N'patriciasmith', N'P@tr1c1a$mith', 4, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (5, N'ravenpoole', N'P00leR@v3n', 5, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (6, N'reginagallagher', N'G@11@gh3rR3g!na', 6, CAST(N'2024-05-10' AS Date))
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (7, N'd_stafford', N'G3n3R4t3d!', 7, NULL)
INSERT [dbo].[UserCredentials] ([CredentialID], [Username], [Password], [PersonID], [LastLoginDate]) VALUES (8, N's_washington', N'P@ssw0rd!', 8, NULL)
SET IDENTITY_INSERT [dbo].[UserCredentials] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__UserCred__536C85E40E006EDA]    Script Date: 5/10/2024 11:12:21 AM ******/
ALTER TABLE [dbo].[UserCredentials] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Audit] ADD  DEFAULT ('Internal') FOR [AuditType]
GO
ALTER TABLE [dbo].[Audit] ADD  DEFAULT ('Pending') FOR [AuditStatus]
GO
ALTER TABLE [dbo].[AuditorAction] ADD  DEFAULT ('True and fair') FOR [AuditAction]
GO
ALTER TABLE [dbo].[AuditorAction] ADD  DEFAULT ('Qualified') FOR [AuditResult]
GO
ALTER TABLE [dbo].[Budget] ADD  DEFAULT ('Active') FOR [BudgetStatus]
GO
ALTER TABLE [dbo].[Budget] ADD  DEFAULT (NULL) FOR [BudgetType]
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT ((0.00)) FOR [TotalAmount]
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT (NULL) FOR [LastTransactionDate]
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Merchant] ADD  DEFAULT ('Active') FOR [MerchantStatus]
GO
ALTER TABLE [dbo].[Merchant] ADD  DEFAULT (NULL) FOR [MerchantType]
GO
ALTER TABLE [dbo].[Merchant] ADD  DEFAULT (NULL) FOR [LastTransactionDate]
GO
ALTER TABLE [dbo].[Partner] ADD  DEFAULT ((0)) FOR [TotalInvestment]
GO
ALTER TABLE [dbo].[Partner] ADD  DEFAULT ((0)) FOR [WithdrawalThreshold]
GO
ALTER TABLE [dbo].[UserCredentials] ADD  DEFAULT (NULL) FOR [LastLoginDate]
GO
ALTER TABLE [dbo].[Audit]  WITH CHECK ADD FOREIGN KEY([AuditorID])
REFERENCES [dbo].[Auditor] ([AuditorID])
GO
ALTER TABLE [dbo].[Auditor]  WITH CHECK ADD FOREIGN KEY([AuditorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[AuditorAction]  WITH CHECK ADD FOREIGN KEY([AlertID])
REFERENCES [dbo].[FraudAlerts] ([AlertID])
GO
ALTER TABLE [dbo].[AuditorAction]  WITH CHECK ADD FOREIGN KEY([AuditID])
REFERENCES [dbo].[Audit] ([AuditID])
GO
ALTER TABLE [dbo].[AuditorAction]  WITH CHECK ADD FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transactions] ([TransactionID])
GO
ALTER TABLE [dbo].[Budget]  WITH CHECK ADD FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[FraudAlerts]  WITH CHECK ADD FOREIGN KEY([AuditID])
REFERENCES [dbo].[Audit] ([AuditID])
GO
ALTER TABLE [dbo].[FraudAlerts]  WITH CHECK ADD FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transactions] ([TransactionID])
GO
ALTER TABLE [dbo].[InstallmentPlan]  WITH CHECK ADD FOREIGN KEY([MerchantID])
REFERENCES [dbo].[Merchant] ([MerchantID])
GO
ALTER TABLE [dbo].[InstallmentPlan]  WITH CHECK ADD FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[Installments]  WITH CHECK ADD FOREIGN KEY([InstallmentPlanID])
REFERENCES [dbo].[InstallmentPlan] ([InstallmentPlanID])
GO
ALTER TABLE [dbo].[Installments]  WITH CHECK ADD FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transactions] ([TransactionID])
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD FOREIGN KEY([InvoiceID])
REFERENCES [dbo].[Transactions] ([TransactionID])
GO
ALTER TABLE [dbo].[Merchant]  WITH CHECK ADD FOREIGN KEY([MerchantID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Merchant]  WITH CHECK ADD FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[Partner]  WITH CHECK ADD FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Partner]  WITH CHECK ADD FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PaymentMethod]  WITH CHECK ADD FOREIGN KEY([ChequeID])
REFERENCES [dbo].[Cheque] ([ChequeID])
GO
ALTER TABLE [dbo].[PaymentMethod]  WITH CHECK ADD FOREIGN KEY([CreditCardID])
REFERENCES [dbo].[CreditCard] ([CreditCardID])
GO
ALTER TABLE [dbo].[PaymentMethod]  WITH CHECK ADD FOREIGN KEY([MerchantID])
REFERENCES [dbo].[Merchant] ([MerchantID])
GO
ALTER TABLE [dbo].[PaymentMethod]  WITH CHECK ADD FOREIGN KEY([OnlineID])
REFERENCES [dbo].[Onlines] ([OnlineID])
GO
ALTER TABLE [dbo].[PaymentMethod]  WITH CHECK ADD FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([BudgetID])
REFERENCES [dbo].[Budget] ([BudgetID])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([InstallmentPlanID])
REFERENCES [dbo].[InstallmentPlan] ([InstallmentPlanID])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([PaymentMethodID])
REFERENCES [dbo].[PaymentMethod] ([PaymentMethodID])
GO
ALTER TABLE [dbo].[UserCredentials]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Audit]  WITH CHECK ADD CHECK  (([AuditStatus]='Undergoing' OR [AuditStatus]='Pending' OR [AuditStatus]='Complete'))
GO
ALTER TABLE [dbo].[Audit]  WITH CHECK ADD CHECK  (([AuditType]='Internal' OR [AuditType]='External'))
GO
ALTER TABLE [dbo].[AuditorAction]  WITH CHECK ADD CHECK  (([AuditAction]='Not fair' OR [AuditAction]='True and fair'))
GO
ALTER TABLE [dbo].[AuditorAction]  WITH CHECK ADD CHECK  (([AuditResult]='Unqualified' OR [AuditResult]='Qualified'))
GO
ALTER TABLE [dbo].[Budget]  WITH CHECK ADD CHECK  (([BudgetStatus]='Inactive' OR [BudgetStatus]='Active'))
GO
ALTER TABLE [dbo].[Budget]  WITH CHECK ADD CHECK  (([BudgetType]='External' OR [BudgetType]='Office'))
GO
ALTER TABLE [dbo].[Installments]  WITH CHECK ADD CHECK  (([PaymentStatus]='Paid' OR [PaymentStatus]='Pending'))
GO
ALTER TABLE [dbo].[Merchant]  WITH CHECK ADD CHECK  (([MerchantStatus]='Inactive' OR [MerchantStatus]='Active'))
GO
ALTER TABLE [dbo].[Merchant]  WITH CHECK ADD CHECK  (([MerchantType]='Purchase' OR [MerchantType]='Sale'))
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD CHECK  (([TransactionType]='Income' OR [TransactionType]='Expense'))
GO
/****** Object:  StoredProcedure [dbo].[GetAnomaly]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAnomaly]
AS
BEGIN
    SET NOCOUNT ON;

    WITH FeatureStatistics AS (
        SELECT
            AVG(t.Amount) AS AvgTransactionAmount,
            STDEV(t.Amount) AS StdDevTransactionAmount
        FROM 
            Transactions t
    ),
    Anomalies AS (
        SELECT
            t.TransactionID,
            t.Amount,
            t.Date,
            fs.AvgTransactionAmount,
            fs.StdDevTransactionAmount
        FROM 
            Transactions t
        CROSS JOIN 
            FeatureStatistics fs
    )

    SELECT
        TransactionID,
        Amount,
        Date,
        CASE
            WHEN ABS(Amount - AvgTransactionAmount) > 3 * StdDevTransactionAmount THEN 'Anomaly'
            WHEN ABS(Amount - AvgTransactionAmount) / NULLIF(AvgTransactionAmount, 0) > 1.50 THEN 'High Risk Fraud'
            WHEN ABS(Amount - AvgTransactionAmount) / NULLIF(AvgTransactionAmount, 0) > 0.70 THEN 'Moderate Risk Fraud'
            ELSE 'Normal'
        END AS FraudRisk
    FROM
        Anomalies;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetChequeTransactions]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetChequeTransactions] 
    @SelectedMonth DATE
AS
BEGIN
    SET NOCOUNT ON;

WITH FeatureStatistics AS (
    SELECT
        AVG(t.Amount) AS AvgTransactionAmount,
        STDEV(t.Amount) AS StdDevTransactionAmount,
        COUNT(DISTINCT c.ChequeID) AS TotalCheque
    FROM 
        Cheque c 
    INNER JOIN 
        PaymentMethod pm ON c.ChequeID = pm.ChequeID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
),
Anomalies AS (
    SELECT
        t.TransactionID,
        c.ChequeID,
        t.Amount,
        t.Date,
        fs.AvgTransactionAmount,
        fs.StdDevTransactionAmount,
        fs.TotalCheque,
        CAST(COUNT(t.TransactionID) AS decimal) / NULLIF(fs.TotalCheque, 0) AS Frequency
    FROM 
        Cheque c 
    INNER JOIN 
        PaymentMethod pm ON c.ChequeID = pm.ChequeID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
    CROSS JOIN 
        FeatureStatistics fs
    WHERE 
        MONTH(t.Date) = MONTH(@SelectedMonth) 
    GROUP BY
        t.TransactionID, c.ChequeID, t.Amount, t.Date, fs.AvgTransactionAmount, fs.StdDevTransactionAmount, fs.TotalCheque
)

SELECT
    ChequeID,
    TransactionID,
    Amount,
    Date,
    CASE
        WHEN ABS(Amount - AvgTransactionAmount) > 3 * StdDevTransactionAmount THEN 'Anomaly'
        WHEN ABS(Frequency - (CAST(TotalTransactions AS decimal) / NULLIF(TotalCheque, 0))) > 3 * (CAST(StdDevTransactionAmount AS decimal) / NULLIF(TotalCheque, 0)) THEN 'Anomaly'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 1.50 THEN 'High Risk Fraud'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 0.70 THEN 'Moderate Risk Fraud'
        ELSE 'Normal'
    END AS FraudRisk
FROM
    Anomalies
CROSS APPLY
    (SELECT COUNT(TransactionID) AS TotalTransactions FROM Transactions WHERE MONTH(Date) = MONTH(@SelectedMonth)) AS TotalTransactions;

END

GO
/****** Object:  StoredProcedure [dbo].[GetCreditCardAnomalies]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCreditCardAnomalies]
    @SelectedMonth DATE
AS
BEGIN
    SET NOCOUNT ON;

WITH FeatureStatistics AS (
    SELECT
        AVG(t.Amount) AS AvgTransactionAmount,
        STDEV(t.Amount) AS StdDevTransactionAmount,
        COUNT(DISTINCT c.CreditCardID) AS TotalCreditCards
    FROM 
        CreditCard c 
    INNER JOIN 
        PaymentMethod pm ON c.CreditCardID = pm.CreditCardID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
),
Anomalies AS (
    SELECT
        t.TransactionID,
        c.CreditCardID,
        t.Amount,
        t.Date,
        fs.AvgTransactionAmount,
        fs.StdDevTransactionAmount,
        fs.TotalCreditCards,
        CAST(COUNT(t.TransactionID) AS decimal) / NULLIF(fs.TotalCreditCards, 0) AS Frequency
    FROM 
        CreditCard c 
    INNER JOIN 
        PaymentMethod pm ON c.CreditCardID = pm.CreditCardID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
    CROSS JOIN 
        FeatureStatistics fs
    WHERE 
        MONTH(t.Date) = MONTH(@SelectedMonth) 
    GROUP BY
        t.TransactionID, c.CreditCardID, t.Amount, t.Date, fs.AvgTransactionAmount, fs.StdDevTransactionAmount, fs.TotalCreditCards
)

SELECT
    CreditCardID,
    TransactionID,
    Amount,
    Date,
    CASE
        WHEN ABS(Amount - AvgTransactionAmount) > 3 * StdDevTransactionAmount THEN 'Anomaly'
        WHEN ABS(Frequency - (CAST(TotalTransactions AS decimal) / NULLIF(TotalCreditCards, 0))) > 3 * (CAST(StdDevTransactionAmount AS decimal) / NULLIF(TotalCreditCards, 0)) THEN 'Anomaly'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 1.50 THEN 'High Risk Fraud'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 0.70 THEN 'Moderate Risk Fraud'
        ELSE 'Normal'
    END AS FraudRisk
FROM
    Anomalies
CROSS APPLY
    (SELECT COUNT(TransactionID) AS TotalTransactions FROM Transactions WHERE MONTH(Date) = MONTH(@SelectedMonth)) AS TotalTransactions;

END
GO
/****** Object:  StoredProcedure [dbo].[GetInstallmentAnomalies]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInstallmentAnomalies]
    @SelectedMonth DATE
AS
BEGIN
    SET NOCOUNT ON;

  WITH FeatureStatistics AS (
    SELECT
        AVG(ins.TotalAmount) AS AvgInstallmentTotalAmount,
        STDEV(ins.TotalAmount) AS StdDevInstallmentTotalAmount,
        AVG(ins.PaidAmount) AS AvgInstallmentPaidAmount,
        STDEV(ins.PaidAmount) AS StdDevInstallmentPaidAmount,
        COUNT(DISTINCT ins.InstallmentPlanID) AS TotalInstallmentPlans
    FROM 
        Installments ins
    INNER JOIN 
        Transactions t ON ins.TransactionID = t.TransactionID
       WHERE 
        MONTH(t.Date) = MONTH(@SelectedMonth) 

),
Anomalies AS (
    SELECT
        ins.InstallmentID,
        ins.InstallmentNumber,
        ins.InstallmentPlanId, 
        MAX(ins.InstallmentNumber) OVER (PARTITION BY ins.InstallmentID) AS MaxInstallmentNumber,
        SUM(ins.TotalAmount) OVER (PARTITION BY ins.InstallmentID) AS TotalInstallmentAmount,
        ins.DueDate AS InstallmentDate,
        fs.AvgInstallmentTotalAmount,
        fs.StdDevInstallmentTotalAmount,
        fs.AvgInstallmentPaidAmount,
        fs.StdDevInstallmentPaidAmount,
        fs.TotalInstallmentPlans,
        CAST(COUNT(t.TransactionID) AS decimal) / NULLIF(fs.TotalInstallmentPlans, 0) AS Frequency,
        t.TransactionID,
        t.Amount AS Amount,
        t.Date AS Date,
        ins.TotalAmount  -- Include the TotalAmount here
    FROM 
        Installments ins
    INNER JOIN 
        Transactions t ON ins.TransactionID = t.TransactionID
    CROSS JOIN 
        FeatureStatistics fs
		 
    WHERE 
        ins.InstallmentPlanID IS NOT NULL
        AND MONTH(t.Date) = MONTH(@SelectedMonth)
    GROUP BY
        ins.InstallmentID, ins.InstallmentNumber, ins.TotalAmount, ins.PaidAmount, ins.DueDate, 
        fs.AvgInstallmentTotalAmount, fs.StdDevInstallmentTotalAmount, 
        fs.AvgInstallmentPaidAmount, fs.StdDevInstallmentPaidAmount, fs.TotalInstallmentPlans,
        t.TransactionID, t.Amount, t.Date , ins.InstallmentPlanID
)

SELECT
    TransactionID,
    Amount,
    Date,
    InstallmentNumber,
     
    CASE
        WHEN ABS(TotalInstallmentAmount - AvgInstallmentTotalAmount) > 3 * StdDevInstallmentTotalAmount THEN 'Anomaly'
        WHEN ABS(Amount - AvgInstallmentPaidAmount) > 3 * StdDevInstallmentPaidAmount THEN 'Anomaly'
        WHEN TotalInstallmentAmount > 2.0 * AvgInstallmentTotalAmount THEN 'High Risk Fraud'
        WHEN TotalInstallmentAmount > 1.0 * AvgInstallmentTotalAmount THEN 'Moderate Risk Fraud'
        ELSE 'Normal'
       
    END AS FraudRisk
FROM
    Anomalies;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetOnlineTransactions]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOnlineTransactions] 
    @SelectedMonth DATE
AS
BEGIN
    SET NOCOUNT ON;

  WITH FeatureStatistics AS (
    SELECT
        AVG(t.Amount) AS AvgTransactionAmount,
        STDEV(t.Amount) AS StdDevTransactionAmount,
        COUNT(DISTINCT c.OnlineID) AS TotalOnline
    FROM 
        Onlines c 
    INNER JOIN 
        PaymentMethod pm ON c.OnlineID = pm.OnlineID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
),
Anomalies AS (
    SELECT
        t.TransactionID,
        c.OnlineID,
        t.Amount,
        t.Date,
        fs.AvgTransactionAmount,
        fs.StdDevTransactionAmount,
        fs.TotalOnline,
        CAST(COUNT(t.TransactionID) AS decimal) / NULLIF(fs.TotalOnline, 0) AS Frequency
    FROM 
        Onlines c 
    INNER JOIN 
        PaymentMethod pm ON c.OnlineID = pm.OnlineID 
    INNER JOIN 
        Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
    CROSS JOIN 
        FeatureStatistics fs
    WHERE 
        MONTH(t.Date) = MONTH(@SelectedMonth) 
    GROUP BY
        t.TransactionID, c.OnlineID, t.Amount, t.Date, fs.AvgTransactionAmount, fs.StdDevTransactionAmount, fs.TotalOnline
)

SELECT
    OnlineID,
    TransactionID,
    Amount,
    Date,
    CASE
        WHEN ABS(Amount - AvgTransactionAmount) > 3 * StdDevTransactionAmount THEN 'Anomaly'
        WHEN ABS(Frequency - (CAST(TotalTransactions AS decimal) / NULLIF(TotalOnline, 0))) > 3 * (CAST(StdDevTransactionAmount AS decimal) / NULLIF(TotalOnline, 0)) THEN 'Anomaly'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 1.50 THEN 'High Risk Fraud'
        WHEN ABS(Amount - AvgTransactionAmount) / AvgTransactionAmount > 0.70 THEN 'Moderate Risk Fraud'
        ELSE 'Normal'
    END AS FraudRisk
FROM
    Anomalies
CROSS APPLY
    (SELECT COUNT(TransactionID) AS TotalTransactions FROM Transactions WHERE MONTH(Date) = MONTH(@SelectedMonth)) AS TotalTransactions;

END;
GO
/****** Object:  StoredProcedure [dbo].[IdentifyTransactionAnomalies]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IdentifyTransactionAnomalies]
    @SelectedMonth DATE
AS
BEGIN
    SET NOCOUNT ON;

    WITH TransactionInvoiceMap AS (
        -- Map each transaction to its corresponding invoice (if any)
        SELECT
            t.TransactionID,
            t.Amount ,
            t.Date ,
			i.InvoiceID,
            i.Amount AS InvoiceAmount,
            i.Date AS InvoiceDate
        FROM
            Transactions t
        LEFT JOIN
            Invoice i ON t.TransactionID = i.InvoiceID

    ),
    Anomalies AS (
        -- Identify anomalies where the transaction amount does not match the invoice amount
        SELECT
            t.TransactionID,
            t.Amount ,
            t.Date ,
			i.InvoiceID,
            i.Amount AS InvoiceAmount,
            i.Date AS InvoiceDate,
            CASE
                WHEN i.InvoiceID IS NULL THEN 'Missing'
                WHEN t.Amount != i.Amount THEN 'Anomaly'
                WHEN t.Date != i.Date THEN 'Anomaly'
                ELSE 'Normal'
            END AS "FraudRisk"
        FROM
            Transactions t
        LEFT JOIN
            Invoice i ON t.TransactionID = i.InvoiceID
			WHERE 
        MONTH(t.Date) = MONTH(@SelectedMonth)
    )  
    SELECT
        *
    FROM
        Anomalies;
END;
GO
/****** Object:  StoredProcedure [dbo].[ManageMerchantTable]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ManageMerchantTable]
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Gender NVARCHAR(10),
    @Contact NVARCHAR(20),
    @Email NVARCHAR(100),
    @MerchantStatus NVARCHAR(20),
    @MerchantType NVARCHAR(20),
    @PartnerID INT,
    @MerchantID INT OUTPUT
AS
BEGIN
    -- Insert data into the Person table
    INSERT INTO Person (firstName, lastName, gender, contact, email)
    VALUES (@FirstName, @LastName, @Gender, @Contact, @Email);

    -- Get the newly inserted PersonID
    SET @MerchantID = SCOPE_IDENTITY();

    -- Insert data into the Merchant table
    INSERT INTO Merchant (MerchantID, MerchantStatus, MerchantType, lastTransactionDate, PartnerID)
    VALUES (@MerchantID, @MerchantStatus, @MerchantType, NULL , @PartnerID);

    -- Return the MerchantID
    SELECT @MerchantID AS MerchantID;
END
GO
/****** Object:  Trigger [dbo].[SubtractBudgetAmount]    Script Date: 5/10/2024 11:12:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[SubtractBudgetAmount]
ON [dbo].[Budget]
AFTER INSERT
AS
BEGIN
    DECLARE @DepartmentID INT;
    DECLARE @AllocatedAmount DECIMAL(18, 2);

    -- Get the department ID and allocated amount from the inserted row
    SELECT @DepartmentID = DepartmentID, @AllocatedAmount = AllocatedAmount
    FROM inserted;

    -- Subtract the allocated amount from the department's total amount and set the updated date
    UPDATE Department
    SET TotalAmount = TotalAmount - @AllocatedAmount,
        UpdatedDate = GETDATE() -- Set the updated date to the current date and time
    WHERE DepartmentID = @DepartmentID;
END;
GO
ALTER TABLE [dbo].[Budget] ENABLE TRIGGER [SubtractBudgetAmount]
GO
/****** Object:  Trigger [dbo].[UpdateDepartmentAmount]    Script Date: 5/10/2024 11:12:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[UpdateDepartmentAmount]
ON [dbo].[Budget]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(AllocatedAmount)
    BEGIN
        DECLARE @DepartmentID INT;
        DECLARE @NewAllocatedAmount DECIMAL(18, 2);
        DECLARE @OldAllocatedAmount DECIMAL(18, 2);

        -- Get the department ID and new/old allocated amounts from the inserted and deleted tables
        SELECT @DepartmentID = i.DepartmentID, 
               @NewAllocatedAmount = i.AllocatedAmount,
               @OldAllocatedAmount = d.AllocatedAmount
        FROM inserted i
        INNER JOIN deleted d ON i.BudgetID = d.BudgetID;

        -- Calculate the difference between the new and old allocated amounts
        DECLARE @AmountDifference DECIMAL(18, 2);
        SET @AmountDifference = @NewAllocatedAmount - @OldAllocatedAmount;

        -- Update the department's total amount based on the difference
        IF @AmountDifference > 0
        BEGIN
            -- If the new allocated amount is greater, add the difference to the total amount
            UPDATE Department
            SET TotalAmount = TotalAmount + @AmountDifference,
                UpdatedDate = GETDATE() -- Set the updated date to the current date and time
            WHERE DepartmentID = @DepartmentID;
        END
        ELSE
        BEGIN
            -- If the new allocated amount is less or equal, subtract the absolute difference from the total amount
            UPDATE Department
            SET TotalAmount = TotalAmount - ABS(@AmountDifference),
                UpdatedDate = GETDATE() -- Set the updated date to the current date and time
            WHERE DepartmentID = @DepartmentID;
        END
    END
END;
GO
ALTER TABLE [dbo].[Budget] ENABLE TRIGGER [UpdateDepartmentAmount]
GO
/****** Object:  Trigger [dbo].[InsertInvoiceOnTransaction]    Script Date: 5/10/2024 11:12:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[InsertInvoiceOnTransaction]
ON [dbo].[Transactions]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert a record into the Invoice table for each transaction
    INSERT INTO Invoice (InvoiceID, Amount, Date)
    SELECT inserted.TransactionID, inserted.Amount, inserted.Date
    FROM inserted;
END;
GO
ALTER TABLE [dbo].[Transactions] ENABLE TRIGGER [InsertInvoiceOnTransaction]
GO
/****** Object:  Trigger [dbo].[UpdateBudgetAndDepartment]    Script Date: 5/10/2024 11:12:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[UpdateBudgetAndDepartment]
ON [dbo].[Transactions]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TransactionID INT;
    DECLARE @TransactionType VARCHAR(50);
    DECLARE @Amount DECIMAL(10, 2);
    DECLARE @BudgetID INT;
    DECLARE @MerchantID INT;
    DECLARE @TransactionDate DATE;

    -- Get the inserted values
    SELECT @TransactionID = inserted.TransactionID,
           @TransactionType = inserted.TransactionType,
           @Amount = inserted.Amount,
           @BudgetID = inserted.BudgetID,
           @TransactionDate = inserted.Date
    FROM inserted;

    -- Get the MerchantID using PaymentMethod
    SELECT @MerchantID = pm.MerchantID
    FROM Transactions t
    JOIN PaymentMethod pm ON t.PaymentMethodID = pm.PaymentMethodID
    WHERE t.TransactionID = @TransactionID;

    -- Update the budget and department based on transaction type
    IF @TransactionType = 'Expense'
    BEGIN
        UPDATE Budget
        SET RemainingAmount = RemainingAmount - @Amount
        WHERE BudgetID = @BudgetID;

        UPDATE Department
        SET TotalAmount = TotalAmount - @Amount,
            LastTransactionDate = @TransactionDate
        WHERE DepartmentID = (SELECT DepartmentID FROM Budget WHERE BudgetID = @BudgetID);
    END
    ELSE IF @TransactionType = 'Income'
    BEGIN
        UPDATE Budget
        SET AllocatedAmount = AllocatedAmount + @Amount,
            RemainingAmount = RemainingAmount + @Amount
        WHERE BudgetID = @BudgetID;

        UPDATE Department
        SET TotalAmount = TotalAmount + @Amount,
            LastTransactionDate = @TransactionDate
        WHERE DepartmentID = (SELECT DepartmentID FROM Budget WHERE BudgetID = @BudgetID);
    END

    -- Update the merchant's last transaction date
    UPDATE Merchant
    SET LastTransactionDate = @TransactionDate
    WHERE MerchantID = @MerchantID;
END;
GO
ALTER TABLE [dbo].[Transactions] ENABLE TRIGGER [UpdateBudgetAndDepartment]
GO
USE [master]
GO
ALTER DATABASE [FinanceA] SET  READ_WRITE 
GO
