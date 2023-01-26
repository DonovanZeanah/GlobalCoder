namespace SearchAlgorithms
{
    public class LinearSearch : ISearchAlgorithm
    {
        public int Search(int[] data, int target)
        {
            //search for the item
            for (int i = 0; i < data.Length; i++)
            {
                //if found, return it
                if (data[i] == target)
                {
                    return i;
                }
            }

            //if not found?
            throw new Exception("Item not found in data!");
        }
    }
}