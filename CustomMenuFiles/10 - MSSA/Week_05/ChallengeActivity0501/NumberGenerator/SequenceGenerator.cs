namespace NumberGenerator
{
    public class SequenceGenerator : INumberGenerator
    {
        public List<int> GenerateNumbers(int length, int start)
        {
            List<int> sequence = new List<int>();
            for (int i = start; i <= length; i++)
            {
                sequence.Add(i);
            }
            return sequence;
        }

        public List<int> GetSequence(int start, int length)
        {
            return GenerateNumbers(length, start);
        }
    }
}
