using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomDataStructures
{
    public class NodeList<T>
    {
        private Node<T> _head;

        public NodeList()
        {

        }

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

                var n = new Node<T>(this, nodeData, this.next);
                //n.next = this.next;
                //n.previous = this; //done in constructor
                this.next.previous = n;
                this.next = n;
                return n;
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
                var n = new Node<T>(this.previous, nodeData,this);
                this.previous.next = n;
                this.previous = n;
                throw new NotImplementedException();
            }
        }

    }
}
