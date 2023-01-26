namespace ValidationStub
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Hello");

            var continueLooping = true;
            while(continueLooping)
            { 
            
            
                //get input from the user
                var newValidator = new ValidationInterop();
                var result = newValidator.GetInputFromUserAsString("What is your favorite food?");
                Console.WriteLine(result);


                var choice = newValidator.GetInputFromUserAsString("Would you like to continue?", false);
                if (choice.ToLower().StartsWith('n'))
                {
                    continueLooping = false;
                }

                var choice = newValidator.GetInputFromUserAsString("Would you like to continue?", false, "asdfasdf");
            }


            //check if they want to do it all again
        }
    }
}