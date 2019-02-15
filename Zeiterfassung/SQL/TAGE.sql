USE [ZEITERFASSUNG]
GO

/****** Object:  Table [dbo].[TAGE]    Script Date: 15.02.2019 15:16:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TAGE](
	[TAG] [date] NOT NULL,
	[USERNAME] [varchar](100) NOT NULL,
	[FREIER_TAG] [bit] NULL,
	[KOMMEN] [time](0) NULL,
	[PAUSE_START] [time](0) NULL,
	[PAUSE_ENDE] [time](0) NULL,
	[GEHEN] [time](0) NULL,
	[SONSTIGER_ABZUG] [time](0) NULL,
	[ZUHAUSE] [time](0) NULL,
	[‹BERSTUNDEN] [int] NULL,
	[‹BERSTUNDEN_SALDO] [int] NULL,
 CONSTRAINT [PK_KOPF] PRIMARY KEY CLUSTERED 
(
	[TAG] ASC,
	[USERNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


