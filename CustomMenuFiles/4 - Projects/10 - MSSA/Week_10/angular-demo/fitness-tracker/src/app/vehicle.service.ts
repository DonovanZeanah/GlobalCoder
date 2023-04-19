import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Vehicle } from './dtos/vehicle';

@Injectable({
  providedIn: 'root'
})

export class VehicleService {
  vehiclesURL: string = "https://mssaautolot.azurewebsites.net/api/GetVehicles?";

  constructor(private http: HttpClient) { }

  getVehicles(): Observable<Vehicle[]> {
    return this.http.get<Vehicle[]>(this.vehiclesURL);
  }

  
}
