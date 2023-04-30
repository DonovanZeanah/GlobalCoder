namespace BalancedStringCheckUtility
{
    public class BalancedStringCheck
    {
        public const string validChars = "(){}[]";

        public bool IsBalancedStringList(string s)
        {
            List<char> input = new List<char>();

            foreach (var c in s)
            {
                if (validChars.Contains(c))
                {
                    input.Add(c);
                }
            }
            char[] characters = new char[input.Count];

            input.CopyTo(characters);
            List<char> reversed = characters.ToList();
            reversed.Reverse();

            for (int i = 0; i < input.Count; i++)
            {
                var a = input[i];
                var b = reversed[i];
                if (!IsPartnerCharacter(a, b))
                {
                    return false;
                }
            }

            return true;
        }

        public bool IsBalancedStringStack(string s)
        {
            Stack<char> input = new Stack<char>();
            Stack<char> output = new Stack<char>();

            foreach (var c in s)
            {
                if (validChars.Contains(c))
                {
                    //Patrick's solution would be better here
                    //if it's open, push, if it's close, pop
                    //if you get unbalanced (end of stack, invalid pop char, return false)
                    input.Push(c);
                }
            }

            //creates a cloned stack in reverse order [pop/push]
            output = new Stack<char>(input);

            for (int i = 0; i < input.Count; i++)
            {
                var a = input.Pop();
                var b = output.Pop();

                if (!IsPartnerCharacter(a, b))
                {
                    return false;
                }
            }

            return true;
        }

        private static bool IsPartnerCharacter(char a, char b)
        {
            switch (a)
            {
                case '(':
                    return b.Equals(')');
                case '{':
                    return b.Equals('}');
                case '[':
                    return b.Equals(']');
                case ')':
                    return b.Equals('(');
                case ']':
                    return b.Equals('[');
                case '}':
                    return b.Equals('{');
                default:
                    return true;
            }
        }

    }
}