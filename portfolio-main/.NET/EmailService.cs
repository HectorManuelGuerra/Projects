using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Options;
using WePair.Models.AppSettings;
using WePair.Models.Requests.Email;
using WePair.Services.Interfaces;
using sib_api_v3_sdk.Api;
using sib_api_v3_sdk.Client;
using sib_api_v3_sdk.Model;
using System.Collections.Generic;
using System.IO;
using Task = System.Threading.Tasks.Task;

namespace WePair.Services
{
    public class EmailService : IEmailService
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private AppKeys _appKeys;
        private readonly AppConfig _appConfig;
        public EmailService(IWebHostEnvironment webHostEnvironment, IOptions<AppKeys> appKeys, IOptions<AppConfig> appConfig)
        {
            _webHostEnvironment = webHostEnvironment;
            _appKeys = appKeys.Value;
            _appConfig = appConfig.Value;
            Configuration.Default.ApiKey.Add("api-key", _appKeys.SendInBlueKey);
         
        }
        public async Task ContactUs(ContactUsRequest model)
        {
            var apiInstance = new TransactionalEmailsApi();
            var emailSender = new SendSmtpEmailSender(model.getFullName(), model.From);
            var toRecipient = new SendSmtpEmailTo("hectorguerra587+1@gmail.com", "WePairHealth");          
                  
            var smtpEmailTo = new List<SendSmtpEmailTo> { toRecipient };

            var templatePath = Path.Combine(_webHostEnvironment.ContentRootPath, "wwwroot", "EmailTemplates", "Template.html");
            var htmlContent = await File.ReadAllTextAsync(templatePath);
                  
            var sendSmtpEmail = new SendSmtpEmail(emailSender, smtpEmailTo)       
            {        
                Subject = model.Subject,   
                HtmlContent = htmlContent.Replace("{{params.fullName}}", model.getFullName())     
            };   

            await SendEmailAsync(sendSmtpEmail);
        }
        public async Task Confirmation(ContactUsRequest model)
        {
            var emailSender = new SendSmtpEmailSender(model.getFullName(), model.From);
            var touserRecipient = new SendSmtpEmailTo("hectorguerra587+1@gmail.com", "WePairHealth");
             
            var userSmtpEmailTo = new List<SendSmtpEmailTo> { touserRecipient };

            var userTemplatePath = Path.Combine(_webHostEnvironment.ContentRootPath, "wwwroot", "EmailTemplates", "ConfirmationTemplate.html");
            var userHtmlContent = await File.ReadAllTextAsync(userTemplatePath);

            var userSendSmtpEmail = new SendSmtpEmail(emailSender, userSmtpEmailTo)
            {
                Subject = model.Subject,
                HtmlContent = userHtmlContent.Replace("{{params.fullName}}", model.getFullName())
            };

            await SendEmailAsync(userSendSmtpEmail);
        }        
        
        private async Task SendEmailAsync(SendSmtpEmail email)
        {
            var apiInstance = new TransactionalEmailsApi();
            CreateSmtpEmail result = await apiInstance.SendTransacEmailAsync(email);
        }
    }
}
