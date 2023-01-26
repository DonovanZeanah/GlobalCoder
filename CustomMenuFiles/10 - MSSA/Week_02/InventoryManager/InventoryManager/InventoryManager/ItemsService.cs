using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserInputAndValidation;

namespace InventoryManager
{
    public class ItemsService
    {
        public void Add()
        {
            InputValidation.PrintStringToUser("Adding...");
        }
        public void Update()
        {
            InputValidation.PrintStringToUser("Updating...");
        }
        public void Delete()
        {
            InputValidation.PrintStringToUser("Deleting...");
        }

        public void List()
        {
            InputValidation.PrintStringToUser("Listing...");
        }

    }
}
