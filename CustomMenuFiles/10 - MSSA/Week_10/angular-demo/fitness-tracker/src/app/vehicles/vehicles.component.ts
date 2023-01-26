import { Component, OnInit } from '@angular/core';
import { Observable, of } from 'rxjs';
import { Vehicle, VEHICLES } from '../dtos/vehicle';
import { VehicleService } from '../vehicle.service';

@Component({
  selector: 'app-vehicles',
  templateUrl: './vehicles.component.html',
  styleUrls: ['./vehicles.component.less']
})
export class VehiclesComponent implements OnInit {
  vehicles: Vehicle[] = VEHICLES;

  
  constructor(private _vehicleService: VehicleService) {
    this.getVehicles();
  }

  ngOnInit(): void {
    //this.meals = MEALS;
  }

  // getVehicles(): void {
  //   this.vehicles = VEHICLES;
  // }

  // getVehicles(): Observable<Vehicle[]>{
  //   this.vehicles = VEHICLES;
  //   return of(VEHICLES);
  // }

  getVehicles(): void{
    this._vehicleService.getVehicles().subscribe(v => this.vehicles = v);
  }
}
