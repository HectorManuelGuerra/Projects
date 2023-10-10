using Newtonsoft.Json;
using Wepair.Data;
using Wepair.Data.Providers;
using Wepair.Models;
using Wepair.Models.Domain;
using Wepair.Models.Domain.Provider;
using Wepair.Models.Domain.Users;
using Wepair.Models.Requests.Provider;
using Wepair.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;

namespace Wepair.Services
{
    public class ProvidersService : IProvidersService
    {
        IDataProvider _data = null;
        ILookUpService _lookUpService = null;


        public ProvidersService(IDataProvider data, ILookUpService lookUpService)
        {
            _data = data;
            _lookUpService = lookUpService;
        }

        
        #region ----- Add Method -----
        
        public int Add(ProviderAddRequest model, int userId)
        {
            int providersId = 0;
            string procName = "[dbo].[Providers_InsertV2]";
            DataTable providerSpecializationTable = new DataTable();
            providerSpecializationTable.Columns.Add("SpecializationId", typeof(int));
            providerSpecializationTable.Columns.Add("IsPrimary", typeof(int));
            if (model.providerSpecializations != null && model.providerSpecializations.Count > 0)
            {
                foreach (var Specialization in model.providerSpecializations)
                {
                    DataRow providerSpecializationRow = providerSpecializationTable.NewRow();
                    providerSpecializationRow["SpecializationId"] = Specialization.SpecializationId;
                    providerSpecializationRow["isPrimary"] = Specialization.isPrimary;
                    providerSpecializationTable.Rows.Add(providerSpecializationRow);
                }
            }
            DataTable providerLanguagesTable = new DataTable();
            providerLanguagesTable.Columns.Add("LanguageId", typeof(int));
            if (model.providerLanguageId != null && model.providerLanguageId.Count > 0)
            {
                foreach (var languageId in model.providerLanguageId)
                {
                    DataRow providerLanguagesRow = providerLanguagesTable.NewRow();
                    providerLanguagesRow["LanguageId"] = languageId;
                    providerLanguagesTable.Rows.Add(providerLanguagesRow);
                }
            }
            DataTable providerExpertiseTable = new DataTable();
            providerExpertiseTable.Columns.Add("ExpertiseId", typeof(int));
            if (model.providerExpertiseId != null && model.providerExpertiseId.Count > 0)
            {
                foreach (var Expertise in model.providerExpertiseId)
                {
                    DataRow providerExpertiseRow = providerExpertiseTable.NewRow();
                    providerExpertiseRow["ExpertiseId"] = Expertise;
                    providerExpertiseTable.Rows.Add(providerExpertiseRow);
                }
            }
            DataTable licensesTable = new DataTable();
            licensesTable.Columns.Add("LicenseStateId", typeof(int));
            licensesTable.Columns.Add("LicenseNumber", typeof(string));
            licensesTable.Columns.Add("DateExpires", typeof(DateTime));
            if (model.licenses != null && model.licenses.Count > 0)
            {
                foreach (var License in model.licenses)
                {
                    DataRow licenseRow = licensesTable.NewRow();
                    licenseRow["LicenseStateId"] = License.LicenseStateId;
                    licenseRow["LicenseNumber"] = License.LicenseNumber;
                    licenseRow["DateExpires"] = License.DateExpires;
                    licensesTable.Rows.Add(licenseRow);
                }
            }
            _data.ExecuteNonQuery(procName,
                inputParamMapper: delegate (SqlParameterCollection col)
                {
                    AddCommonParams(model, col);

                    SqlParameter providersIdOut = new SqlParameter("@ProviderId", SqlDbType.Int);
                    {
                        providersIdOut.Direction = ParameterDirection.Output;
                    }
                    col.Add(providersIdOut);
                    col.AddWithValue("@UserId", userId);
                    col.AddWithValue("@ProviderSpecialization", providerSpecializationTable);
                    col.AddWithValue("@ProviderLanguages", providerLanguagesTable);
                    col.AddWithValue("@ProviderExpertise", providerExpertiseTable);
                    col.AddWithValue("@Licenses", licensesTable);
                },
                returnParameters: delegate (SqlParameterCollection returnCollection)
                {
                    object providersIdObj = returnCollection["@ProviderId"].Value;
                    int.TryParse(providersIdObj.ToString(), out providersId);
                }
            );
            return providersId;
        }
        #endregion

        
        
        #region ----- Provider Pagination -----
        
        public Paged<ProviderInfo> PaginateProviders(int pageIndex, int pageSize)
        {
            Paged<ProviderInfo> pagedList = null;
            List<ProviderInfo> list = null;
            int totalCount = 0;
            _data.ExecuteCmd("[dbo].[Providers_Pagination]", delegate (SqlParameterCollection col)
            {
                col.AddWithValue("@PageIndex", pageIndex);
                col.AddWithValue("@PageSize", pageSize);
            }, singleRecordMapper: delegate (IDataReader reader, short set)
            {
                int startingIndex = 0;
                ProviderInfo provider = MapSingleProvider(reader, ref startingIndex);
                if (totalCount == 0)
                {
                    totalCount = reader.GetSafeInt32(reader.FieldCount - 1);
                }
                if (list == null)
                {
                    list = new List<ProviderInfo>();
                }
                list.Add(provider);
            });
            if (list != null)
            {
                pagedList = new Paged<ProviderInfo>(list, pageIndex, pageSize, totalCount);
            }
            return pagedList;
        }
        #endregion


         #region ----- MapSingleProvider -----
         
         public ProviderInfo MapSingleProvider(IDataReader reader, ref int startingIndex)
         {
             ProviderInfo aProvider = new ProviderInfo();
             aProvider.Id = reader.GetInt32(startingIndex++);
             aProvider.Tittle = _lookUpService.MapSingleLookUp(reader, ref startingIndex);
             aProvider.UserData = reader.DeserializeObject<BaseUser>(startingIndex++);
             aProvider.Gender = _lookUpService.MapSingleLookUp(reader, ref startingIndex);
             aProvider.NPI = reader.GetInt64(startingIndex++);
             aProvider.GenderAccepted = _lookUpService.MapSingleLookUp(reader, ref startingIndex);
             aProvider.Phone = reader.GetSafeString(startingIndex++);
             aProvider.Fax = reader.GetSafeString(startingIndex++);
             string specialization = reader.GetSafeString(startingIndex++);
             if (!string.IsNullOrEmpty(specialization))
             {
                 aProvider.Specializations = JsonConvert.DeserializeObject<List<ProviderSpecializations>>(specialization);
             }
             else
             {
                 return null;
             }
             string language = reader.GetSafeString(startingIndex++);
             if (!string.IsNullOrEmpty(language))
             {
                 aProvider.Languages = JsonConvert.DeserializeObject<List<LookUp>>(language);
             }
             else
             {
                 return null;
             }
             string expertise = reader.GetSafeString(startingIndex++);
             if (!string.IsNullOrEmpty(expertise))
             {
                 aProvider.Expertises = JsonConvert.DeserializeObject<List<LookUp>>(expertise);
             }
             else
             {
                 return null;
             }
             string licenses = reader.GetSafeString(startingIndex++);
             if (!string.IsNullOrEmpty(licenses))
             {
                 aProvider.License = JsonConvert.DeserializeObject<List<LicensesInfo>>(licenses);
             }
             else
             {
                 return null;
             }
             return aProvider;
         }
         #endregion
