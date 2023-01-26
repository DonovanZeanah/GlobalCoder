using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public class CustomQueue<T> : IQueue<T>
    {
        //creation of a linked list caused a conflict, have to reference directly
        private System.Collections.Generic.LinkedList<T> _queue = new System.Collections.Generic.LinkedList<T>();
        
        public void Clear()
        {
            _queue = new System.Collections.Generic.LinkedList<T>();
        }

        public T Dequeue()
        {
            var data = _queue.First();
            _queue.RemoveFirst();
            return data;
        }

        public void Enqueue(T item)
        {
            _queue.AddLast(item);
        }

        public bool IsEmpty()
        {
            return _queue.Count() == 0;
        }

        public T Peek()
        {
            return _queue.ElementAt(0);
            //return _queue.First();
        }
    }
}
