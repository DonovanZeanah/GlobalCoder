using System.Collections;
using System.Globalization;
using System.Numerics;

namespace CustomDataStructures
{
    
    public class ArrayList<T> : IList<T>
    {
        private const int DEFAULT_SIZE = 10;
        private T[] _data;
        private int _currentIndex = 0;
        public ArrayList()
        {
            _data = new T[DEFAULT_SIZE];
        }

        public ArrayList(int size)
        {
            if (size <= 0)
            {
                _data = new T[DEFAULT_SIZE];
            }
            else
            {
                _data = new T[size];
            }
        }

        public T this[int index] 
        {
            get => _data[index]; 
            set => _data[_currentIndex++] = value; 
        }

        public int Count => _currentIndex;

        public bool IsReadOnly => throw new NotImplementedException();

        public void Add(T item)
        {
            if (_currentIndex > _data.Length - 1)
            {
                Resize();
            }
            _data[_currentIndex++] = item;
        }

        private void Resize()
        {
            //double the size of the array
            var tempArray = new T[_data.Length * 2];
            for (int i = 0; i < _data.Length; i++)
            {
                tempArray[i] = _data[i];
            }
            _data = tempArray;
        }

        public void Clear()
        {
            _currentIndex = 0;
            _data = new T[DEFAULT_SIZE];
        }

        public bool Contains(T item)
        {
            return IndexOf(item) >= 0;
        }

        public void CopyTo(T[] array, int arrayIndex)
        {
            //add every item from this list to the incoming array
            //with the offset index as passed in
            for (int i = 0; i < _currentIndex; i++)
            {
                //var place = i + arrayIndex; 
                //var newValue = _data[i];
                //array[place] = newValue;
                array[arrayIndex++] = _data[i];
            }
        }

        public IEnumerator<T> GetEnumerator()
        {
            for (int i = 0; i < _currentIndex; i++)
            { 
                yield return _data[i];
            }
        }

        public int IndexOf(T item)
        {
            for(int i = 0; i < _currentIndex; i++)
            {
                if (EqualityComparer<T>.Default.Equals(_data[i], item))
                {
                    return i;
                }
            }
            return -1;
        }

        public void Insert(int index, T item)
        {
            if (index >= _currentIndex)
            {
                //tail
                //data goes at currentIndex 
                Add(item);
                //|| _data[_currentIndex++] = item;
            }
            else if (index < _currentIndex)
            {
                //do we need to resize?
                //max boundary?
                //_data.length  //actual upper bound on backing data
                //_currentIndex //next place to add an item
                //when I shift everything right,
                //  what is the max place I need
                //  and is that > data.length?

                if (_currentIndex == _data.Length)
                {
                    Resize();
                }

                //if order is unimportant
                /*
                _data[_currentIndex] = _data[index]; 
                _data[index] = item;
                */

                //when order is important:
                for (int i = _currentIndex - 1; i > index; i--)
                {
                    //front ==> data goes at index 0, everything else shift right by 1
                    //middle ==> data goes at index [index], everything index+1 goes right by 1
                    _data[i] = _data[i - 1];
                }
                //for (int i = index; i < _currentIndex; i++)
                //{
                //    //front ==> data goes at index 0, everything else shift right by 1
                //    //middle ==> data goes at index [index], everything index+1 goes right by 1
                //    _data[i + 1] = _data[i];
                //}
                //add in index place
                _data[index] = item;


                //increment current end regardless of maintaining order;
                _currentIndex++;
            }
        }

        public bool Remove(T item)
        {
            var index = IndexOf(item);
            if (index < 0)
            {
                return false;
            }

            RemoveAt(index);
            return true;
        }

        public void RemoveAt(int index)
        {
            if (index < 0 || index >= _currentIndex)
            {
                throw new ArgumentException("Index out of range!"); 
            }

            //if order is not important: O(1)
            _data[index] = _data[_currentIndex - 1];
            
            /*
            //if order matters, have to shift O(n)
            for (int i = index; i < _currentIndex - 1; i++)
            {
                _data[i] = _data[i + 1];
            }
            */

            _currentIndex--;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}