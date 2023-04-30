# MSSA CCAD 8

Started on 10/24/2022
Week 3: 2022.10.24-2022.29.21

## Week 4 - Advanced C# with Desktop and Databases

During week 3, we're going Work on learning how to work with relational databases.

## Day 1

C# Again

### Morning

1. Questions

1. Slides (C# Developer 483 Module 1)

1. Live Demo working with Forms app

1. Work together

    - created project
    - created class library
    - created classes for Teacher and Student
    - create form1 controls to get information for teacher and student
    - started working on Add Teacher method

### Afternoon

1. Work Together

    - Completed add teacher
    - saw that we could bind the teacher to a grid
    - started working on the database

1. Adding the database is a lot.  There are about 30 steps to the process.  However, once the database is wired up, everything will just work nicely.

    - During this day, we created the start of our database connection by setting up the DBContext project and by utilizing the models through the DB library.
    - Next, we added some code to bring in configurations and got to the point where we could read the appsettings.json file and validated that it all worked as expected.

We ran out of time and had a lot of stuff to do yet with the database, so we decided to move it to tomorrow.

## Conclusion

The day went pretty well but the database stuff is a bit much at this point.  It's great that we're getting to see the database plumbing, and once it's up and working, we will be in a really great place.  

## Day 2

During day 2, we're going to continue pressing on with C#, adding our database and utilizing our learning to this point to work with objects from the database.

Hopefully we'll be to the point where we can do CRUD operations by the end of the day.

### Morning

The morning will start off with questions, then we need to get our database connected.

1. Questions

1. Database Connection work.

    There are a number of things that need to be done to complete the database set up.  To get everything working, I'm going to put some code snippets here for us to use to complete the work.

1. To expedite this process, we'll start by getting making sure that both of our projects for the UI and the database have all the libraries that are required.

On the UI project (the forms project), put the following xml into your project file to ensure that all of the NuGet packages are present:

```c#
  <ItemGroup>
	<PackageReference Include="Microsoft.EntityFrameworkCore" Version="6.0.10" />
	<PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="6.0.10">
	  <PrivateAssets>all</PrivateAssets>
	  <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
	</PackageReference>
	<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="6.0.10" />
	<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="6.0.10">
	  <PrivateAssets>all</PrivateAssets>
	  <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
	</PackageReference>
	<PackageReference Include="Microsoft.Extensions.Configuration" Version="6.0.1" />
	<PackageReference Include="Microsoft.Extensions.Configuration.Binder" Version="6.0.0" />
	<PackageReference Include="Microsoft.Extensions.Configuration.Json" Version="6.0.0" />
  </ItemGroup>
```  

In the DBLibrary project, ensure that you have the following NuGet packages referenced in your csproj file:

```c#
  <ItemGroup>
    <PackageReference Include="Microsoft.EntityFrameworkCore" Version="6.0.10" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="6.0.10" />
    <PackageReference Include="Microsoft.Extensions.Configuration" Version="6.0.1" />
	<PackageReference Include="Microsoft.Extensions.Configuration.Json" Version="6.0.0" />
  </ItemGroup>
```  

1. Add another appsettings.json file into the DBLibrary project.  

    Ensure that you set the Build Action to `Content` and the Copy to Output Directory to `Copy Always` or `Copy if newer`.

    Add connection string settings into the appsettings.json files:

    ```json
    {
        "ConnectionStrings": {
            "SchoolOfFineArtsDB": "Server=localhost;Database=SchoolOfFineArtsDB;Trusted_Connection=True;"
        }
    }
    ```  

1. In the DBLibrary project, add the following constructors to the DB Context:

    ```c#
    //add to allow migrations
    public SchoolOfFineArtsDBContext()
    {

    }

    //add to inject context options from app
    public SchoolOfFineArtsDBContext(DbContextOptions options)
            : base(options)
    {

    }
    ```

1. After the constructors, add the following code.

    This code is necessary for the migrations to run

    ```c#  
    //add to allow migrations when the context is not built
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var builder = new ConfigurationBuilder()
                            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

            var config = builder.Build();
            var cnstr = config["ConnectionStrings:SchoolOfFineArtsDB"];
            var options = new DbContextOptionsBuilder<SchoolOfFineArtsDBContext>().UseSqlServer(cnstr);
            optionsBuilder.UseSqlServer(cnstr);
        }
    }
    ```  

1. At this point, you should be able to run migrations, even though you don't have any.

    In the package manager console, select the dblibrary project and run the command:

    ```c#
    update-database
    ```  

    This will run, but it will say "no migrations..." because you don't have any.  That's expected.

1. From here, you can start adding migrations.  At this point, we can work together to accomplish the following

    - add a default rollback migration
    
        ```c#
        add-migration rollback-baseline
        ```  

        This should generate a default migration

    - update the database

        ```c#
        update-database
        ```  

        Even though there was nothing in the migration, you can check to make sure your database was created on your local server.

1. Add the Teacher object

    In the `SchoolOfFineArtsDBContext` add the following to the top of the class file before the constructors:

    ```c#
    public DbSet<Teacher> Teachers { get; set; }
    ```  

    This will tell the database you want to utilize the Teachers object in the database

    Run the command:

    ```c#
    add-migration create-teachers-table
    ```  

    Then review the migration created.

    Then run the command:

    ```c#
    update-database
    ```  

    You should now have the teachers table as expected.

1. With the teachers table in place, you will want to seed some data.

    Add the following code towards the bottom of the DBContext:

    ```c#
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Teacher>(x =>
        {
            x.HasData(
                new Teacher() { Id = 1, FirstName = "Anne", LastName = "Sullivan", Age = 27 },
                new Teacher() { Id = 2, FirstName = "Maria", LastName = "Montessori", Age = 32 },
                new Teacher() { Id = 3, FirstName = "William", LastName = "McGuffey", Age = 21 },
                new Teacher() { Id = 4, FirstName = "Emma", LastName = "Willard", Age = 47 },
                new Teacher() { Id = 5, FirstName = "Jaime", LastName = "Escalante", Age = 62 }
            );
        });
    }
    ```  

1. Create another migration

    Add a new migration to seed the data:

    ```c#
    add-migration seed-teacher-table-data
    ```  

    Review the migration and update the database

    ```c#
    update-database
    ```  

    Now review your database in SSMS.  You should see your data in place.

1. Update the application to load teachers from the database

    Add the following variables to the top of the Form1 class:

    ```c#
    //use readonly as they are only set at form creation
    private readonly string _cnstr;
    private readonly DbContextOptionsBuilder _optionsBuilder;
    ```  

    In the constructor, add the following code:

    ```c#
    _cnstr = Program._configuration["ConnectionStrings:SchoolOfFineArtsDB"];
    _optionsBuilder = new DbContextOptionsBuilder<SchoolOfFineArtsDBContext>().UseSqlServer(_cnstr);
    ```  

    Add a new button on the form with text `Load Teachers` and name it `btnLoadTeachers`.  Click it to get the code stub, and add the following code to the method:

    ```c#
    //take advantage of disposability of the connection and context:
    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        var databaseTeachers = new BindingList<Teacher>(context.Teachers.ToList());
        dgvResults.DataSource = databaseTeachers;
        dgvResults.Refresh();
    }
    ```  

1. Run the application.

    Make sure you can load teachers.

1. Migration commands

    We learned and used all the following commands:

    - add-migration &lt;migration-name-here&gt;
    - update-database
    - update-database -migration &lt;migration-name-here&gt;
    - remove-migration

1. Migration Paradigms/Patterns

    - roll-back vs. roll-forward

1. Add the Student table

    - put the property for DbSet&lt;Student&gt; in the context
    - add-migration "create-student-table"
    - update-database
    - seed some students
    - add-migration "seed-student-table"
    - update database

1. Add the Load operation for students

    Make it possible to load students from the database.

1. After getting the load work, we'll work on Insert, Edit, and Delete methods.

    For simplicity, in this application we're going to put all of our database work right in the form methods.

1. Context commands

    context.Teachers.ToList()
    context.Teachers.Add(teacher)
    context.SaveChanges()

1. Add Teacher

    ```c#  
    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        var exists = context.Teachers.SingleOrDefault(t => t.FirstName.ToLower() == teacher.FirstName.ToLower()
                                                    && t.LastName.ToLower() == teacher.LastName.ToLower()
                                                    && t.Age == teacher.Age);
        //if exists post error "did you mean to update"
        if (exists is not null)
        {
            newObject = false;
            MessageBox.Show("Teacher already exists, did you mean to update?");
        }
        else
        {
            //if not add teacher
            context.Teachers.Add(teacher);
            context.SaveChanges();
            //reload teachers
            var dbTeachers = new BindingList<Teacher>(context.Teachers.ToList());
            dgvResults.DataSource = dbTeachers;
            dgvResults.Refresh();
        }
    }
    ```  

### Afternoon

Continue working on CRUD

1. A couple of fixes for a few people

    - Git merge conflict (Donovan)
    - Josh - multiple methods renamed/missing

1. Get the remaining CRUD operations working for Teachers

    - Utilize the click event on the data grid to get a handle on the row object for use in getting the data to update or delete.
    
    ```c#
    var theRow = dgvResults.Rows[e.RowIndex];
    int dataId = 0;
    bool isTeacher = false;
    bool isStudent = false;
    foreach (DataGridViewTextBoxCell cell in theRow.Cells)
    {
        if (cell.OwningColumn.Name.Equals("Id", StringComparison.OrdinalIgnoreCase))
        {
            dataId = (int)cell.Value;
        }
        if (cell.OwningColumn.Name.Equals("Age", StringComparison.OrdinalIgnoreCase))
        {
            isTeacher = true;
        }
        if (cell.OwningColumn.Name.Equals("DateOfBirth", StringComparison.OrdinalIgnoreCase))
        {
            isStudent = true;
        }
    }

    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        if (isTeacher)
        {
            var d = context.Teachers.SingleOrDefault(x => x.Id == dataId);
            if (d is not null)
            { 
                numId.Value = d.Id;
                txtFirstName.Text = d.FirstName;
                txtLastName.Text = d.LastName;
                numTeacherAge.Value = d.Age;

                rdoTeacher.Checked = true;
                rdoStudent.Checked = false;
                ToggleControlVisibility();
            }
        }
        else if (isStudent)
        {
            var d = context.Students.SingleOrDefault(x => x.Id == dataId);
            if (d is not null)
            {
                numId.Value = d.Id;
                txtFirstName.Text = d.FirstName;
                txtLastName.Text = d.LastName;
                dtStudentDateOfBirth.Value = d.DateOfBirth;

                rdoTeacher.Checked = false;
                rdoStudent.Checked = true;
                ToggleControlVisibility();
            }
        }
    }
    ```  
1. Delete

    - Delete

    ```  
    var Id = (int)numId.Value;
    var confirmDelete = MessageBox.Show("Are you sure you want to delete this item?"
        , "Are you sure?"
        , MessageBoxButtons.YesNo);
    if (confirmDelete == DialogResult.No)
    {
        return;
    }
    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        if (rdoTeacher.Checked)
        {
            var d = context.Teachers.SingleOrDefault(t => t.Id == Id);
            if (d != null)
            {
                context.Teachers.Remove(d);
                context.SaveChanges();
                var databaseTeachers = new BindingList<Teacher>(context.Teachers.ToList());
                dgvResults.DataSource = databaseTeachers;
            }
        }
        else if (rdoStudent.Checked)
        {
            var d = context.Students.SingleOrDefault(s => s.Id == Id);
            if (d != null)
            {
                context.Students.Remove(d);
                context.SaveChanges();
                var databaseStudents = new BindingList<Student>(context.Students.ToList());
                dgvResults.DataSource = databaseStudents;
            }
        }
        dgvResults.Refresh();
    }
    ```  

1. Update

    - ensure you can't edit the id field
    - populate with 0 until a row is clicked
    - Rework add button to update if the ID > 0

1. Reset the form after add/update

    - reset to defaults for the text boxes and the id

1. Add crud operations around students

    Make it possible to add/edit/delete students.

## Conclusion

What a day! We hit the database and EFCore from the ground up.  We created a database, we then added migrations to create tables and seed data.  We also learned about Data Annotations to limit the string length.  We also took some time and discussed the concepts of roll forward vs rollback when it comes to migrations.

We have also made an app that is able to read data from the database, insert records, and we got delete working.  The final piece is the update and some cleanup on the form to make it so we can clear the form after a valid save and make it so the user can press add or update and the code will just do the right operation based on the set id.

## Day 3

Today we'll continue by finishing up the CRUD (Update) operations for our data, and any lingering cleanup.

Then we need to make it so we can create a class object and then we need to associate a teacher to a class and multiple students to a class.

We should consider if we want to do class sections, where the same class could be offered at different times with different instructors and students, or if we want to keep it simple for now and just have one class offering that has one teacher only and one class roster only.

### Morning

1. Questions

1. Another look at the stuff from Yesterday as we got Mursal back up and running

1. Finish up the CRUD for the Instructors and Students

1. Lots of troubleshooting

1. Fixed a small bug with clicking in the bad row.

### Afternoon

1. Fixed up Josh's Migrations and click events

    - update-database -migration <name-of-target-migration>
    - remove-migration (x3)
    - update-database -migration <name-of-early-good-migration>
    - update-database
    - add-migration seed
    - update-database

1. Fixed up Donovan's click events for the grid

    - bad dataID != dataId bug
    - used a ternary operator on the label text instead of having visibility changes

1. Suggested functionality: Load data on toggle of rdo buttons

    - We spent some time wiring this up and getting it working
    - We also examined the idea of what might happen if there is a circular reference 

1. Add a search method

    - consider what are the possible results
    - show them in the grid
    - allow user to click on it still
    - Search by:
        - Get a search term Last Name, First Name

## Conclusion

Another good day of hammering things out.  We now have full CRUD on students and teachers and we have some searching capabilities.

## Day 4

Additional work on the CRUD and getting some filtering, then we will hammer out a couple of relationships.

### Morning

Relationships

1. Modeled out in UML

1. Created the course object with relationship to Teachers

    ```cs
    public class Course
    {
        [Key]
        public int Id { get; set; }
        [Required, StringLength(50)]
        public string Name { get; set; }
        [Required, StringLength(50)]
        public string Abbreviation { get; set; }
        [Required, StringLength(50)]
        public string Department { get; set; }
        [Required]
        public int NumCredits { get; set; }
        public int TeacherId { get; set; }
        public virtual Teacher Teacher { get; set; }
    }
    ```
1. Created the CourseEnrollments Table to map Students and Courses in a many-to-many relationship.

    ```cs
    public class CourseEnrollment
    {
        public int Id { get; set; }
        [Required]
        public int StudentId { get; set; }
        public virtual Student Student { get; set; }
        [Required]
        public int CourseId { get; set; }
        public virtual Course Course { get; set; }
    }
    ```  

1. Added the lists to each side in both Student and Course classes.

    ```cs
    public virtual List<CourseEnrollment> CourseEnrollments { get; set; } = new List<CourseEnrollment>();
    ```  

1. Added migrations and created the diagrams.

1. Created the Courses Tab on the form and moved the Student/Teacher stuff into Tab 1

1. Added code to populate the instructors (teachers) combobox from a list of teachers

    Put this in the Load Teachers method.

    ```c#
    var data = dgvResults.DataSource as BindingList<Teacher>;
    cboInstructors.Items.AddRange(data.ToArray<Teacher>());
    ```  

1. Added a FriendlyName property to the teacher object

    ```c#
    public string FriendlyName => $"{FirstName} {LastName}";
    ```  

1. Used the DisplayMember and ValueMember on the combobox to map properties

    In the Load Teachers after the populate the cboInstructors...

    ```c#
    cboInstructors.DisplayMember = "FriendlyName";
    cboInstructors.ValueMember = "Id";
    ```  

### Afternoon

Continue work on the Courses CRUD & Courses form.  If time, we'll build another tab for the ability to associate students to courses

1. Added the ability to List, Add, and Update courses

    - Load Courses  

    ```cs
    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        var dbCourses = new BindingList<Course>(context.Courses.ToList());
        dgvCourses.DataSource = dbCourses;
        dgvCourses.Refresh();
    }
    ```  

    - Courses Grid Cell Click

    ```cs
    var theRow = dgvResults.Rows[e.RowIndex];
    int dataId = 0;

    foreach (DataGridViewTextBoxCell cell in theRow.Cells)
    {
        if (cell.OwningColumn.Name.Equals("Id", StringComparison.OrdinalIgnoreCase))
        {
            dataId = (int)cell.Value;
            if (dataId == 0)
            {
                MessageBox.Show("Bad row clicked");
                ResetForm();
                return;
            }
        }
    }

    using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
    {
        var d = context.Courses.SingleOrDefault(x => x.Id == dataId);
        if (d is not null)
        {
            lblCourseId.Text = d.Id.ToString();
            txtCourseName.Text = d.Name;
            txtCourseAbbreviation.Text = d.Abbreviation;
            txtCourseDepartment.Text = d.Department;

            foreach (var item in cboNumCredits.Items)
            {
                if (Convert.ToInt32(item) == d.NumCredits)
                {
                    cboNumCredits.SelectedItem = item;
                }
            }

            foreach (var item in cboInstructors.Items)
            {
                var t = (Teacher)item;
                if (t.Id == d.TeacherId)
                {
                    cboInstructors.SelectedItem = item;
                }
            }
        } 
    }

    ```  

    - Reset the selected index/combo items for instructors on form load and on the LoadTeachers method

    ```cs
    cboInstructors.SelectedIndex = -1;
    cboInstructors.Items.Clear();
    var data = dgvResults.DataSource as BindingList<Teacher>;
    cboInstructors.Items.AddRange(data.ToArray<Teacher>());
    cboInstructors.DisplayMember = "FriendlyName";
    cboInstructors.ValueMember = "Id";
    ```  

    - Add/Update Courses

    ```cs
    bool modified = true;
    var courseInfo = new Course();
    courseInfo.Id = Convert.ToInt32(lblCourseId.Text);
    courseInfo.Abbreviation = txtCourseAbbreviation.Text;
    courseInfo.Department = txtCourseDepartment.Text;
    courseInfo.Name = txtCourseName.Text;
    courseInfo.NumCredits = Convert.ToInt32(cboNumCredits.SelectedItem);
    courseInfo.TeacherId = ((Teacher)cboInstructors.SelectedItem).Id;

    if (courseInfo.Id > 0)
    {
        //update
        using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
        {
            //see if course exists
            var existingCourse = context.Courses.SingleOrDefault(c => c.Id == courseInfo.Id);

            if (existingCourse is not null)
            {
                existingCourse.Abbreviation = courseInfo.Abbreviation;
                existingCourse.Department = courseInfo.Department;
                existingCourse.Name = courseInfo.Name;
                existingCourse.NumCredits = courseInfo.NumCredits;
                existingCourse.TeacherId = courseInfo.TeacherId;
                context.SaveChanges();
                modified = true;
            }
            else
            {
                MessageBox.Show("Course not found, could not update!", "Not Found!", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
    }
    else
    {
        //add
        using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
        {
            //see if course exists by properties:
            var existingCourse = context.Courses.SingleOrDefault(c => c.Name.ToLower() == courseInfo.Name.ToLower()
                                && c.Abbreviation.ToLower() == courseInfo.Abbreviation.ToLower()
                                && c.TeacherId == courseInfo.TeacherId);

            if (existingCourse is null)
            {
                context.Courses.Add(courseInfo);
                context.SaveChanges();
                modified = true;
            }
            else
            {
                MessageBox.Show("Course not found, could not update!", "Not Found!", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
    }

    if (modified)
    {
        ResetCourseForm();
        LoadCourses();
    }

    ```  

    - Reset the Form

    ```cs
    lblCourseId.Text = "0";
    txtCourseAbbreviation.Text = string.Empty;
    txtCourseDepartment.Text = string.Empty;
    txtCourseName.Text = string.Empty;
    cboInstructors.SelectedIndex = -1;
    cboNumCredits.SelectedIndex = 2;
    ```  

1. Added a method to respond to the selected tab index changed  

    ```cs
    private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
    {
        var selIndex = ((TabControl)sender).SelectedIndex;

        switch (selIndex)
        {
            case 0:
                //MessageBox.Show("Index 0");
                break;
            case 1:
                //MessageBox.Show("Index 1");
                LoadCourses();
                ResetForm();
                break;
            case 2:
                //MessageBox.Show("Index 2");
                break;
            default:
                break;
        }
    }
    ```  

1. We also decided to default the course credit selection to 3 so that it would always be set.

1. Just need to finish up the delete on Monday to complete CRUD on the courses

## Conclusion

Today we learned about creating relationships in code, with one-to-many and many-to-many relationships.

We then leveraged that to create a Course table and a join table for Students to Courses with a CourseEnrollments table.  This will allow each student to have many courses and each course to have many students.

We have also added an Instructor ID to the courses and this allows each course to have only one instructor while each instructor can have many courses.

Our CRUD operations were a bit more tricky as we learned about using combo boxes and identified a number of additional bugs that we had to fix to make sure our application works correctly for the user.

We also had a number of awesome questions and trouble-shooting sessions that led to some really great learning opportunities.

## Week 4 Wrap up

We have learned a ton this week about working with code in the UI for a WinForms application.  Event-driven development is a lot different than procedural development and there are some good and bad trade-offs in this approach.  We don't have to worry about prompting for information, as the form layout takes care of that for us.  However, we have a lot less control about the order that users do things so we have to be extra careful to prevent errors. 

We have also learned a lot about Entity Framework and code-first development.  We're close to being experts already! 

Next week we'll continue on and learn how to work with many-to-many relationships for associating students to courses and we'll take a look at some remaining concepts with C# that we need to start utilizing. 

On to week 5!
