using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public interface IQueue<T>
    {
        T Dequeue();
        void Enqueue(T item);
        T Peek();
        void Clear();
        bool IsEmpty();
    }
}
