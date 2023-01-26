# MSSA CCAD 8

Started on 10/24/2022
Week 9: 2022.12.05 - 2022.12.09

## Week 9 - HTML/CSS/JS

## Day 1 - 

CSS & Challenge 1

### Morning

Finish up CSS

### Afternoon

Create an HTML/JS/CSS page with template and reusable component challenge

- [HTML_CSS_JS_Challenge Part 1](./Week_09/HTML_CSS_JS_ChallengePart1.md)

## Day 2 -

JavaScript

### Morning

We started the day with a challenge, then moved through some JavaScript modules at w3.

1. Challenge Problem Statement:

Find all the prime numbers greater than input "a" up to a count of "b" primes where each of the valid primes contains a 3 as one of its digits.

Example 1:
a = 16
b = 1
Answer: 23

Example 2:
a = 0
b = 3
Answer 3, 13, 23

Put the valid primes in a list and print them out by iterating the list as efficiently as possible.

#### Hints

- You can use whatever programming language you want to use.  

- Whiteboard first to get your solution (notebook, scrap paper, or any other tool)

- Implement code after you whiteboard it

1. Javascript modules went into the first part of the afternoon

    We started modules with: [JS Home](https://www.w3schools.com/js/default.asp)
    

### Afternoon

In the afternoon we continued the Javascript

1. Went through the modules to [JS Events](https://www.w3schools.com/js/js_events.asp)  

1. Demonstrations

    - Azure (account, resource groups)
    - Azure Function App (created and deployed with right-click and publish)

1. Javascript from the web

    - Get javascript into a webpage locally by calling to the Azure Function

    This required a couple of fixes

    - [Set local IIS on my machine similar to this](https://helpdeskgeek.com/windows-10/install-and-setup-a-website-in-iis-on-windows-10/) 
    - Moved copies of all the files into the wwwroot on my machine
    - Set an access control origin header on the Azure function to allow http://localhost as an origin
    - Add a CDN for Jquery

        ```html
        <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.6.0.min.js"></script>
        ```  

    - Add an ajax call to get and parse the information from the public facing api endpoint

        ```js
        function loadVehicles()
        {
            var dataUrl = "https://mssaautolot.azurewebsites.net/api/GetVehicles?";

            //make a request to the vehicles endpoint
            $.ajax({
                url: dataUrl,
                data: {},
                contentType: "application/json",
                success: function( result ) {
                    console.log("result", result);
                    alert(result);
                    var data = JSON.parse(result);
                    var tableString = "<table><tr><th>Id</th><th>Make</th><th>Model</th><th>VIN</th></tr>";
                    
                    console.log("data value", data);
                    for (var i = 0; i < data.length; i++)
                    {
                        //iterate the JSON to make each vehicle into a row
                        tableString += "<tr>";
                        var nextCar= data[i];
                        
                        tableString += "<td>" + data[i].Id + "</td>";
                        tableString += "<td>" + data[i].Make + "</td>";
                        tableString += "<td>" + data[i].Model + "</td>";
                        tableString += "<td>" + data[i].VIN + "</td>";
                        tableString += "</tr>";
                    }
                    tableString += "</table>";
                    //inject the table html
                    $("#vehiclesTable").html(tableString);
                    //document.getElementById("vehiclesTable").innerHTML = tableString;
                },
                error: function(x, d, xhr) {
                    console.log(xhr);
                }
            });
        }
        ```

## Conclusion

Javascript is difficult.  Remember that there ar strings, numbers, and undefined, but strings and numbers can interact with one another to either add or concatenate, depending on the order of operations.

## Day 3

More Javascript

### Morning

We started the morning with another challenge, then moved back into Javascript

1. Problem:

    - Input is one string of any length
    - Take out every other character
    - Reverse the removed characters
    - Place the characters back in the string

    - Examples:

        - Welcome to MSSA -> WSlMooe tm cSeA
        - Planet Earth to Major Tom -> Poa eo aa tt horMEjtrnTlm
        - Ground Control to Major Tom -> Goo no ao ttol ronMCjdruTrm

### Afternoon

We took some time in the afternoon to make sure to practice what we are learning with Javascript on our own sites.


