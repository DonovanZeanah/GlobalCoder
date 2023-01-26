using System.Text;

namespace SimpleCaesar
{
    public enum EncryptDecrypt
    {
        Encrypt = 1,
        Decrypt = 2
    };

    public static class CaesarFileEncryption
    {
        //reminder: these will just be in the bin/assets folder after running:
        private static string SecretMessagePath = @"assets/SecretMessage.txt";
        private static string SecretMessageEncryptedPath = @"assets/SecretMessageOutput.txt";
        private static string SecretMessageDecryptedPath = @"assets/SecretMessageOutputDecrypted.txt";
        private static string SecretMessageEncryptedFilePath = @"assets/SecretMessageOutputFileEncrypted.bin";
        private static string SecretMessageDecryptedFilePath = @"assets/SecretMessageOutputFileDecrypted.bin";
        private static string SecretImagePath = @"assets/Darmok.jpg";
        private static string SecretImageOutputPath = @"assets/1.dat";
        private static string SecretImageDecryptedPath = @"assets/1.jpg";

        //just encrypt the innards of the file with caesar
        public static void EncryptFileContents(int theShift) 
        {
            EncryptDecryptFileContents(theShift, SecretMessagePath, SecretMessageEncryptedPath);
            EncryptDecryptFileContents(theShift * -1, SecretMessageEncryptedPath, SecretMessageDecryptedPath);
        }

        //encrypt the whole file
        public static void EncryptEntireFiles(int theShift) 
        {
            EncryptDecryptAnyFile(SecretMessagePath, SecretMessageEncryptedFilePath, EncryptDecrypt.Encrypt, theShift);
            EncryptDecryptAnyFile(SecretMessageEncryptedFilePath, SecretMessageDecryptedFilePath, EncryptDecrypt.Decrypt, theShift);

            //works for images too:
            EncryptDecryptAnyFile(SecretImagePath, SecretImageOutputPath, EncryptDecrypt.Encrypt, theShift);
            EncryptDecryptAnyFile(SecretImageOutputPath, SecretImageDecryptedPath, EncryptDecrypt.Decrypt, theShift);
        }

        //use caesar to shift
        private static void EncryptDecryptFileContents(int theShift, string inputFilePath, string outputFilePath)
        {
            var fileText = File.ReadAllLines(inputFilePath);
            StringBuilder outputLine = new StringBuilder();
            List<string> outputText = new List<string>();

            foreach (string line in fileText)
            {
                foreach (var c in line)
                {
                    var encryptedChar = CaesarShift.GetEncryptedChar(c, theShift);
                    outputLine.Append(encryptedChar);
                }

                outputText.Add(outputLine.ToString());
                outputLine = new StringBuilder();
            }

            WriteTextToFile(outputText, outputFilePath, false);
        }

        private static void WriteTextToFile(List<string> linesOfText, string path, bool append)
        {
            using (var sw = new StreamWriter(path, append))
            {
                foreach (var l in linesOfText)
                {
                    sw.WriteLine(l);
                }
            }
        }

        private static void EncryptDecryptAnyFile(string inputFile, string outputFile, EncryptDecrypt direction, int shift)
        {
            var fileBytes = File.ReadAllBytes(inputFile);
            var outFileBytes = new byte[fileBytes.Length];
            for (int i = 0; i < fileBytes.Length; i++)
            {
                byte b1 = fileBytes[i];
                byte b2 = fileBytes[i];

                if (direction == EncryptDecrypt.Encrypt)
                {
                    b2 = (byte)(b1 + shift);
                }
                else
                {
                    b2 = (byte)(b1 - shift);
                }
                outFileBytes[i] = b2;
            }
            File.WriteAllBytes(outputFile, outFileBytes);
        }

    }
}
