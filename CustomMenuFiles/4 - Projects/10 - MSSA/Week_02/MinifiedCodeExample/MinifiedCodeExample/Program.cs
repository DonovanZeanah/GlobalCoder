using MinifiedCodeExample;


/*
var name = GetUserInputAsString("Please give me your name");
var color = GetUserInputAsString("Please tell me your favorite color");
Console.WriteLine(name);
Console.WriteLine(color);

var myPerson = new Person();
myPerson.Name = name;
myPerson.Color = color;

var anotherPerson = myPerson.Clone();

var anotherPerson2 = myPerson;
var myPerson2 = new Person();
myPerson2.Name = name;
myPerson2.Color = myPerson.Color;

Console.WriteLine($"Before: {myPerson}");
AffectPerson(anotherPerson);
Console.WriteLine($"After: {myPerson}");
*/

//var myPerson2 = new Person(name, color);
////Console.WriteLine(myPerson.Name);

////Console.WriteLine(myPerson);
//Console.WriteLine(myPerson.ToString());
//Console.WriteLine(myPerson2.ToString());

//Console.WriteLine(myPerson.PerformActionRun());
//Console.WriteLine(myPerson.PerformActionRun(3.0));



//var vin = GetUserInputAsString("What is the VIN Number?");
//var make = GetUserInputAsString("What is the Make?");
//var model = GetUserInputAsString("What is the Model?");

//var v1 = new Vehicle();
//v1.VIN = vin;
//v1.Make = make;
//v1.Model = model;
//var v2 = new Vehicle(vin, make, model);

//Console.WriteLine(v1);
//Console.WriteLine(v2);

//Console.WriteLine(v1.HonkTheHorn());
//Console.WriteLine(v2.HonkTheHorn(2));


/* 
Practice: 
Create an enumeration for intensity of the honk
Values: Light, Medium, Hard [or whatever you want]
Integrate the honking enumeration into the Vehicle Honk Method and switch
Use the enumeration in the call(s) to honk the horn
*/

/*
var myKVP = new KVP();
myKVP.value = "Yellow";
myKVP.key = 10;
Console.WriteLine($"Before method call: {myKVP}");
AffectKVP(myKVP);  //by ref? or by val?
Console.WriteLine($"After method call: {myKVP}");

//var myNextKVP = new KVP(20, "BLUE");
//Console.WriteLine(myKVP);
//Console.WriteLine(myNextKVP);

int x = 10;
int y = 20;
Console.WriteLine($"Value of x before method: {x}");
Console.WriteLine($"Value of y before method: {y}");

//will this change x && y?
var answer = AddTwoNumbers(x, y);
Console.WriteLine(answer);

Console.WriteLine($"Value of x after method: {x}");
Console.WriteLine($"Value of y after method: {y}");

//will this change x && y?
var answer2 = AddTwoNumbersByRef(ref x, ref y);
Console.WriteLine(answer2);

Console.WriteLine($"Value of x after method: {x}");
Console.WriteLine($"Value of y after method: {y}");
*/
Person p = new Person("Adam", "Blue", 23);
Worker w = new Worker();
w.FirstName = "Susan";
w.LastName = "Thomas";
w.Age = 37;
w.Color = "Red";
w.Salary = 256432.23;
Worker w2 = new Worker("John", "Orange", 62, 234532.25);
p.SetFullName("Greg John");


Student s = new Student();
s.FirstName = "Tim";
s.LastName = "Johnson";
s.Age = 56;
s.Color = "Green";
s.Major = "Accounting";
Student s2 = new Student("Mandy", "Purple", 22, "Political Science");
/****




Console.WriteLine(p);
Console.WriteLine(w);
Console.WriteLine(s);
Console.WriteLine(w2);
Console.WriteLine(s2);
Console.WriteLine(p.PerformActionRun());
Console.WriteLine(w.PerformActionRun());
Console.WriteLine(s.PerformActionRun(3));
Console.WriteLine(w2.PerformActionRun());
Console.WriteLine(s2.PerformActionRun());

//polymorphism
//write code once and work against any object
//int[] myNumbers = new int[5];
//myNumbers[0] = 10;
//myNumbers[1] = 20;
//myNumbers[2] = "asdf";

List<Person> people = new List<Person>();
people.Add(p);
people.Add(w);
people.Add(s);

foreach (var personData in people)
{
    Console.WriteLine($"Person: {personData}");
    Console.WriteLine(personData.PerformActionRun());
    Console.WriteLine(personData.PerformActionRun(3));

    if (personData is Student)
    {
        var s0 = (Student)personData;
        Console.WriteLine($"{s0.GetFullName()} is a student with Major: {s0.Major}");
    }
    if (personData is Worker)
    {
        var w0 = (Worker)personData;
        Console.WriteLine($"{w0.GetFullName()} is a Worker with salary: {w0.Salary}");
    }
}
****/

var remote1 = new UniversalRemote();
var remote2 = new AdvancedRemote();

List<IRemote> remotes = new List<IRemote>();
remotes.Add(remote1);
remotes.Add(remote2);

foreach (var r in remotes)
{
    r.PowerOn();
    r.ChangeChannel(16);
    r.ChangeVolume(45);
    r.PowerOff();
}


IRemote remoteNew = new UniversalRemote();
IEnumerable<string> strings = new List<string>();

List<ICommonPrint> printables = new List<ICommonPrint>();
printables.Add(remote1);
printables.Add(remote2);
printables.Add(p);
printables.Add(w);
printables.Add(s);
printables.Add(w2);
printables.Add(s2);

foreach (var printable in printables)
{
    if (printable is Worker)
    {
        Console.WriteLine($"Salary: {((Worker)printable).Salary}");
    }
    Console.WriteLine(printable.PrintSomething());
}

static string GetUserInputAsString(string message)
{
    bool continueLooping = true;
    string input = string.Empty;
    while (continueLooping)
    {
        Console.WriteLine(message);
        input = Console.ReadLine() ?? string.Empty;

        Console.WriteLine(input);
        Console.WriteLine($"Is {input} what you intended to write?");

        string confirmation = Console.ReadLine() ?? string.Empty;

        if (confirmation.ToLower().StartsWith("y"))
        {
            //Console.WriteLine($"You wrote {input}. So proud of you!");
            continueLooping = false;
        }
        else if (confirmation.ToLower().StartsWith("n"))
        {
            Console.WriteLine("Please try again");
        }
        else
        {
            Console.WriteLine("Invalid input, please try again");
        }
    } while (continueLooping);

    return input;
}

static int AddTwoNumbers(int a, int b)
{
    a = a * 2;
    b = b * 4;
    Console.WriteLine($"Value of a in method: {a}");
    Console.WriteLine($"Value of b in method: {b}");

    return a + b;
}

static int AddTwoNumbersByRef(ref int a, ref int b)
{
    a = a * 2;
    b = b * 4;
    Console.WriteLine($"Value of a in method: {a}");
    Console.WriteLine($"Value of b in method: {b}");

    return a + b;
}

static void AffectKVP(KVP myKVPa)
{
    myKVPa.key = 234234;
    myKVPa.value = "Affected by the method";
    Console.WriteLine($"In Method: {myKVPa}");
}

static void AffectPerson(Person p)
{
    p.FirstName = "James";
    p.LastName = "Bond";
    p.Color = "Black";
    Console.WriteLine($"In Method: {p}");
}

public struct KVP
{
    public int key;
    public string value;
    public bool isActive;

    public KVP()
    {
        key = 0;
        value = "";
        isActive = true;
    }

    public KVP(int inKey, string inValue)
    {
        key = inKey;
        value = inValue;
        isActive = true;
    }

    public override string ToString()
    {
        return $"{key}  | {value}";
    }
}


