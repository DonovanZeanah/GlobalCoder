namespace NumberGenerator
{
    public class RandomGenerator : INumberGenerator
    {
        public List<int> GenerateNumbers(int length, int start = 0)
        {
            Random r = new Random();
            List<int> sequence = new List<int>();
            for (int i = 0; i < length; i++)
            {
                sequence.Add(r.Next(1, 10000));
            }
            return sequence;
        }

        public List<int> GetSequence(int length)
        {
            return GenerateNumbers(length);
        }
    }
}
