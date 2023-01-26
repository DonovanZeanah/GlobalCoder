import { Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.less']
})
export class HomeComponent {
  @ViewChild('LiveUpdates') mySpan: ElementRef;
  
  theNameValue: string = "Not Set";
  theNameValue2: string = "";

  sayHello() : void
  {
    alert('hello');
    this.theNameValue = "Hello Brian";
  }

  neatEffect(): void {
    //alert(this.mySpan.nativeElement.innerHTML);
    alert(this.theNameValue2);
  }
}


