using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
		public class myStack<T> : IStack<T>
		{
				List<T> stack = new List<T>();

				public myStack()
				{

				}

				public void Clear()
				{
						this.stack = new List<T>();
				}

				public T Peek()
				{
						return GetTopElement();
				}

				public T Pop()
				{
					var result =	GetTopElement();
					this.stack.Remove(result);
					return result;
				}

				public void Push(T item)
				{
						this.stack.Add(item);
				}

				private T GetTopElement()
				{
						if (this.isEmpty())
						{
								throw new Exception("Stack is empty");
						}

						var lastIndex = this.stack.Count - 1;
						var result = this.stack[lastIndex];

						return result;

				}
				public bool isEmpty()
				{
						if (stack.Count <= 0 )
						{
								return true;
						}
						return false;
				}
		}
}
