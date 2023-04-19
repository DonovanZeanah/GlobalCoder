using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    //double linked list, not implemented, just for talking points
    public class LinkedList<T> : ILinkedList<T> 
    {
        private Node<T> _head;
        private int _currentCount = 0;

        public LinkedList()
        {
            //dummy header node
            _head = new Node<T>(null, default(T), null);
            _head.previous = _head;
            _head.next = _head;
        }

        public T this[int index] 
        { 
            get => throw new NotImplementedException(); 
            set => throw new NotImplementedException(); 
        }

        /// <summary>
        /// Return the current count of nodes in the List
        /// </summary>
        public int Count => _currentCount;

        /// <summary>
        /// Determine IsReadOnly
        /// </summary>
        public bool IsReadOnly => throw new NotImplementedException();

        /// <summary>
        /// Add data to the list at the tail
        /// </summary>
        /// <param name="item">Data to add</param>
        public void Add(T item)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Add Data to the list at the front
        /// </summary>
        public void AddFirst()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Add data to the tail
        /// </summary>
        public void AddLast()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Clear the list
        /// </summary>
        public void Clear()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Determine if the list contains an item
        /// </summary>
        /// <param name="item">The data to find</param>
        /// <returns>true if contained</returns>
        public bool Contains(T item)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Places all list data into the incoming array starting at the offset index
        /// </summary>
        /// <param name="array">The array to place the list data in</param>
        /// <param name="arrayIndex">The offset index for the array to start the list data</param>
        public void CopyTo(T[] array, int arrayIndex)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Get the Enumerator to Iterate the List
        /// </summary>
        /// <returns></returns>
        public IEnumerator<T> GetEnumerator()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Get the data in the first node for the list
        /// </summary>
        /// <returns></returns>
        public T GetFirst()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Get the data for the last node for the list
        /// </summary>
        /// <returns></returns>
        public T GetLast()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Get index of data in the list
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public int IndexOf(T item)
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// Insert the data as a new node in the list at index
        /// </summary>
        /// <param name="index"></param>
        /// <param name="item"></param>
        public void Insert(int index, T item)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Remove the first matching element from the list by Item
        /// </summary>
        /// <param name="item">the item to remove</param>
        /// <returns>true if removed / else false</returns>
        public bool Remove(T item)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Remove the specific element from the list by index
        /// </summary>
        /// <param name="index"></param>
        public void RemoveAt(int index)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Remove the first item from the list
        /// </summary>
        /// <returns></returns>
        public T RemoveFirst()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Remove the last item from the list
        /// </summary>
        /// <returns></returns>
        public T RemoveLast()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Get the enumerator
        /// </summary>
        /// <returns>The Enumerator</returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Node Class is the backing data internal structure
        /// Each node forms part of the chain of elements (links in the chain => linked list)
        /// </summary>
        /// <typeparam name="T">The data for the element</typeparam>
        private class Node<T> 
        {
            internal T data;
            internal Node<T> next;
            internal Node<T> previous;

            /// <summary>
            /// Construct a new node with the correct nodes as next/previous and incoming data
            /// </summary>
            /// <param name="previousNode">The previous node for the new node</param>
            /// <param name="nodeData">The data to house in this node</param>
            /// <param name="nextNode">The next node for the new node</param>
            public Node(Node<T> previousNode, T nodeData, Node<T> nextNode)
            {
                previous = previousNode;
                data = nodeData;
                next = nextNode;
            }

            /// <summary>
            /// Remove this item from the List
            /// </summary>
            public void Remove()
            {
                //remove the node from the list
                //such that the overall list no longer contains this specific node
                throw new NotImplementedException();
            }

            /// <summary>
            /// Adds a node to the list after the current node
            /// </summary>
            /// <param name="nodeData"></param>
            /// <returns>New Node</returns>
            public Node<T> Append(T nodeData)
            {
                //add a new node in place before this node
                //such that "a", "b", "c", with nodeData = "d" and this being b results:
                //"a", "b", "d", "c"

                throw new NotImplementedException();
            }

            /// <summary>
            /// Adds a node to the list prior to the current node
            /// </summary>
            /// <param name="nodeData"></param>
            /// <returns>New Node</returns>
            public Node<T> PrePend(T nodeData)
            {
                //add a new node in place before this node
                //such that "a", "b", "c", with nodeData = "d" and this being b results:
                //"a", "d", "b", "c"
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Implement a way to enumerate the linked list correctly
        /// </summary>
        /// <typeparam name="T">The generic data type for the list</typeparam>
        private class LinkedListEnumerator<T> : IEnumerator<T>
        {
            public T Current => throw new NotImplementedException();

            object IEnumerator.Current => throw new NotImplementedException();
            
            public void Dispose()
            {
                throw new NotImplementedException();
            }

            public bool MoveNext()
            {
                throw new NotImplementedException();
            }

            public void Reset()
            {
                throw new NotImplementedException();
            }
        }
    }
}
