namespace ObjectOrientedPractice
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var myComputer = new Desktop();
            var myLaptop = new Laptop();
            var myTablet = new Tablet();
            var myCar = new Car();
            var myTelevision = new Television();

            List<Computer> computerList = new List<Computer>(){
                myComputer,
                myLaptop,
                myTablet
            };
            List<Car> carList = new List<Car>() { myCar };
            List<Television> televisionList = new List<Television>() { myTelevision };

            foreach (Computer c in computerList)
            {
                Console.WriteLine(c.PowerOn());
            }
            foreach (Car car in carList)
            {
                Console.WriteLine(car.StartEngine());
            }
            foreach (Television television in televisionList)
            {
                Console.WriteLine(television.TurnTVOn());
            }

            List<IPowerable> powerableList = new List<IPowerable>() {
                myCar, myComputer, myLaptop, myTablet, myTelevision
            };
            foreach (IPowerable powerable in powerableList)
            {
                Console.WriteLine(powerable.TurnOn());
                if (powerable is Computer)
                { 
                    var computer = (Computer)powerable;
                    Console.WriteLine(computer.OverClock());
                }
            }

        }
    }
}