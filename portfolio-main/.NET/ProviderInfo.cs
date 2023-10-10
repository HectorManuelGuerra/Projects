using WePair.Models.Domain.Users;
using System.Collections.Generic;

namespace WePair.Models.Domain.Provider
{
    public class ProviderInfo
    {
            public int Id { get; set; }
            public LookUp Tittle { get; set; }
            public BaseUser UserData { get; set; }
            public LookUp Gender { get; set; }
            public long NPI { get; set; }
            public LookUp GenderAccepted { get; set; }
            public string Phone { get; set; }
            public string Fax { get; set; }
            public List<ProviderSpecializations> Specializations { get; set; }
            public List<LookUp> Languages { get; set; }
            public List<LookUp> Expertises { get; set; }
            public List<LicensesInfo> License { get; set; }
        }

    }
