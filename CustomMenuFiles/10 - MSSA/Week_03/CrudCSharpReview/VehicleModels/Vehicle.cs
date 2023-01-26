using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VehicleModels
{
    public class Vehicle
    {
        public int Id { get; set; }
        public string VIN { get; set; } 
        public string Make { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }

        public override string ToString()
        {
            return $"Vehicle [{Id}]: Vin: {VIN} | Make: {Make} | Model: {Model} | Year: {Year}";
        }
    }
}
