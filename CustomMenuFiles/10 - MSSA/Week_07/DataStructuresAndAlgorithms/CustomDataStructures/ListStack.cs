using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public class ListStack<T> : IStack<T>
    {
        List<T> _data = new List<T>();

        public ListStack()
        {

        }

        public void Clear()
        {
            _data = new List<T>();
        }

        private T GetTopElement()
        {
            if (IsEmpty())
            {
                throw new Exception("stack is empty!");
            }
            return _data[_data.Count() - 1];
        }

        public T Peek()
        {
            return GetTopElement();
        }

        public T Pop()
        {
            var data = GetTopElement();
            _data.RemoveAt(_data.Count() - 1);
            return data;
        }

        public bool IsEmpty()
        {
            return _data.Count == 0;
        }

        public void Push(T item)
        {
            _data.Add(item);
        }
    }
}
