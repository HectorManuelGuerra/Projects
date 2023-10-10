using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WePair.Models.Requests.Email;
using WePair.Services.Interfaces;
using WePair.Web.Controllers;
using WePair.Web.Models.Responses;
using System;

namespace WePair.Web.Api.Controllers.Temp
{
    [Route("api/email")] 
    [ApiController]
    public class EmailApiController : BaseApiController
    {
        private IEmailService _emailService;
        public EmailApiController(IEmailService emailService, ILogger<EmailApiController> logger) : base(logger)
        {        
            _emailService = emailService;
        }

        [HttpPost("contactUs")]
        public ActionResult<SuccessResponse> ContactUsEmail([FromBody] ContactUsRequest model)
        {
            int code = 200;
            BaseResponse response = null;
            try
            {
                _emailService.ContactUs(model);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
            }
            return StatusCode(code, response);
        }

        [HttpPost("confirmation")]
        public ActionResult<SuccessResponse> ConfirmationEmail([FromBody] ContactUsRequest model)
        {
            int code = 200;
            BaseResponse response = null;
            try
            {
                _emailService.Confirmation(model);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
            }
            return StatusCode(code, response);
        }
    }               
}
