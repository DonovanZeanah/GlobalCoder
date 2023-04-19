namespace SchoolOfFineArts
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lblDateOfBirth = new System.Windows.Forms.Label();
            this.txtFirstName = new System.Windows.Forms.TextBox();
            this.txtLastName = new System.Windows.Forms.TextBox();
            this.btnAddTeacher = new System.Windows.Forms.Button();
            this.dtStudentDateOfBirth = new System.Windows.Forms.DateTimePicker();
            this.numId = new System.Windows.Forms.NumericUpDown();
            this.dgvResults = new System.Windows.Forms.DataGridView();
            this.lblAge = new System.Windows.Forms.Label();
            this.numTeacherAge = new System.Windows.Forms.NumericUpDown();
            this.btnLoadTeachers = new System.Windows.Forms.Button();
            this.rdoTeacher = new System.Windows.Forms.RadioButton();
            this.rdoStudent = new System.Windows.Forms.RadioButton();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnLoadStudents = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.btnResetForm = new System.Windows.Forms.Button();
            this.btnSearch = new System.Windows.Forms.Button();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.btnResetCourseForm = new System.Windows.Forms.Button();
            this.dgvCourses = new System.Windows.Forms.DataGridView();
            this.cboNumCredits = new System.Windows.Forms.ComboBox();
            this.txtCourseAbbreviation = new System.Windows.Forms.TextBox();
            this.txtCourseDepartment = new System.Windows.Forms.TextBox();
            this.cboInstructors = new System.Windows.Forms.ComboBox();
            this.txtCourseName = new System.Windows.Forms.TextBox();
            this.btnRemoveCourses = new System.Windows.Forms.Button();
            this.btnLoadCourses = new System.Windows.Forms.Button();
            this.btnAddCourses = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.lblCourseId = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.tabStudentCourses = new System.Windows.Forms.TabPage();
            this.lblSelectedStudentName = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.lblSelectedStudentId = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.dgvCourseInfos = new System.Windows.Forms.DataGridView();
            this.btnAssociateCourses = new System.Windows.Forms.Button();
            this.btnClearSelectedStudents = new System.Windows.Forms.Button();
            this.lblSelectedCourseName = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.lblSelectedCourseId = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.dgvCourseAssignments = new System.Windows.Forms.DataGridView();
            this.lstStudents = new System.Windows.Forms.CheckedListBox();
            this.btnRemoveCourseAssignment = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.numId)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvResults)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numTeacherAge)).BeginInit();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourses)).BeginInit();
            this.tabStudentCourses.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseInfos)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseAssignments)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(33, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(20, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "Id:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(20, 66);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(67, 15);
            this.label2.TabIndex = 1;
            this.label2.Text = "First Name:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(20, 98);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(66, 15);
            this.label3.TabIndex = 2;
            this.label3.Text = "Last Name:";
            // 
            // lblDateOfBirth
            // 
            this.lblDateOfBirth.AutoSize = true;
            this.lblDateOfBirth.Location = new System.Drawing.Point(9, 167);
            this.lblDateOfBirth.Name = "lblDateOfBirth";
            this.lblDateOfBirth.Size = new System.Drawing.Size(78, 15);
            this.lblDateOfBirth.TabIndex = 6;
            this.lblDateOfBirth.Text = "Date Of Birth:";
            this.lblDateOfBirth.Visible = false;
            // 
            // txtFirstName
            // 
            this.txtFirstName.Location = new System.Drawing.Point(89, 58);
            this.txtFirstName.Name = "txtFirstName";
            this.txtFirstName.Size = new System.Drawing.Size(167, 23);
            this.txtFirstName.TabIndex = 8;
            // 
            // txtLastName
            // 
            this.txtLastName.Location = new System.Drawing.Point(89, 94);
            this.txtLastName.Name = "txtLastName";
            this.txtLastName.Size = new System.Drawing.Size(167, 23);
            this.txtLastName.TabIndex = 9;
            // 
            // btnAddTeacher
            // 
            this.btnAddTeacher.Location = new System.Drawing.Point(31, 221);
            this.btnAddTeacher.Name = "btnAddTeacher";
            this.btnAddTeacher.Size = new System.Drawing.Size(116, 23);
            this.btnAddTeacher.TabIndex = 16;
            this.btnAddTeacher.Text = "Add or Update";
            this.btnAddTeacher.UseVisualStyleBackColor = true;
            this.btnAddTeacher.Click += new System.EventHandler(this.btnAddTeacher_Click);
            // 
            // dtStudentDateOfBirth
            // 
            this.dtStudentDateOfBirth.Location = new System.Drawing.Point(89, 161);
            this.dtStudentDateOfBirth.Name = "dtStudentDateOfBirth";
            this.dtStudentDateOfBirth.Size = new System.Drawing.Size(200, 23);
            this.dtStudentDateOfBirth.TabIndex = 18;
            this.dtStudentDateOfBirth.Visible = false;
            // 
            // numId
            // 
            this.numId.Location = new System.Drawing.Point(91, 22);
            this.numId.Maximum = new decimal(new int[] {
            2147000000,
            0,
            0,
            0});
            this.numId.Name = "numId";
            this.numId.ReadOnly = true;
            this.numId.Size = new System.Drawing.Size(165, 23);
            this.numId.TabIndex = 19;
            // 
            // dgvResults
            // 
            this.dgvResults.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvResults.Location = new System.Drawing.Point(31, 262);
            this.dgvResults.Name = "dgvResults";
            this.dgvResults.RowTemplate.Height = 25;
            this.dgvResults.Size = new System.Drawing.Size(642, 316);
            this.dgvResults.TabIndex = 20;
            this.dgvResults.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvResults_CellClick);
            // 
            // lblAge
            // 
            this.lblAge.AutoSize = true;
            this.lblAge.Location = new System.Drawing.Point(56, 163);
            this.lblAge.Name = "lblAge";
            this.lblAge.Size = new System.Drawing.Size(31, 15);
            this.lblAge.TabIndex = 22;
            this.lblAge.Text = "Age:";
            // 
            // numTeacherAge
            // 
            this.numTeacherAge.Location = new System.Drawing.Point(89, 161);
            this.numTeacherAge.Maximum = new decimal(new int[] {
            2147000000,
            0,
            0,
            0});
            this.numTeacherAge.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numTeacherAge.Name = "numTeacherAge";
            this.numTeacherAge.Size = new System.Drawing.Size(165, 23);
            this.numTeacherAge.TabIndex = 23;
            this.numTeacherAge.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // btnLoadTeachers
            // 
            this.btnLoadTeachers.Location = new System.Drawing.Point(557, 221);
            this.btnLoadTeachers.Name = "btnLoadTeachers";
            this.btnLoadTeachers.Size = new System.Drawing.Size(116, 23);
            this.btnLoadTeachers.TabIndex = 24;
            this.btnLoadTeachers.Text = "Load Teachers";
            this.btnLoadTeachers.UseVisualStyleBackColor = true;
            this.btnLoadTeachers.Click += new System.EventHandler(this.btnLoadTeachers_Click);
            // 
            // rdoTeacher
            // 
            this.rdoTeacher.AutoSize = true;
            this.rdoTeacher.Checked = true;
            this.rdoTeacher.Location = new System.Drawing.Point(15, 7);
            this.rdoTeacher.Name = "rdoTeacher";
            this.rdoTeacher.Size = new System.Drawing.Size(65, 19);
            this.rdoTeacher.TabIndex = 25;
            this.rdoTeacher.TabStop = true;
            this.rdoTeacher.Text = "Teacher";
            this.rdoTeacher.UseVisualStyleBackColor = true;
            this.rdoTeacher.CheckedChanged += new System.EventHandler(this.rdoTeacher_CheckedChanged);
            // 
            // rdoStudent
            // 
            this.rdoStudent.AutoSize = true;
            this.rdoStudent.Location = new System.Drawing.Point(86, 7);
            this.rdoStudent.Name = "rdoStudent";
            this.rdoStudent.Size = new System.Drawing.Size(66, 19);
            this.rdoStudent.TabIndex = 26;
            this.rdoStudent.Text = "Student";
            this.rdoStudent.UseVisualStyleBackColor = true;
            this.rdoStudent.CheckedChanged += new System.EventHandler(this.rdoStudent_CheckedChanged);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.rdoTeacher);
            this.panel1.Controls.Add(this.rdoStudent);
            this.panel1.Location = new System.Drawing.Point(91, 126);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(168, 29);
            this.panel1.TabIndex = 27;
            // 
            // btnLoadStudents
            // 
            this.btnLoadStudents.Location = new System.Drawing.Point(435, 221);
            this.btnLoadStudents.Name = "btnLoadStudents";
            this.btnLoadStudents.Size = new System.Drawing.Size(116, 23);
            this.btnLoadStudents.TabIndex = 28;
            this.btnLoadStudents.Text = "Load Students";
            this.btnLoadStudents.UseVisualStyleBackColor = true;
            this.btnLoadStudents.Click += new System.EventHandler(this.btnLoadStudents_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Location = new System.Drawing.Point(153, 221);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(116, 23);
            this.btnDelete.TabIndex = 29;
            this.btnDelete.Text = "Delete";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // btnResetForm
            // 
            this.btnResetForm.Location = new System.Drawing.Point(314, 221);
            this.btnResetForm.Name = "btnResetForm";
            this.btnResetForm.Size = new System.Drawing.Size(115, 23);
            this.btnResetForm.TabIndex = 30;
            this.btnResetForm.Text = "Reset Form";
            this.btnResetForm.UseVisualStyleBackColor = true;
            this.btnResetForm.Click += new System.EventHandler(this.btnResetForm_Click);
            // 
            // btnSearch
            // 
            this.btnSearch.Location = new System.Drawing.Point(275, 94);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(100, 23);
            this.btnSearch.TabIndex = 31;
            this.btnSearch.Text = "Search";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabStudentCourses);
            this.tabControl1.Location = new System.Drawing.Point(3, 1);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(729, 636);
            this.tabControl1.TabIndex = 32;
            this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.numId);
            this.tabPage1.Controls.Add(this.lblDateOfBirth);
            this.tabPage1.Controls.Add(this.btnSearch);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.btnResetForm);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.btnDelete);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Controls.Add(this.btnLoadStudents);
            this.tabPage1.Controls.Add(this.txtFirstName);
            this.tabPage1.Controls.Add(this.panel1);
            this.tabPage1.Controls.Add(this.txtLastName);
            this.tabPage1.Controls.Add(this.btnLoadTeachers);
            this.tabPage1.Controls.Add(this.btnAddTeacher);
            this.tabPage1.Controls.Add(this.numTeacherAge);
            this.tabPage1.Controls.Add(this.dtStudentDateOfBirth);
            this.tabPage1.Controls.Add(this.lblAge);
            this.tabPage1.Controls.Add(this.dgvResults);
            this.tabPage1.Location = new System.Drawing.Point(4, 24);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(721, 608);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Students and Teachers";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.btnResetCourseForm);
            this.tabPage2.Controls.Add(this.dgvCourses);
            this.tabPage2.Controls.Add(this.cboNumCredits);
            this.tabPage2.Controls.Add(this.txtCourseAbbreviation);
            this.tabPage2.Controls.Add(this.txtCourseDepartment);
            this.tabPage2.Controls.Add(this.cboInstructors);
            this.tabPage2.Controls.Add(this.txtCourseName);
            this.tabPage2.Controls.Add(this.btnRemoveCourses);
            this.tabPage2.Controls.Add(this.btnLoadCourses);
            this.tabPage2.Controls.Add(this.btnAddCourses);
            this.tabPage2.Controls.Add(this.label9);
            this.tabPage2.Controls.Add(this.label8);
            this.tabPage2.Controls.Add(this.label7);
            this.tabPage2.Controls.Add(this.label6);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.lblCourseId);
            this.tabPage2.Controls.Add(this.label4);
            this.tabPage2.Location = new System.Drawing.Point(4, 24);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(721, 608);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Courses";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // btnResetCourseForm
            // 
            this.btnResetCourseForm.Location = new System.Drawing.Point(447, 241);
            this.btnResetCourseForm.Name = "btnResetCourseForm";
            this.btnResetCourseForm.Size = new System.Drawing.Size(123, 23);
            this.btnResetCourseForm.TabIndex = 17;
            this.btnResetCourseForm.Text = "Reset Form";
            this.btnResetCourseForm.UseVisualStyleBackColor = true;
            this.btnResetCourseForm.Click += new System.EventHandler(this.btnResetCourseForm_Click);
            // 
            // dgvCourses
            // 
            this.dgvCourses.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCourses.Location = new System.Drawing.Point(24, 290);
            this.dgvCourses.Name = "dgvCourses";
            this.dgvCourses.RowTemplate.Height = 25;
            this.dgvCourses.Size = new System.Drawing.Size(675, 237);
            this.dgvCourses.TabIndex = 16;
            this.dgvCourses.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCourses_CellClick);
            // 
            // cboNumCredits
            // 
            this.cboNumCredits.FormattingEnabled = true;
            this.cboNumCredits.Items.AddRange(new object[] {
            "1",
            "2",
            "3",
            "4",
            "5",
            "6"});
            this.cboNumCredits.Location = new System.Drawing.Point(133, 156);
            this.cboNumCredits.Name = "cboNumCredits";
            this.cboNumCredits.Size = new System.Drawing.Size(322, 23);
            this.cboNumCredits.TabIndex = 15;
            // 
            // txtCourseAbbreviation
            // 
            this.txtCourseAbbreviation.Location = new System.Drawing.Point(134, 97);
            this.txtCourseAbbreviation.Name = "txtCourseAbbreviation";
            this.txtCourseAbbreviation.Size = new System.Drawing.Size(323, 23);
            this.txtCourseAbbreviation.TabIndex = 14;
            // 
            // txtCourseDepartment
            // 
            this.txtCourseDepartment.Location = new System.Drawing.Point(133, 128);
            this.txtCourseDepartment.Name = "txtCourseDepartment";
            this.txtCourseDepartment.Size = new System.Drawing.Size(323, 23);
            this.txtCourseDepartment.TabIndex = 13;
            // 
            // cboInstructors
            // 
            this.cboInstructors.FormattingEnabled = true;
            this.cboInstructors.Location = new System.Drawing.Point(133, 186);
            this.cboInstructors.Name = "cboInstructors";
            this.cboInstructors.Size = new System.Drawing.Size(322, 23);
            this.cboInstructors.TabIndex = 12;
            // 
            // txtCourseName
            // 
            this.txtCourseName.Location = new System.Drawing.Point(134, 68);
            this.txtCourseName.Name = "txtCourseName";
            this.txtCourseName.Size = new System.Drawing.Size(323, 23);
            this.txtCourseName.TabIndex = 11;
            // 
            // btnRemoveCourses
            // 
            this.btnRemoveCourses.Location = new System.Drawing.Point(153, 241);
            this.btnRemoveCourses.Name = "btnRemoveCourses";
            this.btnRemoveCourses.Size = new System.Drawing.Size(123, 23);
            this.btnRemoveCourses.TabIndex = 9;
            this.btnRemoveCourses.Text = "Remove Course";
            this.btnRemoveCourses.UseVisualStyleBackColor = true;
            this.btnRemoveCourses.Click += new System.EventHandler(this.btnRemoveCourses_Click);
            // 
            // btnLoadCourses
            // 
            this.btnLoadCourses.Location = new System.Drawing.Point(576, 241);
            this.btnLoadCourses.Name = "btnLoadCourses";
            this.btnLoadCourses.Size = new System.Drawing.Size(123, 23);
            this.btnLoadCourses.TabIndex = 8;
            this.btnLoadCourses.Text = "Load Courses";
            this.btnLoadCourses.UseVisualStyleBackColor = true;
            this.btnLoadCourses.Click += new System.EventHandler(this.btnLoadCourses_Click);
            // 
            // btnAddCourses
            // 
            this.btnAddCourses.Location = new System.Drawing.Point(24, 241);
            this.btnAddCourses.Name = "btnAddCourses";
            this.btnAddCourses.Size = new System.Drawing.Size(123, 23);
            this.btnAddCourses.TabIndex = 7;
            this.btnAddCourses.Text = "Add/Update Course";
            this.btnAddCourses.UseVisualStyleBackColor = true;
            this.btnAddCourses.Click += new System.EventHandler(this.btnAddCourses_Click);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(53, 189);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(61, 15);
            this.label9.TabIndex = 6;
            this.label9.Text = "Instructor:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(6, 159);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(108, 15);
            this.label8.TabIndex = 5;
            this.label8.Text = "Number of Credits:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(41, 131);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(73, 15);
            this.label7.TabIndex = 4;
            this.label7.Text = "Department:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(36, 103);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(78, 15);
            this.label6.TabIndex = 3;
            this.label6.Text = "Abbreviation:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(72, 71);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(42, 15);
            this.label5.TabIndex = 2;
            this.label5.Text = "Name:";
            // 
            // lblCourseId
            // 
            this.lblCourseId.AutoSize = true;
            this.lblCourseId.Location = new System.Drawing.Point(134, 42);
            this.lblCourseId.Name = "lblCourseId";
            this.lblCourseId.Size = new System.Drawing.Size(13, 15);
            this.lblCourseId.TabIndex = 1;
            this.lblCourseId.Text = "0";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(93, 42);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(21, 15);
            this.label4.TabIndex = 0;
            this.label4.Text = "ID:";
            // 
            // tabStudentCourses
            // 
            this.tabStudentCourses.Controls.Add(this.btnRemoveCourseAssignment);
            this.tabStudentCourses.Controls.Add(this.lblSelectedStudentName);
            this.tabStudentCourses.Controls.Add(this.label15);
            this.tabStudentCourses.Controls.Add(this.lblSelectedStudentId);
            this.tabStudentCourses.Controls.Add(this.label14);
            this.tabStudentCourses.Controls.Add(this.dgvCourseInfos);
            this.tabStudentCourses.Controls.Add(this.btnAssociateCourses);
            this.tabStudentCourses.Controls.Add(this.btnClearSelectedStudents);
            this.tabStudentCourses.Controls.Add(this.lblSelectedCourseName);
            this.tabStudentCourses.Controls.Add(this.label13);
            this.tabStudentCourses.Controls.Add(this.label12);
            this.tabStudentCourses.Controls.Add(this.lblSelectedCourseId);
            this.tabStudentCourses.Controls.Add(this.label11);
            this.tabStudentCourses.Controls.Add(this.label10);
            this.tabStudentCourses.Controls.Add(this.dgvCourseAssignments);
            this.tabStudentCourses.Controls.Add(this.lstStudents);
            this.tabStudentCourses.Location = new System.Drawing.Point(4, 24);
            this.tabStudentCourses.Name = "tabStudentCourses";
            this.tabStudentCourses.Padding = new System.Windows.Forms.Padding(3);
            this.tabStudentCourses.Size = new System.Drawing.Size(721, 608);
            this.tabStudentCourses.TabIndex = 2;
            this.tabStudentCourses.Text = "Student Course Associations";
            this.tabStudentCourses.UseVisualStyleBackColor = true;
            // 
            // lblSelectedStudentName
            // 
            this.lblSelectedStudentName.AutoSize = true;
            this.lblSelectedStudentName.Location = new System.Drawing.Point(512, 250);
            this.lblSelectedStudentName.Name = "lblSelectedStudentName";
            this.lblSelectedStudentName.Size = new System.Drawing.Size(13, 15);
            this.lblSelectedStudentName.TabIndex = 14;
            this.lblSelectedStudentName.Text = "0";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(377, 250);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(133, 15);
            this.label15.TabIndex = 13;
            this.label15.Text = "Selected Student Name:";
            // 
            // lblSelectedStudentId
            // 
            this.lblSelectedStudentId.AutoSize = true;
            this.lblSelectedStudentId.Location = new System.Drawing.Point(345, 250);
            this.lblSelectedStudentId.Name = "lblSelectedStudentId";
            this.lblSelectedStudentId.Size = new System.Drawing.Size(13, 15);
            this.lblSelectedStudentId.TabIndex = 12;
            this.lblSelectedStudentId.Text = "0";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(203, 250);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(111, 15);
            this.label14.TabIndex = 11;
            this.label14.Text = "Selected Student Id:";
            // 
            // dgvCourseInfos
            // 
            this.dgvCourseInfos.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCourseInfos.Location = new System.Drawing.Point(22, 322);
            this.dgvCourseInfos.Name = "dgvCourseInfos";
            this.dgvCourseInfos.RowTemplate.Height = 25;
            this.dgvCourseInfos.Size = new System.Drawing.Size(690, 237);
            this.dgvCourseInfos.TabIndex = 10;
            this.dgvCourseInfos.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCourseInfos_CellClick);
            // 
            // btnAssociateCourses
            // 
            this.btnAssociateCourses.Location = new System.Drawing.Point(203, 268);
            this.btnAssociateCourses.Name = "btnAssociateCourses";
            this.btnAssociateCourses.Size = new System.Drawing.Size(509, 23);
            this.btnAssociateCourses.TabIndex = 9;
            this.btnAssociateCourses.Text = "Associate Selected Student(s) to the Selected Course";
            this.btnAssociateCourses.UseVisualStyleBackColor = true;
            this.btnAssociateCourses.Click += new System.EventHandler(this.btnAssociateCourses_Click);
            // 
            // btnClearSelectedStudents
            // 
            this.btnClearSelectedStudents.Location = new System.Drawing.Point(22, 225);
            this.btnClearSelectedStudents.Name = "btnClearSelectedStudents";
            this.btnClearSelectedStudents.Size = new System.Drawing.Size(168, 23);
            this.btnClearSelectedStudents.TabIndex = 8;
            this.btnClearSelectedStudents.Text = "Clear Selected Students";
            this.btnClearSelectedStudents.UseVisualStyleBackColor = true;
            this.btnClearSelectedStudents.Click += new System.EventHandler(this.btnClearSelectedStudents_Click);
            // 
            // lblSelectedCourseName
            // 
            this.lblSelectedCourseName.AutoSize = true;
            this.lblSelectedCourseName.Location = new System.Drawing.Point(512, 225);
            this.lblSelectedCourseName.Name = "lblSelectedCourseName";
            this.lblSelectedCourseName.Size = new System.Drawing.Size(13, 15);
            this.lblSelectedCourseName.TabIndex = 7;
            this.lblSelectedCourseName.Text = "0";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(377, 225);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(129, 15);
            this.label13.TabIndex = 6;
            this.label13.Text = "Selected Course Name:";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(203, 16);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(52, 15);
            this.label12.TabIndex = 5;
            this.label12.Text = "Courses:";
            // 
            // lblSelectedCourseId
            // 
            this.lblSelectedCourseId.AutoSize = true;
            this.lblSelectedCourseId.Location = new System.Drawing.Point(345, 225);
            this.lblSelectedCourseId.Name = "lblSelectedCourseId";
            this.lblSelectedCourseId.Size = new System.Drawing.Size(13, 15);
            this.lblSelectedCourseId.TabIndex = 4;
            this.lblSelectedCourseId.Text = "0";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(203, 225);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(107, 15);
            this.label11.TabIndex = 3;
            this.label11.Text = "Selected Course Id:";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(22, 16);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(56, 15);
            this.label10.TabIndex = 2;
            this.label10.Text = "Students:";
            // 
            // dgvCourseAssignments
            // 
            this.dgvCourseAssignments.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCourseAssignments.Location = new System.Drawing.Point(203, 45);
            this.dgvCourseAssignments.Name = "dgvCourseAssignments";
            this.dgvCourseAssignments.RowTemplate.Height = 25;
            this.dgvCourseAssignments.Size = new System.Drawing.Size(509, 168);
            this.dgvCourseAssignments.TabIndex = 1;
            this.dgvCourseAssignments.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCourseAssignments_CellClick);
            // 
            // lstStudents
            // 
            this.lstStudents.CheckOnClick = true;
            this.lstStudents.FormattingEnabled = true;
            this.lstStudents.Location = new System.Drawing.Point(22, 45);
            this.lstStudents.Name = "lstStudents";
            this.lstStudents.Size = new System.Drawing.Size(168, 166);
            this.lstStudents.TabIndex = 0;
            this.lstStudents.SelectedIndexChanged += new System.EventHandler(this.lstStudents_SelectedIndexChanged);
            // 
            // btnRemoveCourseAssignment
            // 
            this.btnRemoveCourseAssignment.Location = new System.Drawing.Point(203, 293);
            this.btnRemoveCourseAssignment.Name = "btnRemoveCourseAssignment";
            this.btnRemoveCourseAssignment.Size = new System.Drawing.Size(509, 23);
            this.btnRemoveCourseAssignment.TabIndex = 15;
            this.btnRemoveCourseAssignment.Text = "Remove Student From Course";
            this.btnRemoveCourseAssignment.UseVisualStyleBackColor = true;
            this.btnRemoveCourseAssignment.Click += new System.EventHandler(this.btnRemoveCourseAssignment_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(731, 636);
            this.Controls.Add(this.tabControl1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.numId)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvResults)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numTeacherAge)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourses)).EndInit();
            this.tabStudentCourses.ResumeLayout(false);
            this.tabStudentCourses.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseInfos)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseAssignments)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Label label1;
        private Label label2;
        private Label label3;
        private Label lblDateOfBirth;
        private TextBox txtFirstName;
        private TextBox txtLastName;
        private Button btnAddTeacher;
        private DateTimePicker dtStudentDateOfBirth;
        private NumericUpDown numId;
        private DataGridView dgvResults;
        private Label lblAge;
        private NumericUpDown numTeacherAge;
        private Button btnLoadTeachers;
        private RadioButton rdoTeacher;
        private RadioButton rdoStudent;
        private Panel panel1;
        private Button btnLoadStudents;
        private Button btnDelete;
        private Button btnResetForm;
        private Button btnSearch;
        private TabControl tabControl1;
        private TabPage tabPage1;
        private TabPage tabPage2;
        private TextBox txtCourseAbbreviation;
        private TextBox txtCourseDepartment;
        private ComboBox cboInstructors;
        private TextBox txtCourseName;
        private Button btnRemoveCourses;
        private Button btnLoadCourses;
        private Button btnAddCourses;
        private Label label9;
        private Label label8;
        private Label label7;
        private Label label6;
        private Label label5;
        private Label lblCourseId;
        private Label label4;
        private ComboBox cboNumCredits;
        private DataGridView dgvCourses;
        private Button btnResetCourseForm;
        private TabPage tabStudentCourses;
        private Label lblSelectedCourseName;
        private Label label13;
        private Label label12;
        private Label lblSelectedCourseId;
        private Label label11;
        private Label label10;
        private DataGridView dgvCourseAssignments;
        private CheckedListBox lstStudents;
        private Button btnClearSelectedStudents;
        private Button btnAssociateCourses;
        private DataGridView dgvCourseInfos;
        private Label lblSelectedStudentName;
        private Label label15;
        private Label lblSelectedStudentId;
        private Label label14;
        private Button btnRemoveCourseAssignment;
    }
}