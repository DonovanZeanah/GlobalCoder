using System.Collections;
using System.Globalization;

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
            return IndexOf(item) > 0;
        }

        public void CopyTo(T[] array, int arrayIndex)
        {
            throw new NotImplementedException();
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
            throw new NotImplementedException();
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