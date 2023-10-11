USE [wepairhealth]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Providers](
	[Id] [int] IDENTITY(1,1)    NOT NULL,
	[TitleTypeId] [varchar](20) NULL,
	[UserId] [int]              NOT NULL,
	[GenderTypeId] [int]        NOT NULL,
	[Phone] [varchar](50)       NOT NULL,
	[Fax] [varchar](50)         NOT NULL,
 CONSTRAINT [PK_Providers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


