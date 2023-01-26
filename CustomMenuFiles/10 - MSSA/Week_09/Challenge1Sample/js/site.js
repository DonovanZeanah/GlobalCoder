function getData(elementId) {

    var myMeals = '[';

    //meal 1
    myMeals = myMeals + "{";
    myMeals = myMeals + '"title": "Soup", ';
    myMeals = myMeals + '"imagePath": "images/fruit-salad-dressing.jpg", '
    myMeals = myMeals + '"ingredients": ["i1","i2","i3","i4"], '
    myMeals = myMeals + '"directions": ["d1","d2","d3","d4"], '
    myMeals = myMeals + '"category": "Lunch"'
    myMeals = myMeals + "},";

    //meal 2
    myMeals = myMeals + "{";
    myMeals = myMeals + '"title": "Hamburger", ';
    myMeals = myMeals + '"imagePath": "images/fruit-salad-dressing.jpg", '
    myMeals = myMeals + '"ingredients": ["i1","i2","i3"], '
    myMeals = myMeals + '"directions": ["d1","d2"], '
    myMeals = myMeals + '"category": "Beef"'
    myMeals = myMeals + "}";

    myMeals = myMeals + "]";
    
    var data = JSON.parse(myMeals);
    
    console.log("my Meals", data);
    var generatedHtml = "";

    //..iterate it
    for (var i = 0; i < data.length; i++)
    {
        // compose the html for each item
        generatedHtml += "<h1>" + data[i].title + "</h1>";
        generatedHtml += '<div class="panel panel-default">'
        generatedHtml += '<div class="panel-heading lead">'; 
        generatedHtml += '<b>' + data[i].title + '</b>&nbsp;'

        generatedHtml += '<span class="flag-wrapper flag-favorites flag-favorites-65"><a href="" title="Add to favorites" class="" rel="nofollow">';
        generatedHtml += '<span class="glyphicon glyphicon-star-empty"></span></a><span class="flag-throbber">&nbsp;</span></span>&nbsp;';
        generatedHtml += '<a href="/recipes/65" target="_blank"><span class="glyphicon glyphicon-print"></span></a>'

        generatedHtml += '</div>'; 

        generatedHtml += '<div class="panel-body"><img class="foodImage" src=' + data[i].imagePath + ' /></div>';
        
        //ingredients
        generatedHtml += '<span class="panelDetailHeader">Ingredients</span>';
        generatedHtml += '<div class="panel-body">'
        generatedHtml += '<ul>';
        for (var j = 0; j < data[i].ingredients.length; j++)
        {
            generatedHtml += '<li>' + data[i].ingredients[j] +'</li>';
        }
        generatedHtml += '</ul>';
        generatedHtml += '</div>'; //closes ingredients

        //directions
        generatedHtml += '<span class="panelDetailHeader">Directions</span>';
        generatedHtml += '<div class="panel-body"><p>'
        for (var j = 0; j < data[i].directions.length; j++)
        {
            generatedHtml += data[i].directions[j] +'<br />';
        }
        generatedHtml += '</p></div>'; //directions

        //footer...
        generatedHtml += '<div class="panel-footer">';
        generatedHtml += data[i].category;
        generatedHtml += '</div>'; //closes footer
        generatedHtml += '</div>'; //closes panel panel-default
        /*
        

                
            
        */
    }

    document.getElementById(elementId).innerHTML = generatedHtml;
}