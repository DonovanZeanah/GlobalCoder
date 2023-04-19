using System.Security.Cryptography;
using System.Text;

//modified, based on https://code-maze.com/csharp-hashing-salting-passwords-best-practices/
namespace SimpleCaesar
{
    public static class PasswordManager
    {
        private const int NumberOfIterations = 25000;
        private static HashAlgorithmName AlgorithmName = HashAlgorithmName.SHA512;
        private const int KeySize = 64;
        private const int SaltLength = 32;
        private static RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();

        private static byte[] GenerateNewSalt()
        {
            var salt = new byte[SaltLength];
            provider.GetNonZeroBytes(salt);
            return salt;
        }

        public static bool VerifyPassword(string password, SaltAndHash breakfast)
        {
            var salt = Convert.FromHexString(breakfast.SaltString);
            var hashToCompare = Rfc2898DeriveBytes.Pbkdf2(password, salt, NumberOfIterations, AlgorithmName, KeySize);
            return hashToCompare.SequenceEqual(Convert.FromHexString(breakfast.Hash));
        }

        public static SaltAndHash CreateHashedPWD(string pwd)
        {
            var breakfast = new SaltAndHash();

            //generate a unique salt for the user
            var salt = GenerateNewSalt();
            breakfast.SaltString = Convert.ToHexString(salt);

            //hash the pwd with the salt
            var pwdBytes = Encoding.UTF8.GetBytes(pwd);
            var hash = Rfc2898DeriveBytes.Pbkdf2(pwdBytes, salt, NumberOfIterations, AlgorithmName, KeySize);
            breakfast.Hash = Convert.ToHexString(hash);

            //store the password for testing/validation (NEVER EVER DO THIS IN THE REAL WORLD)
            breakfast.OriginalPassword = pwd;
            return breakfast;
        }
    }
}
