namespace ObjectOrientedPractice
{
    public class Tablet : Laptop
    {
        public string ScreenSize()
        {
            return "my screen is 11.6";
        }

        public override string PerformOverclock()
        {
            return "Cannot overclock a tablet!";
        }
    }
}
