

import { NgIf } from '@angular/common';
import { Component } from '@angular/core';

interface Pokemon {
  id: number;
  name: string;
  type: string;
  isCool: boolean;
}
//import { FormsModule } from '@angular/forms';
// in app.module.ts under @NgModule, add FormsModule to the imports array


//@Component is a *decorator* of AppComponent to tell Angular that this class is a component
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  pokemons: Pokemon[] = [{
    id: 1,
    name: "Bulbasaur",
    type: "Grass",
    isCool: true
  }, {
    id: 2,
    name: "Ivysaur",
    type: "Grass",
    isCool: false

  }, {
    id: 3,
    name: "Venusaur",
    type: "Grass",
    isCool: true
  }];


  pokemonName: string = "";
  title: string ;
  numberOne: number = 1;
  numberTwo: number = 2;
  togglePokemon: boolean = true;
  imgSrc: string = "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/001.png";

favoriteAnimal : string = "tamarin";
handleSearchPokemonClick(value: any)
{
  console.log(value);
}
/*   imgSrc: string = "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/004.png"; */
  constructor() {
    this.title = "Zeanah";
  }

}
