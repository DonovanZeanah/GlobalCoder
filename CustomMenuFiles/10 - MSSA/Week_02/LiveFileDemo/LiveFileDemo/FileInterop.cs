using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LiveFileDemo
{
    public static class FileInterop
    {
        //write a single line using the File class
        public static void WriteTextToFileUsingFileObject(string data, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            File.WriteAllText(path, data);
        }

        //write a list to file using the File class
        public static void WriteTextToFileUsingFileObject(List<string> allText, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            File.AppendAllLines(path, allText);
        }

        //write a number of lines using a stream writer
        public static void WriteTextToFile(List<string> linesOfText, string path, bool append)
        {
            using (var sw = new StreamWriter(path, append))
            {
                foreach (var l in linesOfText)
                {
                    sw.WriteLine(l);
                }
            }
        }

        //append one line using a stream writer
        public static void AppendTextToFile(string text, string path)
        {
            using (var sw = new StreamWriter(path, true))
            {
                sw.WriteLine(text);
            }
        }


        public static string ReadAllTextUsingFile(string path)
        {
            if (!File.Exists(path))
            {
                throw new FileNotFoundException("Path is invalid");
            }
            return File.ReadAllText(path);
        }

        public static List<string> ReadAllLinesAsListUsingFile(string path)
        {
            if (!File.Exists(path))
            {
                throw new FileNotFoundException("Path is invalid");
            }
            return File.ReadAllLines(path).ToList();
        }

        public static List<string> ReadAllLinesAsListUsingStream(string path)
        {
            var allLines = new List<string>();
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (var sr = new StreamReader(fs))
                {
                    var line = string.Empty;
                    while ((line = sr.ReadLine()) != null)
                    {
                        allLines.Add(line);
                    }
                }
            }
            return allLines;
        }
    }
}
