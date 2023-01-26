using ContactWebEFCore6.Data;
using Microsoft.AspNetCore.Identity;
using System.Runtime.InteropServices;

namespace ContactWebModels.Data
{
  public class UserRolesService : IUserRolesService
  {
    private readonly UserManager<ContactWebUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;
    public UserRolesService(UserManager<ContactWebUser> userManager, RoleManager<IdentityRole> roleManager)
    {
      _userManager = userManager;
      _roleManager = roleManager;
    }

    public async Task CreateRole(string roleName)
    {
      var existingRole = await _roleManager.FindByNameAsync(roleName);
      if (existingRole is not null) return;

      var adminRole = new IdentityRole()
      {
        Name = roleName,
        NormalizedName = roleName.ToUpper()
      };
      await _roleManager.CreateAsync(adminRole);
    }

    public async Task CreateUser(string email, string userName, string password, string phone)
    {
      var existingAdminUser = await _userManager.FindByEmailAsync(userName);
      if (existingAdminUser is not null) return;
      
      var user = new ContactWebUser()

      {
        Email = email,
        EmailConfirmed = true,
        UserName = userName,
        NormalizedEmail = email.ToUpper(),
        NormalizedUserName = userName.ToUpper(),
        LockoutEnabled = false,
        //password = extra work
        PhoneNumber = phone

      };

      await _userManager.CreateAsync(user, password);

      //user = await _userManager.FindByEmailAsync(email);
      //var token = await _userManager.GetPasswordResetTokenAsync(user);
     // var result = await _userManager.ResetPasswordAsync(user, token, password);
    }

    public async Task AssociateUserToRole(string roleName, string email)
    {
      var existingUser = await _userManager.FindByEmailAsync(email);
      var existingRole = await _roleManager.FindByNameAsync(roleName);
      if (existingUser is null || existingRole is null)
      {
        throw new InvalidOperationException("Cannot add null user/role combination");
      }
      var userRoles = await _userManager.GetRolesAsync(existingUser);

      var existingUserRole = userRoles.SingleOrDefault(x => x.Equals(roleName));

      if (existingUserRole is not null) return;
      await _userManager.AddToRoleAsync(existingUser, roleName);
      


    }

        public Task AssociateUserToRole(string roleName, ContactWebUser user)
        {
            throw new NotImplementedException();
        }

        public Task CreateUser(ContactWebUser user)
        {
            throw new NotImplementedException();
        }

    public const string ADMIN_ROLE_NAME = "Admin";
    public const string ADMIN_USER_EMAIL = "dkzeanah@gmail.com";
      public const string ADMIN_USER_PWD = "Fascinating#1!";
    public const string SUPERADMIN_ROLE_NAME = "SuperAdmin";
    public const string SUPERADMIN_USER_EMAIL = "donovan.zeanah@outlook.com";
    public const string SUPERADMIN_USER_PWD = "Blasterball8!";
    public async Task EnsureSuperUser()
        {
      await CreateUser(ADMIN_USER_EMAIL, ADMIN_USER_EMAIL, ADMIN_USER_PWD, "1800STRULES");
      await CreateRole(ADMIN_ROLE_NAME);
      await AssociateUserToRole(ADMIN_ROLE_NAME, ADMIN_USER_EMAIL);

      await CreateUser(SUPERADMIN_USER_EMAIL, SUPERADMIN_USER_EMAIL, SUPERADMIN_USER_PWD, "1800STRULES");
      await CreateRole(SUPERADMIN_ROLE_NAME);
      await AssociateUserToRole(SUPERADMIN_ROLE_NAME, SUPERADMIN_USER_EMAIL);
    }

        /*
         * public async Task CreateRole(string roleName)
        {
            var existingRole = await _roleManager.FindByNameAsync(roleName);
            if (existingRole is not null) return;

            var adminRole = new IdentityRole()
            {
                Name = roleName,
                NormalizedName = roleName.ToUpper()
            };
            await _roleManager.CreateAsync(adminRole);
        }

        public async Task CreateUser(string email, string userName, string password, string phone)
        {
            var existingAdminUser = await _userManager.FindByEmailAsync(userName);
            if (existingAdminUser is not null) return;

            var user = new ContactWebUser()
            {
                Email = email,
                EmailConfirmed = true,
                UserName = userName,
                NormalizedEmail = email.ToUpper(),
                NormalizedUserName = userName.ToUpper(),
                LockoutEnabled = false,
                PhoneNumber = phone
            };
            await _userManager.CreateAsync(user, password);

            //user = await _userManager.FindByEmailAsync(email);
            //var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            //var result = await _userManager.ResetPasswordAsync(user, token, password);
        }

        public async Task AssociateUserToRole(string roleName, string email)
        {
            var existingUser = await _userManager.FindByEmailAsync(email);
            var existingRole = await _roleManager.FindByNameAsync(roleName);

            if (existingUser is null || existingRole is null)
            {
                throw new InvalidOperationException("Cannot add  null user/role combination");
            }

            var userRoles = await _userManager.GetRolesAsync(existingUser);
            var existingUserRole = userRoles.SingleOrDefault(x => x.Equals(roleName));

            if (existingUserRole is not null) return;

            await _userManager.AddToRoleAsync(existingUser, roleName);
        }

        public const string ADMIN_ROLE_NAME = "Admin";
        private const string ADMIN_USER_EMAIL = "spock@ncc1701.com";
        private const string ADMIN_USER_PWD = "Fascinating#1!";
        public const string SUPERADMIN_ROLE_NAME = "SuperAdmin";
        private const string SUPERADMIN_USER_EMAIL = "kirk@ncc1701.com";
        private const string SUPERADMIN_USER_PWD = "OverActing#1!";

        public async Task EnsureSuperUser()
        {
            await CreateUser(ADMIN_USER_EMAIL, ADMIN_USER_EMAIL, ADMIN_USER_PWD, "1800STRULES");
            await CreateRole(ADMIN_ROLE_NAME);
            await AssociateUserToRole(ADMIN_ROLE_NAME, ADMIN_USER_EMAIL);

            await CreateUser(SUPERADMIN_USER_EMAIL, SUPERADMIN_USER_EMAIL, SUPERADMIN_USER_PWD, "1800STRULES");
            await CreateRole(SUPERADMIN_ROLE_NAME);
            await AssociateUserToRole(SUPERADMIN_ROLE_NAME, SUPERADMIN_USER_EMAIL);
        }
        */
    }
}