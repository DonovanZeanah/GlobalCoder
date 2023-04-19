using Microsoft.Extensions.Configuration;

namespace SlidingWindowArrayCalculation
{
    public class Program
    {
        private static IConfigurationRoot _configuration;
        

        public static void Main(string[] args)
        {
            Random r = new Random();

            int[] theData = new int[20];
            for (int i = 0; i < 20; i++)
            {
                theData[i] = r.Next(200);
            }

            Dictionary<int, int> slidingWindowSums = new Dictionary<int, int>();
            int right = 0;
            int left = 0;
            string rightIndex = string.Empty;
            for (int i = 0; i < theData.Length; i++)
            {
                left = theData[i];
                if (i == theData.Length - 1)
                {
                    right = theData[0];
                    rightIndex = "0";
                }
                else
                {
                    right = theData[i + 1];
                    rightIndex = (i + 1).ToString();
                }
                int sum = left + right;
                Console.WriteLine($"index[{i}] + index[{rightIndex}] = {left} + {right} = {sum}");
                slidingWindowSums.Add(i, sum);
            }

            foreach (var k in slidingWindowSums.Keys)
            {
                var sum = slidingWindowSums[k];
                left = theData[k];
                if (k == theData.Length - 1)
                {
                    right = theData[0];
                    rightIndex = "0";
                }
                else
                {
                    right = theData[k + 1];
                    rightIndex = (k + 1).ToString();
                }
                Console.WriteLine($"Dictionary: index[{k}] + index[{rightIndex}] = {left} + {right} = {sum}");
            }
            
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
