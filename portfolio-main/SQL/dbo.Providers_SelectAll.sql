USE [wepairhealth]
GO
/****** Object:  StoredProcedure [dbo].[Providers_SelectAll]    Script Date: 10/10/2023 4:54:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Hector Guerra
-- Create date:		09/25/2023
-- Description:		Select All procedure for Providers, ProviderSpecialization, ProviderLanguages,  Licenses, ProviderExpertise, ProfessionalDetails tables
-- Code Reviewer:	

-- MODIFIED BY:
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
-- =============================================

ALTER proc [dbo].[Providers_SelectAll]
AS
/*
execute dbo.Providers_SelectAll
*/
begin
         


  SELECT 
		
	  P.[Id],
		TT.[Id] AS TittleId,
		TT.[Name] AS Tittle,
		dbo.fn_GetUserJSON(p.UserId) AS [UserData],
		GT.[Id] AS GenderId,
		GT.[Name] AS Gender,
		PD.[NPI],
		GA.[Id] AS GenderAcceptedId,
		GA.[Name] AS GenderAccepted,
		P.[Phone],
		P.[Fax],
        
        (
            SELECT 
		PS.SpecializationId AS 'specialization.id',
                S.[Name] AS 'specialization.name',
                PS.isPrimary AS SpecializationIsPrimary
                
               FROM dbo.ProviderSpecialization AS PS
	       INNER JOIN dbo.Specialization AS S 
	       On PS.SpecializationId = S.Id
               WHERE P.Id = PS.ProviderId
               FOR JSON PATH
        ) AS Specializations,
        
        (
            SELECT 
               L.[Name]
            
               FROM dbo.ProviderLanguages AS PL
	       INNER JOIN dbo.Languages AS L
               On PL.LanguageId = L.Id
               WHERE P.Id = PL.ProviderId
               FOR JSON PATH
        ) AS Languages,
        
        (
            SELECT 
                ET.[Name]
  
                FROM dbo.ProviderExpertise AS PE
	        INNER JOIN dbo.ExpertiseTypes AS ET
    		On PE.ExpertiseId = ET.Id
                WHERE P.Id = PE.ProviderId
                FOR JSON PATH
        ) AS Expertises,
		    (
            SELECT 
                L.[LicenseStateId] AS 'state.id',
        	ST.[Name] AS 'state.name',
                L.LicenseNumber ,
                L.DateExpires
  
                FROM dbo.Licenses AS L
    	        INNER JOIN dbo.States AS ST
    		On L.LicenseStateId = ST.Id
                WHERE P.UserId = L.CreatedBy 
                FOR JSON PATH
        ) AS Licenses
  
            	FROM dbo.Providers P
            	INNER JOIN dbo.ProfessionalDetails AS PD
		ON P.Id = PD.ProviderId
	
	       INNER JOIN dbo.Users AS U 
               On P.UserId = U.Id
  
               INNER JOIN dbo.GenderTypes AS GT
               On P.GenderTypeId = GT.Id 
  
               INNER JOIN dbo.GenderTypes AS GA
               On PD.GenderAccepted = GA.Id 
  
               INNER JOIN dbo.TitleTypes AS TT
               On P.TitleTypeId = TT.Id
		
END;



                                 
