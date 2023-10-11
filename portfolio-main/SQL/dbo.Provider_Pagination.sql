USE [wepairhealth]
GO
/****** Object:  StoredProcedure [dbo].[Providers_Pagination]    Script Date: 10/10/2023 5:06:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Hector Guerra
-- Create date:		10/04/2023
-- Description:		Pagination procedure for Providers, ProviderSpecialization, ProviderLanguages,  Licenses, ProviderExpertise, ProfessionalDetails tables
-- Code Reviewer:	

-- MODIFIED BY:
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
-- =============================================
ALTER proc [dbo].[Providers_Pagination]

@PageIndex int
,@PageSize int

as
/*
execute dbo.Providers_Pagination @PageIndex = 0,
								 @PageSize = 10

*/
begin
         
	 DECLARE @offset int = @PageIndex * @PageSize

     SELECT 
		
	    P.[Id],
		TT.[Id] as TittleId,
		TT.[Name] as Tittle,
		dbo.fn_GetUserJSON(p.UserId) AS [UserData],
		GT.[Id] as GenderId,
		GT.[Name] as Gender,
		PD.[NPI],
		GA.[Id] as GenderAcceptedId,
		GA.[Name] as GenderAccepted,
		P.[Phone],
		P.[Fax],
		
        (
            SELECT 
		PS.SpecializationId as 'specialization.id',
                S.[Name] as 'specialization.name',
                PS.isPrimary AS SpecializationIsPrimary
	
               FROM dbo.ProviderSpecialization as PS
	       inner join dbo.Specialization as S 
	       On PS.SpecializationId = S.Id
               WHERE P.Id = PS.ProviderId
               FOR JSON PATH
        ) AS Specializations,
	
        (
            SELECT 
               L.[Name]
            
	       FROM dbo.ProviderLanguages as PL
	       inner join dbo.Languages as L
	       On PL.LanguageId = L.Id
               WHERE P.Id = PL.ProviderId
               FOR JSON PATH
        ) AS Languages,
	
        (
            SELECT 
                ET.[Name]
                
		FROM dbo.ProviderExpertise as PE
		inner join dbo.ExpertiseTypes as ET
		On PE.ExpertiseId = ET.Id
                WHERE P.Id = PE.ProviderId
                FOR JSON PATH
        ) AS Expertises,
	
	(
            SELECT 
                L.[LicenseStateId] as 'state.id',
		ST.[Name] as 'state.name',
		L.LicenseNumber ,
		L.DateExpires
            
		FROM dbo.Licenses as L
		inner join dbo.States as ST
		On L.LicenseStateId = ST.Id
                WHERE P.UserId = L.CreatedBy 
                FOR JSON PATH
        ) AS Licenses,
		
		[TotalCount] = COUNT(1) OVER()
		FROM dbo.Providers P
		inner join dbo.ProfessionalDetails as PD
		ON P.Id = PD.ProviderId
		inner join dbo.Users as U 
		On P.UserId = U.Id
		inner join dbo.GenderTypes as GT
		On P.GenderTypeId = GT.Id 
		inner join dbo.GenderTypes as GA
		On PD.GenderAccepted = GA.Id 
		inner join dbo.TitleTypes as TT
		On P.TitleTypeId = TT.Id
			
			ORDER BY p.Id

			OFFSET @offset ROWS
			FETCH NEXT @PageSize ROWS ONLY
END;
