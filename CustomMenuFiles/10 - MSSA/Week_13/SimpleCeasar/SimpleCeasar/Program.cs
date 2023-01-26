using Microsoft.Extensions.Configuration;

namespace SimpleCaesar
{


    public class Program
    {
        private static IConfigurationRoot _configuration;

        private static int shift = 0;
        private static string _pwd1 = string.Empty;
        private static string _pwd2 = string.Empty;
        private static string _pwd3 = string.Empty;

        public static void Main(string[] args)
        {
            BuildOptions();
            SetVariables();
            Console.WriteLine("Hello World");

            //Get the shift value:
            
            var success = false;
            while (!success)
            {
                Console.WriteLine("What is the encryption shift?");
                success = int.TryParse(Console.ReadLine(), out shift);
            }

            //only 26 possible values in range, any numbers larger should be set to equivalent
            if (shift > 26) {
                shift = shift % 26;
            }

            CaesarShift.RunCaesar(shift);

            CaesarFileEncryption.EncryptFileContents(shift);

            CaesarFileEncryption.EncryptEntireFiles(shift);

            var result1 = PasswordManager.CreateHashedPWD(_pwd1);
            Console.WriteLine($"Pwd1: {_pwd1} | Result: {result1}");
            var result2 = PasswordManager.CreateHashedPWD(_pwd2);
            Console.WriteLine($"Pwd2: {_pwd2} | Result: {result2}");
            var result3 = PasswordManager.CreateHashedPWD(_pwd3);
            Console.WriteLine($"Pwd3: {_pwd3} | Result: {result3}");

            var isCorrect11 = PasswordManager.VerifyPassword(result1.OriginalPassword, result1);
            var isCorrect12 = PasswordManager.VerifyPassword(result1.OriginalPassword, result2);
            var isCorrect13 = PasswordManager.VerifyPassword(result1.OriginalPassword, result3);
            var isCorrect22 = PasswordManager.VerifyPassword(result2.OriginalPassword, result2);
            var isCorrect21 = PasswordManager.VerifyPassword(result2.OriginalPassword, result1);
            var isCorrect23 = PasswordManager.VerifyPassword(result2.OriginalPassword, result3);
            var isCorrect33 = PasswordManager.VerifyPassword(result3.OriginalPassword, result3);
            var isCorrect31 = PasswordManager.VerifyPassword(result3.OriginalPassword, result1);
            var isCorrect32 = PasswordManager.VerifyPassword(result3.OriginalPassword, result2);

            Console.WriteLine($"Correct 1 is working for pwd1: {isCorrect11}");
            Console.WriteLine($"Correct 1 is working for pwd1/incorrectpwd2: {!isCorrect12}");
            Console.WriteLine($"Correct 1 is working for pwd1/incorrectpwd3: {!isCorrect13}");

            Console.WriteLine($"Correct 2 is working for pwd2: {isCorrect22}");
            Console.WriteLine($"Correct 2 is working for pwd2/incorrectpwd1: {!isCorrect21}");
            Console.WriteLine($"Correct 2 is working for pwd2/incorrectpwd3: {!isCorrect23}");

            Console.WriteLine($"Correct 3 is working for pwd3: {isCorrect33}");
            Console.WriteLine($"Correct 3 is working for pwd3/incorrectpwd1: {!isCorrect31}");
            Console.WriteLine($"Correct 3 is working for pwd3/incorrectpwd2: {!isCorrect32}");
            
            var passWord = string.Empty;
            while (string.IsNullOrWhiteSpace(passWord))
            {
                Console.WriteLine("Please enter your new password:");
                var passWord1 = Console.ReadLine();
                Console.WriteLine("Please validate your new password:");
                var passWord2 = Console.ReadLine();
                passWord = passWord1.Equals(passWord2) ? passWord1 : string.Empty;
            }
            
            var resultNew = PasswordManager.CreateHashedPWD(passWord);
            Console.WriteLine($"Storing info in the Database: {resultNew}");

            bool isValid = false;
            int attempts = 0;
            while (!isValid && attempts < 5) {
                Console.WriteLine("Enter your password:");
                var pwdtest = Console.ReadLine();

                Console.WriteLine($"Should work: {resultNew.OriginalPassword.Equals(pwdtest)}");
                isValid = PasswordManager.VerifyPassword(pwdtest, resultNew);

                attempts++;
                if (attempts >= 5)
                {
                    Console.WriteLine("Too many attempts, please try again later");
                }
            }

            var validationResult = (isValid == true ? "Password Validated successfully!" : "Password not validated!");
            Console.Write($"Password Validation Result: {validationResult}");
        }

        private static void SetVariables()
        {
            _pwd1 = _configuration["Passwords:Password1"];
            _pwd2 = _configuration["Passwords:Password2"];
            _pwd3 = _configuration["Passwords:Password3"];
        }

        private static void BuildOptions()
        {
            _configuration = ConfigurationBuilderSingleton.ConfigurationRoot;
        }
    }
}
