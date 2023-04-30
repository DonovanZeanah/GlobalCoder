using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
		public class myQueue<T> : IQueue<T>
		{
				LinkedList<T> queue = new LinkedList<T>();
				public void Clear()
				{
						queue = new LinkedList<T>();
						//Queue.Clear();
				}
				public void Enqueue(T item)
				{
						this.queue.AddLast(item);
				}

				public T Dequeue()
				{
						var data = this.queue.ElementAt(0);
						this.queue.ElementAt(0);
				}

				

				public bool isEmpty()
				{
				}

				public T Peek()
				{
						return 
				}
		}
}
