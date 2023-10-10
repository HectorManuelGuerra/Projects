using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WePair.Models;
using WePair.Models.Domain.Provider;
using WePair.Models.Requests.Provider;
using WePair.Services;
using WePair.Services.Interfaces;
using WePair.Web.Controllers;
using WePair.Web.Models.Responses;
using System;
using Microsoft.AspNetCore.Authorization;

namespace WePair.Web.Api.Controllers
{
    [Route("api/providers/")]
    [ApiController]
    public class ProviderAPIController : BaseApiController
    {
        private IAuthenticationService<int> _authService = null;
        private IProvidersService _providerService = null;
        public ProviderAPIController(IProvidersService service, ILogger<ProviderAPIController> logger, IAuthenticationService<int> authService) : base(logger)
        {
            _authService = authService;
            _providerService = service;
        }

        [HttpPost]
        public ActionResult<SuccessResponse> CreateProvider(ProviderAddRequest model)
        {
            int code = 200;
            BaseResponse response = null;
            try
            {
                int userId = _authService.GetCurrentUserId();
                var result = _providerService.Add(model, userId);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
            }
            return StatusCode(code, response);
        }
        [AllowAnonymous]
        [HttpGet("showAll")]
        public ActionResult<ItemResponse<Paged<ProviderInfo>>> SelectAll_Paginated(int pageIndex, int pageSize)
        {
            ActionResult result = null;
            try
            {
                Paged<ProviderInfo> paged = _providerService.PaginateProviders(pageIndex, pageSize);
                if (paged == null)
                {
                    result = NotFound404(new ErrorResponse("Records Not Found"));
                }
                else
                {
                    ItemResponse<Paged<ProviderInfo>> response = new ItemResponse<Paged<ProviderInfo>> { Item = paged };
                    result = Ok200(response);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex.ToString());
                result = StatusCode(500, new ErrorResponse(ex.Message.ToString()));
            }
            return result;
        }
        [AllowAnonymous]
        [HttpGet("{id:int}")]
        public ActionResult<ItemResponse<ProviderInfo>> Get(int id)
        {
            int iCode = 200;
            BaseResponse response = null;

            try
            {
                ProviderInfo provider = _providerService.GetProviderDetailsById(id);

                if (provider == null)
                {
                    iCode = 404;
                    response = new ErrorResponse("Application Resource not found.");
                }
                else
                {
                    response = new ItemResponse<ProviderInfo> { Item = provider };
                }
            }
            catch (Exception ex)
            {

                iCode = 500;
                base.Logger.LogError(ex.ToString());
                response = new ErrorResponse($"Generic Error: {ex.Message}");
            }

            return StatusCode(iCode, response);

        }
    }
}
