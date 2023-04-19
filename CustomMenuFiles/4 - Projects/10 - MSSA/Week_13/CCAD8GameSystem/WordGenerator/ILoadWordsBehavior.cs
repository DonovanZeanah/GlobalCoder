using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordGenerator
{
    public interface ILoadWordsBehavior
    {
        public List<string> GetWords();
    }
}
