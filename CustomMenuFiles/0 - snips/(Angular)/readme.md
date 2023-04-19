
#### Components
-For UI 
-One-Way Dataflow 
-Immutable State

#### Directives
  
```
<p *ngIf=="true">
```

#### Pipes
-transforming data
-iso date (long string date) to readable date( march 23, etc)

#### Services
-In charge of API Calls
-Dependency Injection

#### Router
-Handles URL changes
-Web page not 'actually' navigating
-Authorization for web pages

#### Template Reference Variable
- allows other elements to share information with each other
- 
```
// #phone -> (phone.value)
<input #phone placeholder="phone number" />
<button type="button" (click)="callphone(phone.value)">call</button>
```

#### ngClass 
