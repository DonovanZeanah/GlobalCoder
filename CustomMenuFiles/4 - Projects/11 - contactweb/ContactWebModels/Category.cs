using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ContactWebModels
{
  public class Category
  {
    [Key]
    public int Id { get; set; }

    [Display(Name = "Category")]
    [Required(ErrorMessage = "Name of category is required")]
    [StringLength(ContactManagerConstants.MAX_CATEGORY_NAME_LENGTH)]
    public string Name { get; set; }

    
  }
}
