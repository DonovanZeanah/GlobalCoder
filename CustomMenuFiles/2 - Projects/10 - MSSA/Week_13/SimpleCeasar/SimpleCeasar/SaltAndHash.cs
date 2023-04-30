//modified based on https://code-maze.com/csharp-hashing-salting-passwords-best-practices/
namespace SimpleCaesar
{
    public class SaltAndHash
    {
        //the user-specific salt, stored in the database
        public string SaltString { get; set; }
        //the result of applying the salt to the password. This is NOT the raw password
        public string Hash { get; set; }
        //NOTE: DO NOT STORE THIS ANYWHERE, EVER!
        //      THIS IS JUST TO VALIDATE things are working without using a DB
        //      AGAIN, YOU SHOULD NEVER NEED TO KNOW THIS VALUE.
        public string OriginalPassword { get; set; }

        public override string ToString()
        {
            return $"SALT: {SaltString} | HASH: {Hash}";
        }
    }
}
