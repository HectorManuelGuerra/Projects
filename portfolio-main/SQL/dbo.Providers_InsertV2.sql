USE [wepairhealth]
GO
/****** Object:  StoredProcedure [dbo].[Providers_InsertV2]    Script Date: 10/10/2023 5:15:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Hector Guerra
-- Create date:		09/01/2023
-- Description:		Insert procedure for Providers, ProviderSpecialization, ProviderLanguages,  Licenses, ProviderExpertise, ProfessionalDetails tables
-- Code Reviewer:	

-- MODIFIED BY:
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
-- =============================================

ALTER proc [dbo].[Providers_InsertV2]
------------Providers---------------------	
			@TitleTypeId varchar(20),
			@UserId int,
			@GenderTypeId int,
			@Phone varchar(50),
			@Fax varchar(50),
------------ProvidersPecialization--------
			@ProviderSpecialization dbo.BatchProviderSpecialization READONLY,
------------------------------------------
------------ProviderLanguages-------------
			@ProviderLanguages dbo.BatchProviderLanguages READONLY,
------------------------------------------
------------ProviderExpertise-------------
			@ProviderExpertise dbo.BatchProviderExpertise READONLY,
------------------------------------------
------------------------------------------
------------Licenses----------------------
			@Licenses dbo.BatchLicenses READONLY,
------------------------------------------
------------ProffesionalDetails-----------
			@NPI bigint,
			@GenderAccepted int,
------------------------------------------
			@ProviderId int OUTPUT
AS

        
BEGIN

SET XACT_ABORT ON
Declare @Tran nvarchar(50)  = 'Providers_Insert_Trans'

BEGIN TRY
/*
Declare    
			 @ProviderId int,
			 @TitleTypeId varchar(20) = 'Mr',
			 @UserId int = 8,
			 @GenderTypeId int = 2,
			 @Phone varchar(50) = '1234567890',
			 @Fax varchar(50) = '1234567890',
			 @ProviderSpecialization dbo.BatchProviderSpecialization,
			 @ProviderLanguages dbo.BatchProviderLanguages,
			 @ProviderExpertise dbo.BatchProviderExpertise,
			 @Licenses dbo.BatchLicenses,
			 @NPI bigint = 6578439,
			 @GenderAccepted int = 2;

INSERT INTO @ProviderSpecialization (SpecializationsId, IsPrimary)
VALUES 
    (1, 1),
    (20, 0);

INSERT INTO @ProviderLanguages (LanguageId)
VALUES 
    (1),
    (20);

INSERT INTO @ProviderExpertise (ExpertiseId)
VALUES 
    (1),
    (4);
INSERT INTO @Licenses (LicenseStateId, LicenseNumber, DateExpires)
VALUES 
    (1, '4567845', '2023-09-30'),
    (1, '4567850', '2023-09-30');
			

Execute [dbo].[Providers_InsertV2]
		    @TitleTypeId,
			@UserId,
			@GenderTypeId,
			@Phone,
			@Fax,
			@ProviderSpecialization,
			@ProviderLanguages,
			@ProviderExpertise,
			@Licenses,
			@NPI,
			@GenderAccepted,
			@ProviderId OUTPUT;
*/
BEGIN Transaction @Tran

------------Providers-------------------
INSERT INTO dbo.Providers
		  ([TitleTypeId],
			 [UserId],
			 [GenderTypeId],
			 [Phone],
			 [Fax])

VALUES 
			(@TitleTypeId,
			 @UserId,
			 @GenderTypeId,
			 @Phone,
			 @Fax)            
SET          @ProviderId = SCOPE_IDENTITY()
------------ProvidersPecialization--------
INSERT INTO dbo.ProviderSpecialization
			([ProviderId],
			 [SpecializationId],
			 [IsPrimary],
			 [CreatedBy])                    
SELECT		 
			 @ProviderId,
		   bs.SpecializationsId,
			 bs.IsPrimary,
			 @UserId

			 FROM    @ProviderSpecialization AS bs 
			 WHERE   NOT EXISTS (
			 SELECT 1
			 FROM    dbo.ProviderSpecialization AS S
			 WHERE   S.SpecializationId = bs.SpecializationsId AND
					     S.ProviderId = @ProviderId)
------------------------------------------
------------ProviderLanguages-------------
INSERT INTO dbo.ProviderLanguages
			([ProviderId],
			 [LanguageId])                    
SELECT		 
			 @ProviderId,
		     bL.LanguageId

			 FROM    @ProviderLanguages AS bL 
			 WHERE   NOT EXISTS (
			 SELECT 1
			 FROM    dbo.ProviderLanguages AS l
			 WHERE   @ProviderId = l.ProviderId AND 
					 L.LanguageId = bL.LanguageId)
------------ProviderExpertise-------------
INSERT INTO dbo.ProviderExpertise
			([ProviderId],
			 [ExpertiseId],
			 [CreatedBy])                    
SELECT		 
			 @ProviderId,
		     bs.ExpertiseId,
			 @UserId

			 FROM    @ProviderExpertise AS bs 
			 WHERE   NOT EXISTS (
			 SELECT 1
			 FROM    dbo.ProviderExpertise AS S
			 WHERE   S.ExpertiseId = bs.ExpertiseId and
					 @providerId = S.ProviderId)
-------------------------------------------
------------Licenses-----------------------

INSERT INTO dbo.Licenses
			([LicenseStateId],
			 [LicenseNumber],
			 [DateExpires],
			 [CreatedBy])                    
SELECT
			 bl.LicenseStateId,
			 bl.LicenseNumber,
			 bl.DateExpires,
			 @UserId

   		     FROM    @Licenses AS bl 
			 WHERE   NOT EXISTS (
			 SELECT 1
			 FROM    dbo.Licenses AS l
			 WHERE   l.LicenseStateId = bl.LicenseStateId AND
				       l.LicenseNumber = bl.LicenseNumber AND
				       l.DateExpires = bl.DateExpires AND
					     @UserId = l.CreatedBy)
											 
------------------------------------------
------------ProffesionalDetails-----------			
INSERT INTO dbo.ProfessionalDetails
			([ProviderId],
			 [NPI],
			 [GenderAccepted],
			 [CreatedBy],
			 [ModifiedBy])

VALUES		(@ProviderId,
			 @NPI,
			 @GenderAccepted,
			 @UserId,
			 @UserId)
------------------------------------------

Commit Transaction @Tran

END TRY
BEGIN Catch

    IF (XACT_STATE()) = -1
    BEGIN
        PRINT 'The transaction is in an uncommittable state.' +
              ' Rolling back transaction.'
        ROLLBACK TRANSACTION @Tran;;
    END;

    -- Test whether the transaction is active and valid.
    IF (XACT_STATE()) = 1
    BEGIN
        PRINT 'The transaction is committable.' +
              ' Committing transaction.'
        COMMIT TRANSACTION @Tran;;
    END;
        -- If you want to see error info
       -- SELECT
        --ERROR_NUMBER() AS ErrorNumber,
        --ERROR_SEVERITY() AS ErrorSeverity,
        --ERROR_STATE() AS ErrorState,
       -- ERROR_PROCEDURE() AS ErrorProcedure,
       -- ERROR_LINE() AS ErrorLine,
       -- ERROR_MESSAGE() AS ErrorMessage

-- to just get the error thrown and see the bad news as an exception
    THROW

End Catch
SET XACT_ABORT OFF

END 
