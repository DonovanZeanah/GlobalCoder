# MSSA CCAD 8

Started on 10/24/2022  
Week 11: 2022.12.19 - 2022.12.23

## Week 11 - MVC

## Day 1 - 

Styling, minification, bootstrap, Caching

### Morning

Started with cool stuff review and a challenge

1. Cool stuff you did this weekend

    - A couple of fun things were discussed

1. Challenge: Stamp Vending Machine

    ```text
    You need to write software to dispense change for a vending machine that issues stamps at a post office  

    Current cost of one stamp is $0.60  

    You need to allow the user to select the number of stamps they want  
    You need to display the price for the number of stamps selected  
    When the user inserts cash into the machine, you need to return change with the minimum number of coins possible.   

    For example, a user want's 10 stamps -> $6.00  
    User gives a $20 bill -> 14 returned $1 coins  
    User gives a $10 bill -> 4 $1 coins, no other coins  

    Another example, a user wants 2 stamps -> $1.20  
    User gives $5 -   
    The machine should give 3 $1 coins, 1 - $0.50 coin 1 - $0.25 coin 0 - $0.10 coins and 1-$0.05 coin  

    Extra challenge -  
    how do you handle "running out of coins" in the machine?  
    ```  

1. Discussion about Task Runners, Minification, and browser cache

    We did the slides and talked about the old ways of doing things with minification and linting of files.

    - We reviewed the slides from Module 9, but most of this is outside of normal operations at this point (not a lot of need to use gulp/grunt in the current webdev env).

    - Discussed possibly minifying our site [Bundle and minify static assets](https://learn.microsoft.com/en-us/aspnet/core/client-side/bundling-and-minification?view=aspnetcore-7.0)  

1. Caching static files

    Here we did a quick demo posting the file to azure storage.  I failed to prove the point because I think the local cache was wiped when VS rebuilt and served the site.  The idea was to try to show how the old javascript is cached even if the "source" is updated, and why you might tag a file with a unique id that is completely made up.

1. We reviewed some code from an older version of the Contact Web that had used the bundle config.

    We used to map everything in bundleconfig and then just reference the bundles and MVC would do all the hard work for us:

    ```cs
    namespace ContactWeb
    {
        public class BundleConfig
        {
            // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
            public static void RegisterBundles(BundleCollection bundles)
            {
                bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                            "~/js/lib/jquery.min.js"));

                bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                        "~/js/lib/bootstrap.min.js"));

                bundles.Add(new ScriptBundle("~/bundles/datatables").Include(
                            "~/js/lib/jquery.dataTables.min.js",
                            "~/js/lib/dataTables.bootstrap.min.js",
                            "~/js/lib/dataTables.colReorder.min.js"));

                bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
                                "~/js/lib/jquery-ui.min.js"
                            ));

                bundles.Add(new StyleBundle("~/Content/css").Include(
                        "~/css/bootstrap.min.css",
                        "~/css/jquery.dataTables.min.css",
                        "~/css/jquery.dataTables_themeroller.css",
                        "~/css/dataTables.bootstrap.min.css",
                        "~/css/colReorder.bootstrap.min.css",
                        "~/css/jquery-ui.min.css", 
                        "~/css/site.css"));
            }
        }
    }
    ```    

    Which was referenced in the shared layout as follows:

    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>@ViewBag.Title - Awesome Contact Web</title>
        @Styles.Render("~/Content/css")
    </head>
    <body>
        <div class="navbar navbar-default navbar-fixed-top">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    @Html.ActionLink("Awesome Contact Web", "Index", "Contacts", new { area = "" }, new { @class = "navbar-brand" })
                </div>
                <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li>@Html.ActionLink("Home", "Index", "Home")</li>
                        <li>@Html.ActionLink("About", "About", "Home")</li>
                        <li>@Html.ActionLink("Contact Us", "Contact", "Home")</li>
                        <li>@Html.ActionLink("My Contacts", "Index", "Contacts")</li>
                    </ul>
                    @Html.Partial("_LoginPartial")
                </div>
            </div>
        </div>
        <div class="container-fluid body-content">
            @RenderBody()
            <hr />
            <footer>
                <p>&copy; @DateTime.Now.Year - Awesome Contact Web</p>
            </footer>
        </div>

        @Scripts.Render("~/bundles/jquery")
        @Scripts.Render("~/bundles/bootstrap")
        @Scripts.Render("~/bundles/datatables")
        @Scripts.Render("~/bundles/jqueryui")
        @RenderSection("scripts", required: false)
    </body>
    </html>
    ```  

### Afternoon

In the afternoon, we took a look at Session and Cache and how to store data for reuse across pages and without making multiple calls to the database to get the same data.

1. Session State

    - Donovan led us in implementing sessions

1. Caching

    - We worked with Alex to implement caching on the states.

1. CI/CD with GitHub Actions

    - Rico led us in getting things set up with CI/CD

## Day 2 -

Today is all about layering and testing

### Morning
1. Started the day with testing slides (module 10)

1. Did the module 10 lab

    - gap is big between introduction and this level of knowledge, need more info

1. Starting working on our layering and development of services and repositories

### Afternoon

Continued testing

1. Integration testing continued & finish the repo

1. Add a service layer (mostly pass-through)

1. Unit testing on the service layer

1. Moq & Mocking

1. Inversion of control

    - leverage the service layer from the controller
    - leverage the data layer from the service layer

    - loosely coupled & tested

## Day 3

Rinse and Repeat, then authorize

### Morning

1. Get the contact service and repository built out

1. Test the contacts

1. Authorization & Roles

### Afternoon

Authorization and Roles continued

1. Make sure only the correct people see their stuff

1. Make sure that only the admins can admin

## Day 4

UI and Bootstrap

### Morning

1. Let's dress it up

1. Make this thing useable / Layouts

### Afternoon

1. Modal Popups

1. Ajax posts to controller methods

## Conclusion

Merry Christmas and Happy New Year.  Don't get rusty!
