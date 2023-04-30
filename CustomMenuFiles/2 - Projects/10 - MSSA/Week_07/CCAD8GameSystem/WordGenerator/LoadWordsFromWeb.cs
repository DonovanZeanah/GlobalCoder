using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordGenerator
{
    public class LoadWordsFromWeb : ILoadWordsBehavior
    {
        static readonly HttpClient client = new HttpClient();

        public List<string> GetWords()
        {
            var allWords = new List<string>();
            //var path = "C:\\exports\\WebWords.txt";
            //if (!File.Exists(path))
            //{
            for (int i = 6; i <= 10; i++)
            {
                var query = $@"https://random-word-api.herokuapp.com/word?length={i}&number=10";
                var nextList = GetWordsFromWeb(query);

                //put those words in a text file
                allWords.AddRange(nextList);
            }
            //}

            //File.WriteAllLines(path, allWords);
            //File.Encrypt(path);

            return allWords;
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
