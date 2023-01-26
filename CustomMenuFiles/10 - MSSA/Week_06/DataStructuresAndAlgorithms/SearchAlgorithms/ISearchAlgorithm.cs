using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SearchAlgorithms
{
    public interface ISearchAlgorithm
    {
        int Search(int[] data, int target);
    }
}
