using Microsoft.AspNetCore.Identity;

namespace ContactWebEFCore6.Data
{
    public interface IUserRolesService
    {
        Task AssociateUserToRole(string roleName, string email);
        Task CreateRole(string roleName);
        Task CreateUser(string email, string userName, string password, string phone);
        Task EnsureSuperUser();
    }
}
