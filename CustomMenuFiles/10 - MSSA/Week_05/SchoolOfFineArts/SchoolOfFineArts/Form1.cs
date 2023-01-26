using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SchoolOfFineArtsDB;
using SchoolOfFineArtsModels;
using SchoolOfFineArtsModels.DTOs;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text;
using System.Windows.Forms;

namespace SchoolOfFineArts
{
    public partial class Form1 : Form
    {
        private BindingList<Teacher> teachers = new BindingList<Teacher>();
        //use readonly as they are only set at form creation
        private readonly string _cnstr;
        private readonly DbContextOptionsBuilder _optionsBuilder;
        private readonly TeacherRepo _teacherRepo;
        public Form1()
        {
            InitializeComponent();
            dgvResults.DataSource = teachers;
            _cnstr = Program._configuration["ConnectionStrings:SchoolOfFineArtsDB"];
            _optionsBuilder = new DbContextOptionsBuilder<SchoolOfFineArtsDBContext>().UseSqlServer(_cnstr);
            _teacherRepo = new TeacherRepo(_optionsBuilder);
        }

        private void btnAddTeacher_Click(object sender, EventArgs e)
        {
            bool modified = false;
            if (rdoTeacher.Checked)
            {
                var teacher = new Teacher();
                teacher.Id = Convert.ToInt32(Math.Round(numId.Value));
                teacher.FirstName = txtFirstName.Text;
                teacher.LastName = txtLastName.Text;
                teacher.Age = (int)numTeacherAge.Value;
                //Ensure teacher not in database
                using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
                {
                    if (teacher.Id > 0)
                    {
                        var existingTeacher = context.Teachers.SingleOrDefault(t => t.Id == teacher.Id);
                        if (existingTeacher is not null)
                        {
                            existingTeacher.FirstName = teacher.FirstName;
                            existingTeacher.LastName = teacher.LastName;
                            existingTeacher.Age = teacher.Age;
                            context.SaveChanges();
                            modified = true;
                        }
                        else
                        {
                            MessageBox.Show("Teacher not found, could not update.");
                        }
                    }
                    else
                    {
                        var existingTeacher = context.Teachers.SingleOrDefault(t => t.FirstName.ToLower() == teacher.FirstName.ToLower()
                                                                 && t.LastName.ToLower() == teacher.LastName.ToLower()
                                                                 && t.Age == teacher.Age);
                        //if not add teacher
                        if (existingTeacher is null)
                        {
                            context.Teachers.Add(teacher);
                            context.SaveChanges();
                            modified = true;
                        }
                        else
                        {
                            MessageBox.Show("Teacher already exists, did you mean to update?");
                        }
                    }
                    if (modified)
                    {
                        ResetForm();
                        //var dbTeachers = new BindingList<Teacher>(context.Teachers.ToList());
                        //dgvResults.DataSource = dbTeachers;
                        //dgvResults.Refresh();
                        LoadTeachers();
                    }
                }
            }
            else if (rdoStudent.Checked)
            {
                var s = new Student();
                s.Id = Convert.ToInt32(Math.Round(numId.Value));
                s.FirstName = txtFirstName.Text;
                s.LastName = txtLastName.Text;
                s.DateOfBirth = dtStudentDateOfBirth.Value.Date;
                //Ensure teacher not in database
                using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
                {
                    if (s.Id > 0)
                    {
                        var existingStudent = context.Students.SingleOrDefault(t => t.Id == s.Id);
                        if (existingStudent is not null)
                        {
                            existingStudent.FirstName = s.FirstName;
                            existingStudent.LastName = s.LastName;
                            existingStudent.DateOfBirth = s.DateOfBirth;
                            context.SaveChanges();
                            modified = true;
                        }
                        else
                        {
                            MessageBox.Show("Student not found, could not update.");
                        }
                    }
                    else
                    {
                        var existingStudent = context.Students.SingleOrDefault(t => t.FirstName.ToLower() == s.FirstName.ToLower()
                                                                 && t.LastName.ToLower() == s.LastName.ToLower()
                                                                 && t.DateOfBirth == s.DateOfBirth);
                        //if not add teacher
                        if (existingStudent is null)
                        {
                            context.Students.Add(s);
                            context.SaveChanges();
                            modified = true;
                        }
                        else
                        {
                            MessageBox.Show("Student already exists, did you mean to update?");
                        }
                    }
                    if (modified)
                    {
                        ResetForm();
                        //var dbStudents = new BindingList<Student>(context.Students.ToList());
                        //dgvResults.DataSource = dbStudents;
                        //dgvResults.Refresh();
                        LoadStudents();
                    }
                }
            }
        }

        private void btnLoadTeachers_Click(object sender, EventArgs e)
        {
            LoadTeachers();
        }

        private void LoadTeachers(bool isSearch = false)
        {
            //take advantage of disposability of the connection and context:
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                var databaseTeachers = new BindingList<Teacher>(context.Teachers.ToList());
                dgvResults.DataSource = databaseTeachers;
                dgvResults.Refresh();
            }

            if (!isSearch)
            {
                cboInstructors.SelectedIndex = -1;
                cboInstructors.Items.Clear();
                var data = dgvResults.DataSource as BindingList<Teacher>;
                cboInstructors.Items.AddRange(data.ToArray<Teacher>());
                cboInstructors.DisplayMember = "FriendlyName";
                cboInstructors.ValueMember = "Id";
            }
        }

        private void LoadTeachersBetter()
        {
            var databaseTeachers = new BindingList<Teacher>(_teacherRepo.GetAll());
            dgvResults.DataSource = databaseTeachers;
            dgvResults.Refresh();
        }

        private void btnLoadStudents_Click(object sender, EventArgs e)
        {
            LoadStudents();
        }

        private void LoadStudents()
        {
            //take advantage of disposability of the connection and context:
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                var dbStudents = new BindingList<Student>(context.Students.ToList());
                dgvResults.DataSource = dbStudents;
                dgvResults.Refresh();

                lstStudents.Items.Clear();
                lstStudents.ClearSelected();
                lstStudents.Items.AddRange(dbStudents.ToArray());
            }
        }

        private void rdoTeacher_CheckedChanged(object sender, EventArgs e)
        {
            ToggleControlVisibility();
            if (rdoTeacher.Checked)
            {
                LoadTeachers();
                ResetForm();
            }
        }

        private void ToggleControlVisibility()
        {
            lblAge.Visible = rdoTeacher.Checked;
            numTeacherAge.Visible = rdoTeacher.Checked;
            lblDateOfBirth.Visible = rdoStudent.Checked;
            dtStudentDateOfBirth.Visible = rdoStudent.Checked;
        }

        private void rdoStudent_CheckedChanged(object sender, EventArgs e)
        {
            ToggleControlVisibility();
            if (rdoStudent.Checked)
            {
                LoadStudents();
                ResetForm();
            }
        }

        private void dgvResults_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.RowIndex < 0)
                {
                    MessageBox.Show("Bad row clicked");
                    return;
                }
            }
            catch (Exception ex)
            {

            }
            var theRow = dgvResults.Rows[e.RowIndex];
            int dataId = 0;
            bool isTeacher = false;
            bool isStudent = false;
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
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
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
                        LoadTeachers();
                    }
                    else
                    {
                        MessageBox.Show("Teacher not found, couldn't delete!");
                    }
                }
                else if (rdoStudent.Checked)
                {
                    var d = context.Students.SingleOrDefault(s => s.Id == Id);
                    if (d != null)
                    {
                        context.Students.Remove(d);
                        context.SaveChanges();
                        LoadStudents();
                    }
                    else
                    {
                        MessageBox.Show("Student not found, couldn't delete!");
                    }
                }
                dgvResults.Refresh();
                ResetForm();
            }
        }

        private void btnResetForm_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            numId.Value = 0;
            txtFirstName.Text = string.Empty;
            txtLastName.Text = string.Empty;
            dgvResults.ClearSelection();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            LoadStudents();
            LoadCourses();
            LoadTeachers();
            LoadCourseInfoDTOs();
            ResetForm();
            ResetCourseForm();
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            if (rdoTeacher.Checked)
            {
                LoadTeachers(true);
                var tList = dgvResults.DataSource as BindingList<Teacher>;
                var fList = tList.Where(x => x.LastName.ToLower().Contains(txtLastName.Text.ToLower())
                                            && x.FirstName.ToLower().Contains(txtFirstName.Text.ToLower())).ToList();
                dgvResults.DataSource = new BindingList<Teacher>(fList);
                dgvResults.ClearSelection();
            }
            else if (rdoStudent.Checked)
            {
                LoadStudents();
                var sList = dgvResults.DataSource as BindingList<Student>;
                var fList = sList.Where(x => x.LastName.ToLower().Contains(txtLastName.Text.ToLower())
                                            && x.FirstName.ToLower().Contains(txtFirstName.Text.ToLower())).ToList();
                dgvResults.DataSource = new BindingList<Student>(fList);
                dgvResults.ClearSelection();
            }
        }

        //Add courses:
        private void btnAddCourses_Click(object sender, EventArgs e)
        {
            //var teacher = (Teacher)cboInstructors.SelectedItem;
            //var teacherId = teacher.Id;
            //var teacherIdOneLine = ((Teacher)cboInstructors.SelectedItem).Id;

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
        }

        public void ResetCourseForm()
        {
            lblCourseId.Text = "0";
            txtCourseAbbreviation.Text = string.Empty;
            txtCourseDepartment.Text = string.Empty;
            txtCourseName.Text = string.Empty;
            cboInstructors.SelectedIndex = -1;
            cboNumCredits.SelectedIndex = 2;
        }

        public void LoadCourses()
        {
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                var dbCourses = new BindingList<Course>(context.Courses.Include(x => x.Teacher).ToList());

                //var otherCourses = context.Courses.Include(x => x.Teacher)
                //                            .Select(y => new
                //                            {
                //                                Id = y.Id,
                //                                Name = y.Name,
                //                                TeacherId = y.TeacherId,
                //                                Abbreviation = y.Abbreviation,
                //                                Department = y.Department,
                //                                NumCredits = y.NumCredits,
                //                                Instructor = $"{y.Teacher.FirstName} {y.Teacher.LastName}"
                //                            }).ToList();
                dgvCourses.DataSource = dbCourses;
                //dgvCourses.DataSource = otherCourses.ToList();
                dgvCourses.Refresh();
                dgvCourseAssignments.DataSource = dbCourses;
                dgvCourseAssignments.Refresh();
            }
        }

        private void btnResetCourseForm_Click(object sender, EventArgs e)
        {
            ResetCourseForm();
        }

        private void btnLoadCourses_Click(object sender, EventArgs e)
        {
            LoadCourses();
        }

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

        private void dgvCourses_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.RowIndex < 0)
                {
                    MessageBox.Show("Bad row clicked");
                    return;
                }
            }
            catch (Exception ex)
            {

            }
            var theRow = dgvCourses.Rows[e.RowIndex];
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
        }

        private void btnRemoveCourses_Click(object sender, EventArgs e)
        {
            var Id = Convert.ToInt32(lblCourseId.Text);
            var courseName = txtCourseName.Text;
            var confirmDelete = MessageBox.Show($"Are you sure you want to delete the course {courseName}?"
                , "Are you sure?"
                , MessageBoxButtons.YesNo);
            if (confirmDelete == DialogResult.No)
            {
                return;
            }
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                
                var d = context.Courses.SingleOrDefault(t => t.Id == Id);
                if (d != null)
                {
                    context.Courses.Remove(d);
                    context.SaveChanges();
                    LoadCourses();
                }
                else
                {
                    MessageBox.Show("Course not found, couldn't delete!");
                }
                
                dgvCourses.Refresh();
                ResetCourseForm();
            }
        }

        private void lstStudents_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void dgvCourseAssignments_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.RowIndex < 0)
                {
                    ResetCourseGridAndSelections();
                    return;
                }
            }
            catch (Exception ex)
            {
                ResetCourseGridAndSelections();
            }
            var theRow = dgvCourseAssignments.Rows[e.RowIndex];
            int dataId = 0;

            foreach (DataGridViewTextBoxCell cell in theRow.Cells)
            {
                if (cell.OwningColumn.Name.Equals("Id", StringComparison.OrdinalIgnoreCase))
                {
                    dataId = (int)cell.Value;
                    if (dataId == 0)
                    {
                        MessageBox.Show("Bad row clicked");
                        return;
                    }

                    lblSelectedCourseId.Text = $"{cell.Value}";
                }
                if (cell.OwningColumn.Name.Equals("Name", StringComparison.OrdinalIgnoreCase))
                {
                    lblSelectedCourseName.Text = $"{cell.Value}";
                }
            }
        }

        private void ResetCourseAssignmentsForm()
        {
            ResetCourseGridAndSelections();
            ClearStudentSelections();
            LoadCourseInfoDTOs();
        }

        private void ResetCourseGridAndSelections()
        {
            dgvCourseAssignments.ClearSelection();
            lblSelectedCourseId.Text = "0";
            lblSelectedCourseName.Text = string.Empty;
        }

        private void ClearStudentSelections()
        {
            foreach (int index in lstStudents.CheckedIndices)
            {
                lstStudents.SetItemCheckState(index, CheckState.Unchecked);
            }
            lstStudents.ClearSelected();
        }

        private void btnClearSelectedStudents_Click(object sender, EventArgs e)
        {
            ClearStudentSelections();
        }

        private void btnAssociateCourses_Click(object sender, EventArgs e)
        {
            //verify at least one student
            if (lstStudents.CheckedIndices.Count == 0)
            {
                MessageBox.Show("You must select at least one student"
                                , "Select a student!"
                                , MessageBoxButtons.OK
                                , MessageBoxIcon.Error);
                return;
            }
            //verify the course is also selected
            if (string.IsNullOrWhiteSpace(lblSelectedCourseId.Text) || Convert.ToInt32(lblSelectedCourseId.Text) <= 0)
            {
                MessageBox.Show("You must select a course"
                                    , "Select a course!"
                                    , MessageBoxButtons.OK
                                    , MessageBoxIcon.Error);
                return;
            }

            var students = lstStudents.CheckedItems.Cast<Student>().ToList();

            StringBuilder sb = new StringBuilder();
            foreach (var s in students)
            {
                if (sb.Length > 0)
                {
                    sb.Append(", ");
                }
                sb.Append($"{s.FriendlyName}");
            }
            
            var studentNames = sb.ToString();
            //var lastCommaIndex = studentNames.LastIndexOf(',');
            //studentNames = studentNames.Insert(lastCommaIndex + 1, " and");

            var msg = $"Are you sure you want to associate {studentNames} to {lblSelectedCourseName.Text}";
            
            //confirm associate
            var confirmAssociate = MessageBox.Show(msg, "Are you sure?", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (confirmAssociate == DialogResult.No)
            {
                //confirm clear
                var confirmClear = MessageBox.Show("Would you like to reset the form?"
                                                    , "Reset Form?"
                                                    , MessageBoxButtons.YesNo
                                                    , MessageBoxIcon.Question);
                if (confirmClear == DialogResult.Yes)
                {
                    ResetCourseAssignmentsForm();
                    MessageBox.Show("Associate Students to Courses form has been reset!", "Form Reset", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                return;
            }

            //associate
            var courseId = Convert.ToInt32(lblSelectedCourseId.Text);
            var courseName = lblSelectedCourseName.Text;

            bool success = AssociateStudentsToCourse(students, courseId, courseName);
            if (success)
            {
                ResetCourseAssignmentsForm();
            }
        }

        private bool AssociateStudentsToCourse(List<Student> students, int courseId, string courseName)
        {
            bool modified = false;
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                //validate course exists
                var c = context.Courses.Include(x => x.CourseEnrollments).SingleOrDefault(c => c.Id == courseId);
                if (c == null)
                {
                    MessageBox.Show($"Course {courseName} not found, cannot continue!"
                                   , "No such course!"
                                   , MessageBoxButtons.OK
                                   , MessageBoxIcon.Error);
                    return false;
                }

                //iterate students
                foreach (var student in students)
                {
                    //validate student exists
                    var s = context.Students.Include(x => x.CourseEnrollments).SingleOrDefault(t => t.Id == student.Id);
                    if (s == null)
                    {
                        //student not good: message user
                        MessageBox.Show($"Student {student.FriendlyName} not found, cannot continue!"
                                        , "No such student!"
                                        , MessageBoxButtons.OK
                                        , MessageBoxIcon.Error);
                        //continue to next student
                        continue;
                    }

                    //check if already associated
                    var courseExists = false;
                    foreach (var enrollment in s.CourseEnrollments)
                    {
                        if (enrollment.CourseId.Equals(c.Id))
                        {
                            //already associated: Message user
                            MessageBox.Show($"Course {courseName} already associated to student " +
                                                $"{s.FriendlyName}, cannot continue!"
                                           , "Already Associated"
                                           , MessageBoxButtons.OK
                                           , MessageBoxIcon.Information);
                            //move to next student
                            courseExists = true;
                            break; //exit this for loop for course enrollments
                        }
                    }
                    if (courseExists)
                    {
                        //move to next student (next loop iteration for students)
                        continue;
                    }

                    //not associated - create
                    var ce = new CourseEnrollment();
                    //ce.Student = s;
                    ce.StudentId = s.Id;
                    ce.CourseId = courseId;
                    //ce.Course = c;
                    //c.CourseEnrollments.Add(ce);
                    s.CourseEnrollments.Add(ce);
                    modified = true;
                }
                if (modified)
                {
                    context.SaveChanges();
                    MessageBox.Show($"Successfully associated students to {courseName}"
                                    , "Success!"
                                    , MessageBoxButtons.OK
                                    , MessageBoxIcon.Information);
                }
            }
            return true;
        }

        public void LoadCourseInfoDTOs()
        {
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                var dbCourseInfoDTOs = new BindingList<CourseInfoDTO>(context.CourseInfoDTOs
                                                            .FromSqlRaw("SELECT * FROM dbo.vwCourseInfo" +
                                                            " ORDER BY StudentName, CourseName")
                                                            .ToList());
                dgvCourseInfos.DataSource = dbCourseInfoDTOs;
                dgvCourseInfos.Refresh();
                dgvCourseInfos.ClearSelection();
                lblSelectedStudentId.Text = "0";
                lblSelectedStudentName.Text = string.Empty;
            }
        }

        private void ResetCourseInfosGrid()
        {
            dgvCourseInfos.ClearSelection();
        }

        private void dgvCourseInfos_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (e.RowIndex < 0)
                {
                    ResetCourseInfosGrid();
                    return;
                }
            }
            catch (Exception ex)
            {
                ResetCourseInfosGrid();
            }

            var theRow = dgvCourseInfos.Rows[e.RowIndex];
            int dataId = 0;

            foreach (DataGridViewTextBoxCell cell in theRow.Cells)
            {
                if (cell.OwningColumn.Name.Equals("CourseId", StringComparison.OrdinalIgnoreCase))
                {
                    dataId = (int)cell.Value;
                    if (dataId == 0)
                    {
                        MessageBox.Show("Bad row clicked");
                        return;
                    }

                    lblSelectedCourseId.Text = $"{cell.Value}";
                }
                if (cell.OwningColumn.Name.Equals("CourseName", StringComparison.OrdinalIgnoreCase))
                {
                    lblSelectedCourseName.Text = $"{cell.Value}";
                }
                if (cell.OwningColumn.Name.Equals("StudentId", StringComparison.OrdinalIgnoreCase))
                {
                    dataId = (int)cell.Value;
                    if (dataId == 0)
                    {
                        MessageBox.Show("Bad row clicked");
                        return;
                    }

                    lblSelectedStudentId.Text = $"{cell.Value}";
                }
                if (cell.OwningColumn.Name.Equals("StudentName", StringComparison.OrdinalIgnoreCase))
                {
                    lblSelectedStudentName.Text = $"{cell.Value}";
                }
            }
        }

        private void btnRemoveCourseAssignment_Click(object sender, EventArgs e)
        {

            //verify a student is selected
            if (string.IsNullOrWhiteSpace(lblSelectedCourseId.Text) || Convert.ToInt32(lblSelectedCourseId.Text) <= 0)
            {
                MessageBox.Show("You must select a student"
                                , "Select a student!"
                                , MessageBoxButtons.OK
                                , MessageBoxIcon.Error);
                return;
            }
            //verify the course is also selected
            if (string.IsNullOrWhiteSpace(lblSelectedCourseId.Text) || Convert.ToInt32(lblSelectedCourseId.Text) <= 0)
            {
                MessageBox.Show("You must select a course"
                                    , "Select a course!"
                                    , MessageBoxButtons.OK
                                    , MessageBoxIcon.Error);
                return;
            }

            var confirmDelete = MessageBox.Show("Are you sure you want to delete this item?"
                , "Are you sure?"
                , MessageBoxButtons.YesNo);
            if (confirmDelete == DialogResult.No)
            {
                ResetCourseAssignmentsForm();
                return;
            }


            //associate
            var studentId = Convert.ToInt32(lblSelectedStudentId.Text);
            var courseId = Convert.ToInt32(lblSelectedCourseId.Text);

            bool success = RemoveStudentFromCourse(studentId, courseId);
            if (success)
            {
                ResetCourseAssignmentsForm();
            }
        }

        private bool RemoveStudentFromCourse(int studentId, int courseId)
        {
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                //validate course exists
                var courseName = lblSelectedCourseName.Text;
                var c = context.Courses.Include(x => x.CourseEnrollments).SingleOrDefault(c => c.Id == courseId);
                if (c == null)
                {
                    MessageBox.Show($"Course not found, cannot continue!"
                                   , "No such course!"
                                   , MessageBoxButtons.OK
                                   , MessageBoxIcon.Error);
                    return false;
                }

                //validate student exists
                var studentName = lblSelectedStudentName.Text;
                var s = context.Students.Include(x => x.CourseEnrollments).SingleOrDefault(t => t.Id == studentId);
                if (s == null)
                {
                    //student not good: message user
                    MessageBox.Show($"Student {studentName} not found, cannot continue!"
                                    , "No such student!"
                                    , MessageBoxButtons.OK
                                    , MessageBoxIcon.Error);
                    return false;
                }

                var match = new CourseEnrollment();
                foreach (var ce in s.CourseEnrollments)
                {
                    if (ce.CourseId == courseId)
                    {
                        match = ce;
                    }
                }
                if (match.Id > 0 && match.CourseId == courseId && match.StudentId == studentId)
                {
                    s.CourseEnrollments.Remove(match);

                    context.SaveChanges();
                    MessageBox.Show($"Successfully removed {studentName} from {courseName}"
                                    , "Success!"
                                    , MessageBoxButtons.OK
                                    , MessageBoxIcon.Information);
                    return true;
                }
            }
            return false;
        }
    }
}