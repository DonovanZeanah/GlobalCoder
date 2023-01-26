using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace ContactWebEFCore6.Data
{
  public class ContactWebUser : IdentityUser
  {
    //overridden the user, no extra properties

    [StringLength(255)]
    public string? PasswordPhrase { get; set; }

  }
}