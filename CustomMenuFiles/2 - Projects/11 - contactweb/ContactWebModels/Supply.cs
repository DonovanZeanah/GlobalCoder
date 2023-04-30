using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ContactWebModels
{
  public class Supply
  {
    [Key]
    public int Id { get; set; }
    [Display(Name = "Name")]
    [Required(ErrorMessage = "Name is required")]
    public string Name { get; set; }

 
    [Display(Name = "Category")]
    [Required(ErrorMessage = "A category must be assigned")]
    public int CategoryId { get; set; }
    public virtual Category Category { get; set; }

    public double Price { get; set; }
    public int Quantity { get; set; }

    // public int ContactId { get; set; }

    //public virtual List<Contact> Contact { get; set; }
    public virtual ICollection<Source> Sources { get; set; }
    
    [Required(ErrorMessage = "The User ID is required in order to map the contact to a user correctly")]
    public string UserId { get; set; }
  }
}