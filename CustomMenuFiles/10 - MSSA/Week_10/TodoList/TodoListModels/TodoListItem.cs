using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TodoListModels
{
    public enum ItemStatus { 
        NotStarted = 0,
        InProgress = 1,
        Completed = 2,
        Abandoned = 3,
        OnHold = 4
    };

    public class TodoListItem
    {
        [Required]
        public int Id { get; set; }

        [Required]
        [Display(Name = "Details")]
        [StringLength(255)]
        public string DetailText { get; set; }

        public bool IsCompleted { get; set; }

        public ItemStatus Status { get; set; }

        public DateTime? CompletedDate { get; set; }

        [EmailAddress]
        [StringLength(255)]
        public string? ModifiedByEmail { get; set; }
    }
}
