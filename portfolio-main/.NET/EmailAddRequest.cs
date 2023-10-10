using System.ComponentModel.DataAnnotations;

namespace WePair.Models.Requests.Email
{
    public class EmailAddRequest
    {
        [Display(Name = "Email address")]
        [Required(ErrorMessage = "The email address is required")]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string From { get; set; }

        [Required(ErrorMessage = "A Subject must be provided")]
        [StringLength(100, MinimumLength = 2)]
        public string Subject { get; set; }
    }
}
