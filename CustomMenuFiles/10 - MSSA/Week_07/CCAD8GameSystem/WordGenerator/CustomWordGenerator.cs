using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordGenerator
{
    public class CustomWordGenerator : ILoadWordsBehavior
    {
        public List<string> GetWords()
        {
            var words = new List<string>();

            words.Add("airplane");
            words.Add("gypsy");
            words.Add("helicopter");
            words.Add("abruptly");
            words.Add("larynx");
            words.Add("frak");
            words.Add("shat");

            return words;
        }
    }
}
