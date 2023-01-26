using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace FileInputOutputDemo
{
    public class FileInterop
    {
        //write a single line using the File class
        public void WriteTextToFileUsingFileObject(string data, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            File.WriteAllText(path, data);
        }

        //write a list to file using the File class
        public void WriteTextToFileUsingFileObject(List<string> allText, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            File.AppendAllLines(path, allText);
        }

        public string ReadAllTextUsingFile(string path)
        {
            if (!File.Exists(path))
            {
                throw new FileNotFoundException("Path is invalid");
            }
            return File.ReadAllText(path);
        }

        public List<string> ReadAllLinesAsListUsingFile(string path)
        {
            if (!File.Exists(path))
            {
                throw new FileNotFoundException("Path is invalid");
            }
            return File.ReadAllLines(path).ToList();
        }

        //write a number of lines using a stream writer
        public void WriteTextToFile(List<string> linesOfText, string path, bool append)
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
        public void AppendTextToFile(string text, string path)
        {
            using (var sw = new StreamWriter(path, true))
            {
                sw.WriteLine(text);
            }
        }

        public List<string> ReadAllLinesAsListUsingStream(string path)
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

        public byte[] GetListAsBytes<T>(List<T> data)
        {
            byte[] bytes = null;
            var bf = new BinaryFormatter();
            using (var ms = new MemoryStream())
            {
                bf.Serialize(ms, data);
                bytes = ms.ToArray();
            }
            return bytes;
        }

        public void WriteBytesToFile(byte[] data, string path)
        {
            using (var bw = new BinaryWriter(File.OpenWrite(path)))
            {
                bw.Write(data);
            }
        }

        public byte[] ReadBinaryObjectFromFile(string path)
        {
            return File.ReadAllBytes(path);
        }

        public List<T> GetBytesAsList<T>(byte[] data)
        {
            var bf = new BinaryFormatter();
            using (Stream ms = new MemoryStream(data))
            {
                var dataRestored = (List<T>)bf.Deserialize(ms);
                return dataRestored;
            }
        }
    }
}
