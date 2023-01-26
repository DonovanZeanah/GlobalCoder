using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MilitaryClassModels
{
    public class Point
    {
        public double Lat { get; set; }
        public double Lon { get; set; }

        public Point()
        { 
        
        }

        public Point(double lat, double lon)
        {
            Lat = lat;
            Lon = lon;
        }
    }
}
