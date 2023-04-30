using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordGenerator
{
    public class LoadWordsFromFileUsingStream : ILoadWordsBehavior
    {
        public List<string> GetWords()
        {
            var words = new List<string>();
            //https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
            string path = "Words.txt";

            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (var sr = new StreamReader(fs))
                {
                    var line = string.Empty;
                    while ((line = sr.ReadLine()) != null)
                    {
                        words.Add(line);
                    }
                }
            }

            return words;
        }
    }
}
