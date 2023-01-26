using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ContactWebEFCore6.Models
{
    public class UserAdminViewModel
    {
        [EmailAddress]
        public string Email { get; set; }
        [PasswordPropertyText]
        public string Password { get; set; }
        [PasswordPropertyText]
        public string PasswordConfirmed { get; set; }
        public string PasswordPhrase { get; set; }

        //add additional fields later as needed
    }
}
