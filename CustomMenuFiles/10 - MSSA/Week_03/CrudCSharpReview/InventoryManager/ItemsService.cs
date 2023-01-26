using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserInputAndValidation;
using VehicleModels;

namespace InventoryManager
{
    public class ItemsService
    {
        private List<Vehicle> Vehicles = new List<Vehicle>();

        public ItemsService()
        {
            //Load();
        }

        public void Add(Vehicle v)
        {
            //validation -> Make sure it's ok to add this?
            //duplicates? does it exist?
            //are the properties validated
            Vehicles.Add(v);
        }

        public string Update(Vehicle v)
        {
            //find it again in the list
            var target = Vehicles.SingleOrDefault(x => x.Id == v.Id);

            //replace values with the updated values
            target.Year = v.Year;
            //do the rest

            return "Updated the vehicle";
        }

        public void Delete(int id)
        {
            var target = Vehicles.SingleOrDefault(x => x.Id == id);
            if (target == null)
            {
                throw new Exception("Vehicle Not Found");
            }
            Vehicles.Remove(target);
        }

        public void Delete(Vehicle v)
        {
            Delete(v.Id);
        }

        public void Load()
        {
            Vehicles.Add(new Vehicle() { Id = 1, Make = "Ford", Model = "Mustang", VIN = "1F23423432", Year = 1968});
            Vehicles.Add(new Vehicle() { Id = 2, Make = "Audi", Model = "A6", VIN = "49a23423432", Year = 2022 });
            Vehicles.Add(new Vehicle() { Id = 3, Make = "Chevy", Model = "Silverado", VIN = "1Ca23923572352", Year = 2014 });
            Vehicles.Add(new Vehicle() { Id = 4, Make = "Ford", Model = "F-250", VIN = "1Fbzq2wer23523", Year = 2018 });
        }

        public List<Vehicle> GetAllVehicles()
        {
            var myCars = new List<Vehicle>();
            foreach (Vehicle v in Vehicles)
            {
                var v1 = new Vehicle();
                v1.Year = v.Year;
                v1.Model = v.Model;
                v1.VIN = v.VIN;
                v1.Make = v.Make;
                v1.Id = v.Id;
                myCars.Add(v1);
            }
            return myCars;
        }

        public string List()
        {
            var output = string.Empty;
            foreach (var v in Vehicles)
            {
                output = $"{output}{Environment.NewLine}{v}";
            }
            return output;
        }

    }
}
