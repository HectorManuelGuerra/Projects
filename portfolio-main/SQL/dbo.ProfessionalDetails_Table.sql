USE [wepairhealth]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProfessionalDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProviderId] [int] NOT NULL,
	[NPI] [bigint] NOT NULL,
	[GenderAccepted] [int] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_ProfessionalDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProfessionalDetails] ADD  CONSTRAINT [DF_ProfessionalDetails_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[ProfessionalDetails] ADD  CONSTRAINT [DF_ProfessionalDetails_DateModified]  DEFAULT (getutcdate()) FOR [DateModified]
GO

ALTER TABLE [dbo].[ProfessionalDetails]  WITH CHECK ADD  CONSTRAINT [FK_ProfessionalDetails_Users] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([Id])
GO

ALTER TABLE [dbo].[ProfessionalDetails] CHECK CONSTRAINT [FK_ProfessionalDetails_Users]
GO

ALTER TABLE [dbo].[ProfessionalDetails]  WITH CHECK ADD  CONSTRAINT [FK_ProfessionalDetails_Users1] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO

ALTER TABLE [dbo].[ProfessionalDetails] CHECK CONSTRAINT [FK_ProfessionalDetails_Users1]
GO

