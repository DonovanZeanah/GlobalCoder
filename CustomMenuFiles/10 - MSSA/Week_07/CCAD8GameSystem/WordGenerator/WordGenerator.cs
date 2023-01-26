using Newtonsoft.Json;
using System.IO;
using System.Net;
using System.Text.Json.Serialization;

namespace WordGenerator
{
    public class WordGenerator
    {
        private List<string> words = new List<string>();
        static readonly HttpClient client = new HttpClient();

        private ILoadWordsBehavior _loadWordsBehavior;

        public WordGenerator(ILoadWordsBehavior loadWordsBehavior)
        {
            _loadWordsBehavior = loadWordsBehavior;
        }

        private List<string> excludeWords = new List<string>()
        {
            "frak", "shat"
        };

        public string[] GetWords()
        {
            words = _loadWordsBehavior.GetWords();

            if (words.Count < 10)
            {
                _loadWordsBehavior = new LoadWordsFromFileUsingFile();
                var additionalWords = _loadWordsBehavior.GetWords();
                foreach (var word in additionalWords)
                {
                    words.Add(word);
                }
            }

            List<string> goodWords = new List<string>();
            foreach (var w in words)
            {
                if (w != "frak")
                {
                    goodWords.Add(w);
                }
            }

            var badWords = words.Intersect(excludeWords);
            var goodWords2 = words.Where(x => !badWords.Contains(x));

            return goodWords2.ToArray();
        }

        private void LoadWords()
        {
            words.Add("airplane");
            words.Add("gypsy");
            words.Add("helicopter");
            words.Add("abruptly");
            words.Add("larynx");
            words.Add("frak");
            words.Add("shat");
        }

        private void LoadWordsFromFileUsingStream()
        {
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
        }

        private void LoadWordsFromFileUsingFile()
        {
            string path = "Words.txt";

            var lines = File.ReadLines(path);
            foreach (var line in lines)
            {
                words.Add(line);
            }
        }

        private void LoadWordsFromWeb()
        {
            var path = "C:\\exports\\WebWords.txt";
            if (!File.Exists(path))
            {
                GenerateWordFile();
            }

            var lines = File.ReadAllLines(path);
            foreach (var line in lines)
            {
                words.Add(line);
            }
        }

        private void GenerateWordFile()
        {
            var allWords = new List<string>();
            var path = "C:\\exports\\WebWords.txt";
            if (!File.Exists(path))
            {
                for (int i = 6; i <= 10; i++)
                { 
                    var query = $@"https://random-word-api.herokuapp.com/word?length={i}&number=10";
                    var nextList = GetWordsFromWeb(query);

                    //put those words in a text file
                    allWords.AddRange(nextList);
                }
            }
            
            File.WriteAllLines(path, allWords);
            //File.Encrypt(path);
        }

        private List<string> GetWordsFromWeb(string url)
        {
            var theWords = Task.Run(async () => await GetAsync(url)).Result;
            return theWords;
        }

        static async Task<List<string>> GetAsync(string url)
        {
            using HttpResponseMessage response = await client.GetAsync(url);
            var jsonResponse = await response.Content.ReadAsStringAsync();

            return JsonConvert.DeserializeObject<List<string>>(jsonResponse);
        }
    }
}