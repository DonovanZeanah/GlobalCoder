using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace MSSAAutoLotFunctions
{
    public static class GetVehicles
    {
        [FunctionName("GetVehicles")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var vehicles = GetVehiclesFromDB();


            var jsonVehicles = JsonConvert.SerializeObject(vehicles);
            return new OkObjectResult(jsonVehicles);
        }


        private static List<Vehicle> GetVehiclesFromDB()
        {
            return new List<Vehicle>() {
                new Vehicle() { Id = 1, Make = "Ford", Model = "F-150", VIN ="1FAasdfasdfasdfasdf"},
                new Vehicle() { Id = 2, Make = "Chevy", Model = "Corvette", VIN ="1CAasdfasdfasdfasdf"},
                new Vehicle() { Id = 3, Make = "Toyota", Model = "Sienna", VIN ="3DAasdfasdfasdfasdf"},
                new Vehicle() { Id = 4, Make = "Honda", Model = "Accord", VIN ="5HAasdfasdfasdfasdf"},
                new Vehicle() { Id = 5, Make = "Nissan", Model = "Altima", VIN ="5Tasdfasdfasdfasdf"}
            };
        }
    }
}
