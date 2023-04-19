using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UserInputAndValidation
{
    public enum MenuOption
    { 
        Add = 1, Update = 2, Delete = 3, List = 4
    };

    public static class Menu
    {
        public const string TITLE = "Inventory Manager";
        public const string ITEM = "Media";
        public const string ITEM_PLURAL = "Media Items";

        public static void PrintMenu()
        {
            InputValidation.PrintStars();
            InputValidation.PrintStringToUser($"* Welcome to the {TITLE} System");
            InputValidation.PrintStars();
            InputValidation.PrintStringToUser($"* Options:");
            InputValidation.PrintStringToUser($"* {(int)MenuOption.Add}] {MenuOption.Add} {ITEM}");
            InputValidation.PrintStringToUser($"* {(int)MenuOption.Update}] {MenuOption.Update} {ITEM}");
            InputValidation.PrintStringToUser($"* {(int)MenuOption.Delete}] {MenuOption.Delete} {ITEM}");
            InputValidation.PrintStringToUser($"* {(int)MenuOption.List}] {MenuOption.List} {ITEM_PLURAL}");
            InputValidation.PrintStars();
        }
    }
}
