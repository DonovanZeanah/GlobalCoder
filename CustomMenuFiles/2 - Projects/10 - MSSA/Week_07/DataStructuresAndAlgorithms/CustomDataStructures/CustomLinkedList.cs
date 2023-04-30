using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CustomDataStructures
{
    //custom linked list from:
    //https://www.youtube.com/watch?v=8TGFk_zUS9A


    public class Node<T>
    {
        //DATA
        public T Data { get; set; }
        //Link
        public Node<T> Next { get; internal set; }
        //public Node<T> Prev { get; internal set; }

        //Constructor
        public Node(T data)
        {
            Data = data;
        }
    }

    public class CustomLinkedList<T> : IEnumerable<T>
    {
        //Properties
        public Node<T> First { get; private set; }
        public Node<T> Last { get; private set; }
        public int Count { get; private set; }

        //Constructor. Not really needed
        public CustomLinkedList()
        {
            First = null;
            Last = null;
            Count = 0;
        }

        public void AddFirst(T data)
        { 
            var n = new Node<T>(data);
            AddFirst(n);
        }

        //append to front
        public void AddFirst(Node<T> newNode)
        {
            if (First == null)
            {
                //this means the linked list is empty.
                //insert the new node and point the head and tail to the node
                First = newNode;
                Last = newNode;
            }
            else
            {
                newNode.Next = First;
                First = newNode;
            }
            Count++;
        }

        public void AddLast(T data)
        {
            var n = new Node<T>(data);
            AddLast(n);
        }

        //append to last node
        public void AddLast(Node<T> newNode)
        {
            if (Last == null)
            {
                //this means the linked list is empty.
                //insert the new node and point the first and last to the node
                First = newNode;
                Last = newNode;
            }
            else
            {
                Last.Next = newNode;
                Last = newNode;
            }
            Count++;
        }

        public void AddAfter(Node<T> newNode, Node<T> existingNode)
        {
            //if you are adding after the last node, then
            //you need to repoint to the last pointer
            if (Last == existingNode)
            {
                Last = newNode;
            }
            newNode.Next = existingNode.Next;
            existingNode.Next = newNode;
            Count++;
        }

        public Node<T> Find(T target)
        {
            Node<T> currentNode = First;
            while (currentNode != null && !currentNode.Data.Equals(target))
            {
                currentNode = currentNode.Next;
            }
            return currentNode;
        }
        public void RemoveFirst()
        {
            if (First == null || this.Count == 0)
            {
                //Nothing to do. Return.
                return;
            }
            var currentFirst = First;
            var currentNext = First.Next;
            First = currentNext;
            //just point the current first to the currentfirst.Next;
            //First = First.Next;
            currentFirst.Next = new Node<T>(default(T));
            this.Count--;
        }

        public void Remove(T target)
        {
            Node<T> node = First;
            Node<T> targetNode = new Node<T>(default(T));
            var found = false;
            while (node.Next != null)
            {
                if (EqualityComparer<T>.Default.Equals(node.Data, target))
                {
                    targetNode = node;
                    found = true;
                }
                node = node.Next;
            }
            //if haven't found it, validate it's not the last in the list
            if (!found)
            {
                if (EqualityComparer<T>.Default.Equals(node.Data, target))
                {
                    targetNode = node;
                    found = true;
                }
            }
            if (found)
            {
                Remove(targetNode);
            }
            
        }

        public void Remove(Node<T> doomedNode)
        {
            //in a perfect world, you would not need this
            if (First == null || Count == 0)
            {
                //nothing to do. Return.
                return;
            }
            if (First == doomedNode)
            {
                RemoveFirst();
                return;
            }

            //else, you will need to traverse the linked list to find
            //the doomedNode and remove it.
            Node<T> previous = First;
            Node<T> current = First.Next;

            while (current != null && current != doomedNode)
            {
                //move to next node
                previous = current;
                current = previous.Next;
            }

            //remove it
            if (current != null)
            {
                previous.Next = current.Next;
                Count--;
            }
        }

        //iterate thing one by one
        //prev node
        //current node
        //index

        //front
        //null
        //0

        //current.Next
        //current
        //1

        public void Traverse()
        {
            //Console.WriteLine($"\nFirst {First.Data}");
            //Console.WriteLine($"Last {Last.Data}");
            Node<T> node = First;
            while (node.Next != null)
            {
                //Console.WriteLine(node.Data);
                node = node.Next;
            }
            //Console.WriteLine(node.Data);
        }

        public IEnumerator<T> GetEnumerator()
        {
            Node<T> node = First;
            while (node.Next != null)
            {
                yield return node.Next.Data;
                node = node.Next;
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
