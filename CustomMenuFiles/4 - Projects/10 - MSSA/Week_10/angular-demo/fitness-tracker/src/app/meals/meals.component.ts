import { Component, OnInit } from '@angular/core';
import { Meal, MEALS } from '../dtos/meal';
import { VehicleService } from '../vehicle.service';

@Component({
  selector: 'app-meals',
  templateUrl: './meals.component.html',
  styleUrls: ['./meals.component.less']
})
export class MealsComponent implements OnInit {
  meals: Meal[] = MEALS;

  constructor(private _vehicleService: VehicleService) {
    this.meals = MEALS;

  }

  ngOnInit(): void {
    //this.meals = MEALS;
  }

  doSomething(): void {
    this._vehicleService.getVehicles().subscribe(x => console.log(x));
  }
}
