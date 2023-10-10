using System.ComponentModel.DataAnnotations;

namespace WePair.Models.Requests.Email
{
    public class ContactUsRequest : EmailAddRequest
    {
        [Required]
        [StringLength(50, MinimumLength = 2)]
        public string FirstName { get; set; }
        
        [Required]
        [StringLength(50, MinimumLength = 2)]
        public string LastName { get; set; }
        
        public string getFullName()
        {
            return $"{FirstName}  {LastName}";
        }
    }
}
