using System.ComponentModel.DataAnnotations;

namespace WePair.Models.Requests.Email
{
    public class ConfirmEmailRequest
    {
        [Required]
        [EmailAddress]
        [StringLength(255, MinimumLength = 2)]
        public string Email { get; set; }

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
