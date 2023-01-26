export interface Vehicle {
    Id: number,
    VIN: string,
    Make: string,
    Model: string
}

//https://vingenerator.org/brand
export const VEHICLES: Vehicle[] = [
    { Id: 101, VIN: "3FDNF6530YMA05956", Make: "Ford", Model: "F 650"},
    { Id: 252, VIN: "3FADP4BK0C0017527", Make: "Ford", Model: "Fiesta"},
    { Id: 311, VIN: "ZFFPR41A0S0100364", Make: "Ferrari", Model: "F355"},
    { Id: 23, VIN: "5YJSA1E22FF106191", Make: "Tesla", Model: "S"},
    { Id: 277, VIN: "WP0CA2980X4626407", Make: "Porsche", Model: "Boxster"},
];