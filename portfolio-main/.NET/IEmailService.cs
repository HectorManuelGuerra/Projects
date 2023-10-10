using WePair.Models.Requests.Email;
using Task = System.Threading.Tasks.Task;

namespace WePair.Services.Interfaces
{
    public interface IEmailService
    {
        Task ContactUs(ContactUsRequest model);
        Task Confirmation(ContactUsRequest model);
    }
}
