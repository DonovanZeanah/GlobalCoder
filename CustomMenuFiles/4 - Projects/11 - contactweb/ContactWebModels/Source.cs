using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContactWebModels
{
  public class Source
  {
    [Key]
    public int Id { get; set; }
    [Required]
    public string UserId { get; set; }
    public int SupplyId { get; set; }
    public int ContactId { get; set; }
    public virtual Supply? Supply { get; set; }
    public virtual Contact? Contact { get; set; }

  }
}
