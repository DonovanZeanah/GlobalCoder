namespace NumberGenerator
{
    public interface INumberGenerator
    {
        List<int> GenerateNumbers(int length, int start = 0);
    }
}
