using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordGenerator
{
    public class LoadWordsFromFileUsingFile : ILoadWordsBehavior
    { 
        public List<string> GetWords()
        {
            var words = new List<string>();
            string path = "Words.txt";

            var lines = File.ReadLines(path);
            foreach (var line in lines)
            {
                words.Add(line);
            }

            return words;
        }
    }
}
