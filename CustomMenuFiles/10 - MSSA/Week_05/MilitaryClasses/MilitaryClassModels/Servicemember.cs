namespace MilitaryClassModels
{
    public class Servicemember : Person
    {
        public string Branch { get; set; }
        public string Rank { get; set; }
        public int YearsOfService { get; set; }

        public override double Calculate(double x, double y)
        {
            return x * y;
        }

        public override string ToString()
        {
            return $"{base.ToString()} | Branch: {Branch} | Rank: {Rank} | YearsOfService: {YearsOfService}";
        }
    }
}