using Microsoft.Extensions.Configuration;

namespace TryCatchFinally
{
    public class Program
    {
        private static IConfigurationRoot _configuration;

        public static void Main(string[] args)
        {
            BuildOptions();
            Console.WriteLine("Hello World");

            //SqlConnection cn1;
            try
            {
                Console.WriteLine("Please enter a double");
                double value = Convert.ToDouble(Console.ReadLine());

                //cn1.Open();

            }
            catch (Exception ex)
            {
                //most generic exception

                Console.WriteLine("Hey, give me better data!");
                //don't show the world to the user:
                Console.WriteLine(ex.Message);

                //log important info
                //_logger.log(ex.ToString());
            }
            finally
            {

                //used when you need to do something every single time
                Console.WriteLine("In the finally block!");

                //cn1.close();
            }

            try
            {
                Console.WriteLine("Please enter a double");
                double value = Convert.ToDouble(Console.ReadLine());
                double denominator = 0.0;
                var result = value / denominator;
                //int denominator = 0;
                //var result = 100 / denominator;
                if (result == double.PositiveInfinity
                                || result == double.NegativeInfinity)
                {
                    throw new ArithmeticException("Cannot divide by zero");
                }
            }
            catch (NotImplementedException nex)
            {
                //nex
            }
            catch (ArithmeticException aex)
            {
                //don't show the world to the user:
                Console.WriteLine(aex.Message);
                try
                {

                    //throw;
                    throw new Exception("Sorry");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Now it works!");
                    //throw;
                }
                finally
                {
                    Console.WriteLine("Inner finally");
                }
            }
            catch (FileNotFoundException fnfex)
            { 
                
            }
            catch (Exception ex)
            {
                //don't show the world to the user:
                Console.WriteLine(ex.Message);

                //log important info
                Console.WriteLine(ex.ToString());

                //throw;
            }
            finally
            {
                Console.WriteLine("In finally block");
            }


            Console.WriteLine("Please press any key to exit");
            Console.ReadKey();
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
