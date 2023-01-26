using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public interface IStack<T>
    {
        T Pop();
        void Push(T item);
        T Peek();
        void Clear();
        bool IsEmpty();
    }
}
