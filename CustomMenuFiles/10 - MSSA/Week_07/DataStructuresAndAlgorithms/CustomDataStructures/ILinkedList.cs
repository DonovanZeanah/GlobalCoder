using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public interface ILinkedList<T> : IList<T>, IEnumerable<T>
    {
        void AddFirst();
        void AddLast();
        T GetFirst();
        T GetLast();
        T RemoveFirst();
        T RemoveLast();
    }
}
