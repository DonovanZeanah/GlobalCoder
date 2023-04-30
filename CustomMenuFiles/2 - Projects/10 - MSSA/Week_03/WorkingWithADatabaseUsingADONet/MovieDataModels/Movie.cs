using System.Data;

namespace MovieDataModels
{
    public class Movie
    {
        public string Title { get; set; }
        public int Id { get; set; }
        public int RatingId { get; set; }
        public virtual Rating Rating { get; set; }
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:MM/dd/yyyy}")]
        public DateTime ReleaseDate { get; set; }
        public int Length { get; set; }

        public static List<Movie> GetMoviesFromDataset(DataSet ds)
        {
            var myMovies = new List<Movie>();

            foreach (DataTable table in ds.Tables)
            {
                foreach (DataRow row in table.Rows)
                {
                    var movie = new Movie();
                    var rating = new Rating();
                    movie.Rating = rating;
                    foreach (DataColumn column in table.Columns)
                    {
                        object item = row[column];
                        switch (column.ColumnName)
                        {
                            case "Title":
                                movie.Title = (string)item;
                                break;
                            case "ReleaseDate":
                                movie.ReleaseDate = (DateTime)item;
                                break;
                            case "Length":
                                movie.Length = (int)item;
                                break;
                            case "Rating":
                                rating.RatingValue = (string)item;
                                break;
                            case "RatingId":
                                movie.RatingId = (int)item;
                                rating.Id = movie.RatingId;
                                break;
                            case "MovieId":
                                movie.Id = (int)item;
                                break;
                            default:
                                break;
                        }
                    }
                    myMovies.Add(movie);
                }
            }
            return myMovies;
        }

        public override string ToString()
        {
            return $"Title: {Title} | Rating: {Rating.RatingValue} | Runtime: {Length} | ReleaseDate: {ReleaseDate.ToString("yyyy")}";
        }
    }
}