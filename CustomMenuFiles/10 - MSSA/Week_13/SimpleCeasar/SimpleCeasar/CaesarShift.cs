using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleCaesar
{
    public static class CaesarShift
    {
        private const string stringToEncrypt1 = "There's-a-starman-waiting-in-the-sky";
        private const string stringToEncrypt2 = "zyxwvutsrqponmlkjihgfedcba";
        private const string stringToEncrypt3 = "abcdefghijklmnopqrstuvwxyz";
        private const string stringToEncrypt4 = "Rocket man, burning out his fuse up here alone";

        public static void RunCaesar(int theShift)
        {
            var encrypted1 = EncryptOrDecryptCaesarCipher(stringToEncrypt1, theShift);
            var decrypted1 = EncryptOrDecryptCaesarCipher(encrypted1, theShift * -1);
            var encrypted2 = EncryptOrDecryptCaesarCipher(stringToEncrypt2, theShift);
            var decrypted2 = EncryptOrDecryptCaesarCipher(encrypted2, theShift * -1);
            var encrypted3 = EncryptOrDecryptCaesarCipher(stringToEncrypt3, theShift);
            var decrypted3 = EncryptOrDecryptCaesarCipher(encrypted3, theShift * -1);
            var encrypted4 = EncryptOrDecryptCaesarCipher(stringToEncrypt4, theShift);
            var decrypted4 = EncryptOrDecryptCaesarCipher(encrypted4, theShift * -1);

            Console.WriteLine($"The encrypted string 1 is: {encrypted1}");
            Console.WriteLine($"The decrypted string 1 is: {decrypted1}");
            Console.WriteLine($"The encrypted string 2 is: {encrypted2}");
            Console.WriteLine($"The decrypted string 2 is: {decrypted2}"); 
            Console.WriteLine($"The encrypted string 3 is: {encrypted3}");
            Console.WriteLine($"The decrypted string 3 is: {decrypted3}");
            Console.WriteLine($"The encrypted string 4 is: {encrypted4}");
            Console.WriteLine($"The decrypted string 4 is: {decrypted4}");
        }

        public static string EncryptOrDecryptCaesarCipher(string s, int shift)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var c in s)
            {
                //encrypt
                var encryptedChar = GetEncryptedChar(c, shift);

                //append
                sb.Append(encryptedChar);
            }

            return sb.ToString();
        }

        public static char GetEncryptedChar(char input, int shift)
        {
            //determine if we need to encrypt the char
            if (!NeedsEncryption(input))
            {
                return input;
            }

            //65-90 = A-Z
            //97-122 = a-z
            var offset1 = 65;
            var offset2 = 97;
            var range1 = 90;
            var newCharInt = 0;

            //encrypt/decrypt:
            var currentCharInt = (int)input;

            //get the offset to use for shift:
            var offsetToUse = offset2;
            if (currentCharInt <= range1)
            {
                offsetToUse = offset1;
            }

            //get shifted character
            var charFinal = Convert.ToChar(GetNewCharInt(shift, currentCharInt, offsetToUse));
            Debug.WriteLine($"Character: {input} | currentCharInt {currentCharInt} | new char int: {newCharInt} | $ newChar {charFinal}");
            return charFinal;
        }

        private static bool NeedsEncryption(char c)
        {
            //determine if we need to encrypt the char
            var needsEncryption = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
            return needsEncryption.Contains(c);
        }

        private static int GetNewCharInt(int shift, int currentCharInt, int offset)
        {
            var targetShifted = currentCharInt + shift - offset;

            //if targetShifted < 0 then wrap back to z and go from there...
            if (targetShifted < 0)
            {
                targetShifted = 26 - Math.Abs(targetShifted);
            }

            var newTarget = targetShifted % 26 + offset;
            //Debug.WriteLine($"Shift: {shift} | currentCharInt {currentCharInt} | offset {offset} | adjustedTargetShifted {targetShifted} | newTarget {newTarget}");
            return newTarget;
        }
    }
}
