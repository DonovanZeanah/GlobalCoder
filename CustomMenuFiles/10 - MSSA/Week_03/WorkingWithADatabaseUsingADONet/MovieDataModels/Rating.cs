using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace MovieDataModels
{
    public class Rating
    {
        public int Id { get; set; }
        [Display(Name = "Rating")]
        public string RatingValue { get; set; }
        public string Description { get; set; }
        public virtual List<Movie> Movies { get; set; } = new List<Movie>();
    }
}
