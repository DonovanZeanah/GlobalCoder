^1::Func_MainMenu()

Func_MainMenu(){
Menu, MainMenu, Add, MainMenu. Goto SubMenu1., Func_SubMenu1
Menu, MainMenu, Add, MainMenu. Goto SubMenu2., Func_SubMenu2
Menu, MainMenu, Show
}

Func_SubMenu1(){
    Menu, SubMenu1, Add, SubMenu1. Item 1, Func_Msgbox
    Menu, SubMenu1, Add, SubMenu1. Item 2, Func_Msgbox
    Menu, SubMenu1, Add, Go back to Main Menu, Func_MainMenu
    Menu, SubMenu1, Show
}

Func_SubMenu2(){
    Menu, SubMenu2, Add, SubMenu2. Item 1, Func_Msgbox
    Menu, SubMenu2, Add, Go back to Main Menu, Func_MainMenu
    Menu, SubMenu2, Add, SubMenu2. Item 3, Func_Msgbox
    Menu, SubMenu2, Show
}

Func_Msgbox() {
    Msgbox %A_ThisMenu%: You have clicked Item #%A_ThisMenuItemPos%
    if A_ThisMenuItemPos = 1
        msgbox This additional msgbox always plays on Item1 regardless of selected SubMenu
    if (A_ThisMenu = "Submenu2") and (A_ThisMenuItemPos = 3)
        msgbox This additional msgbox only plays on SubMenu2 and on Item 3
}

esc::Reload
^esc::exitapp

public class Program

{
static void Main(string[£] args)
{
Console .WriteLinaCAddTroNums(2, 5));
f/var seq = new SequenceGenerator();
IGenerateSequence ng = new Se uenceGenerator();
var seqlist = ng .GetSequence(160, 8);
AddSeqhums(seqList);
AddAndPrintSequence(seqList);
//var rSeq = new RandonGenerator();
ng = new RandomGenerator();
var randList = ng.GetSequence(15);
SortList(randList) ;
AddSeqNums(randList);
}
private static void AddAndPrintSequence(List<int> seqList)
{
var next = 9;
var previous = 6;
foreach (var iten in seqlist)
{
next = item;
Console.WriteLine($"nl: {next} | n2: {previous} | result: {AddTwoNums(next, previous)}");
previous = next;
}
}
static void AddSeqNuns(List<int> lst)
{
for (int i = 1; i < Ust.Count; i++)
{
int nl = Ust{i - 1];
int n2 = Ust[i);
Console.WriteLine($"nl: {ni} [| n2: {n2} | result: {AddTwoNums(n1, n2)}");
}
}
static int AddTwoNumsCint num1, int nun2)
{
return nugl + nun2;
}
static void SortList(List<int> Lst)
{
Ust.Sort((a, b) => b.ConpareTo(a));
}
















INunberGenerator i =jfow TNumberGenerator ;
var randomData = RandonGenerator .GetRandomSequence: 18) ;




Could we go over some of the 'quicker' ways of going through the challenge? I know I sort of "started in the middle" of the instructions like a couple of other people, and ultimately overwhelmed/confused myself. But I still think? the way of going about it in the shorthand methodology wasn't completely wrong