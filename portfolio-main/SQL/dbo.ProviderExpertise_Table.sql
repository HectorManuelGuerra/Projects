USE [wepairhealth]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProviderExpertise](
	[ProviderId] [int] NOT NULL,
	[ExpertiseId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProviderId] ASC,
	[ExpertiseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProviderExpertise] ADD  DEFAULT (getutcdate()) FOR [DateCreated]
GO

ALTER TABLE [dbo].[ProviderExpertise]  WITH CHECK ADD  CONSTRAINT [FK_ProviderExpertise_Providers] FOREIGN KEY([ProviderId])
REFERENCES [dbo].[Providers] ([Id])
GO

ALTER TABLE [dbo].[ProviderExpertise] CHECK CONSTRAINT [FK_ProviderExpertise_Providers]
GO

