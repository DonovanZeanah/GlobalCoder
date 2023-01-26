using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    public class Pair
    {
        public int PairKey { get; set; }
        public string PairValue { get; set; }
    }
    public class PairOfStrings
    {
        public string PairKey { get; set; }
        public string PairValue { get; set; }
    }
    public class PairOfPerson
    {
        public Person P1 { get; set; }
        public Person P2 { get; set; }
    }
    public class GenericPair<T, S>
    {
        public T O1 { get; set; }
        public S O2 { get; set; }
    }


}
