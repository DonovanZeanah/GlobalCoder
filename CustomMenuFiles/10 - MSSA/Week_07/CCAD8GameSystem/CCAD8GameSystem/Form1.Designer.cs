namespace CCAD8GameSystem
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
            this.btnResetGame = new System.Windows.Forms.Button();
            this.lblSecretWord = new System.Windows.Forms.Label();
            this.lblTitle = new System.Windows.Forms.Label();
            this.btnHelp = new System.Windows.Forms.Button();
            this.txtGuessLetter = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.btnGuess = new System.Windows.Forms.Button();
            this.txtLetter1 = new System.Windows.Forms.TextBox();
            this.txtLetter2 = new System.Windows.Forms.TextBox();
            this.txtLetter3 = new System.Windows.Forms.TextBox();
            this.txtLetter4 = new System.Windows.Forms.TextBox();
            this.txtLetter5 = new System.Windows.Forms.TextBox();
            this.txtLetter6 = new System.Windows.Forms.TextBox();
            this.txtLetter7 = new System.Windows.Forms.TextBox();
            this.txtLetter8 = new System.Windows.Forms.TextBox();
            this.txtLetter9 = new System.Windows.Forms.TextBox();
            this.txtLetter10 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtRemainingGuess1 = new System.Windows.Forms.TextBox();
            this.txtRemainingGuess2 = new System.Windows.Forms.TextBox();
            this.txtRemainingGuess3 = new System.Windows.Forms.TextBox();
            this.txtRemainingGuess4 = new System.Windows.Forms.TextBox();
            this.txtRemainingGuess5 = new System.Windows.Forms.TextBox();
            this.txtRemainingGuess6 = new System.Windows.Forms.TextBox();
            this.btnLetterA = new System.Windows.Forms.Button();
            this.btnLetterB = new System.Windows.Forms.Button();
            this.btnLetterC = new System.Windows.Forms.Button();
            this.btnLetterD = new System.Windows.Forms.Button();
            this.btnLetterE = new System.Windows.Forms.Button();
            this.btnLetterF = new System.Windows.Forms.Button();
            this.btnLetterG = new System.Windows.Forms.Button();
            this.btnLetterH = new System.Windows.Forms.Button();
            this.btnLetterI = new System.Windows.Forms.Button();
            this.btnLetterJ = new System.Windows.Forms.Button();
            this.btnLetterK = new System.Windows.Forms.Button();
            this.btnLetterL = new System.Windows.Forms.Button();
            this.btnLetterM = new System.Windows.Forms.Button();
            this.btnLetterN = new System.Windows.Forms.Button();
            this.btnLetterO = new System.Windows.Forms.Button();
            this.btnLetterP = new System.Windows.Forms.Button();
            this.btnLetterQ = new System.Windows.Forms.Button();
            this.btnLetterR = new System.Windows.Forms.Button();
            this.btnLetterS = new System.Windows.Forms.Button();
            this.btnLetterT = new System.Windows.Forms.Button();
            this.btnLetterU = new System.Windows.Forms.Button();
            this.btnLetterV = new System.Windows.Forms.Button();
            this.btnLetterW = new System.Windows.Forms.Button();
            this.btnLetterX = new System.Windows.Forms.Button();
            this.btnLetterY = new System.Windows.Forms.Button();
            this.btnLetterZ = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnResetGame
            // 
            this.btnResetGame.Location = new System.Drawing.Point(43, 22);
            this.btnResetGame.Name = "btnResetGame";
            this.btnResetGame.Size = new System.Drawing.Size(140, 23);
            this.btnResetGame.TabIndex = 0;
            this.btnResetGame.Text = "Reset Game";
            this.btnResetGame.UseVisualStyleBackColor = true;
            this.btnResetGame.Click += new System.EventHandler(this.btnResetGame_Click);
            // 
            // lblSecretWord
            // 
            this.lblSecretWord.AutoSize = true;
            this.lblSecretWord.Location = new System.Drawing.Point(718, 9);
            this.lblSecretWord.Name = "lblSecretWord";
            this.lblSecretWord.Size = new System.Drawing.Size(0, 15);
            this.lblSecretWord.TabIndex = 1;
            this.lblSecretWord.Visible = false;
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.Location = new System.Drawing.Point(344, 9);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(101, 15);
            this.lblTitle.TabIndex = 2;
            this.lblTitle.Text = "Hangman CCAD8";
            // 
            // btnHelp
            // 
            this.btnHelp.Location = new System.Drawing.Point(44, 57);
            this.btnHelp.Name = "btnHelp";
            this.btnHelp.Size = new System.Drawing.Size(139, 23);
            this.btnHelp.TabIndex = 3;
            this.btnHelp.Text = "Help";
            this.btnHelp.UseVisualStyleBackColor = true;
            this.btnHelp.Click += new System.EventHandler(this.btnHelp_Click);
            this.btnHelp.KeyDown += new System.Windows.Forms.KeyEventHandler(this.btnHelp_KeyDown);
            // 
            // txtGuessLetter
            // 
            this.txtGuessLetter.Enabled = false;
            this.txtGuessLetter.Location = new System.Drawing.Point(128, 279);
            this.txtGuessLetter.Name = "txtGuessLetter";
            this.txtGuessLetter.Size = new System.Drawing.Size(55, 23);
            this.txtGuessLetter.TabIndex = 4;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(39, 287);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(83, 15);
            this.label1.TabIndex = 5;
            this.label1.Text = "Guess a Letter:";
            // 
            // btnGuess
            // 
            this.btnGuess.Enabled = false;
            this.btnGuess.Location = new System.Drawing.Point(44, 308);
            this.btnGuess.Name = "btnGuess";
            this.btnGuess.Size = new System.Drawing.Size(139, 23);
            this.btnGuess.TabIndex = 6;
            this.btnGuess.Text = "Submit Guess";
            this.btnGuess.UseVisualStyleBackColor = true;
            this.btnGuess.Click += new System.EventHandler(this.btnGuess_Click);
            // 
            // txtLetter1
            // 
            this.txtLetter1.Enabled = false;
            this.txtLetter1.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter1.Location = new System.Drawing.Point(240, 56);
            this.txtLetter1.Name = "txtLetter1";
            this.txtLetter1.ReadOnly = true;
            this.txtLetter1.Size = new System.Drawing.Size(35, 52);
            this.txtLetter1.TabIndex = 7;
            this.txtLetter1.Text = "A";
            this.txtLetter1.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter2
            // 
            this.txtLetter2.Enabled = false;
            this.txtLetter2.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter2.Location = new System.Drawing.Point(281, 56);
            this.txtLetter2.Name = "txtLetter2";
            this.txtLetter2.ReadOnly = true;
            this.txtLetter2.Size = new System.Drawing.Size(35, 52);
            this.txtLetter2.TabIndex = 8;
            this.txtLetter2.Text = "A";
            this.txtLetter2.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter3
            // 
            this.txtLetter3.Enabled = false;
            this.txtLetter3.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter3.Location = new System.Drawing.Point(322, 56);
            this.txtLetter3.Name = "txtLetter3";
            this.txtLetter3.ReadOnly = true;
            this.txtLetter3.Size = new System.Drawing.Size(35, 52);
            this.txtLetter3.TabIndex = 9;
            this.txtLetter3.Text = "A";
            this.txtLetter3.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter4
            // 
            this.txtLetter4.Enabled = false;
            this.txtLetter4.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter4.Location = new System.Drawing.Point(363, 56);
            this.txtLetter4.Name = "txtLetter4";
            this.txtLetter4.ReadOnly = true;
            this.txtLetter4.Size = new System.Drawing.Size(35, 52);
            this.txtLetter4.TabIndex = 10;
            this.txtLetter4.Text = "A";
            this.txtLetter4.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter5
            // 
            this.txtLetter5.Enabled = false;
            this.txtLetter5.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter5.Location = new System.Drawing.Point(404, 56);
            this.txtLetter5.Name = "txtLetter5";
            this.txtLetter5.ReadOnly = true;
            this.txtLetter5.Size = new System.Drawing.Size(35, 52);
            this.txtLetter5.TabIndex = 11;
            this.txtLetter5.Text = "A";
            this.txtLetter5.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter6
            // 
            this.txtLetter6.Enabled = false;
            this.txtLetter6.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter6.Location = new System.Drawing.Point(445, 56);
            this.txtLetter6.Name = "txtLetter6";
            this.txtLetter6.ReadOnly = true;
            this.txtLetter6.Size = new System.Drawing.Size(35, 52);
            this.txtLetter6.TabIndex = 12;
            this.txtLetter6.Text = "A";
            this.txtLetter6.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter7
            // 
            this.txtLetter7.Enabled = false;
            this.txtLetter7.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter7.Location = new System.Drawing.Point(486, 56);
            this.txtLetter7.Name = "txtLetter7";
            this.txtLetter7.ReadOnly = true;
            this.txtLetter7.Size = new System.Drawing.Size(35, 52);
            this.txtLetter7.TabIndex = 13;
            this.txtLetter7.Text = "A";
            this.txtLetter7.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter8
            // 
            this.txtLetter8.Enabled = false;
            this.txtLetter8.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter8.Location = new System.Drawing.Point(527, 56);
            this.txtLetter8.Name = "txtLetter8";
            this.txtLetter8.ReadOnly = true;
            this.txtLetter8.Size = new System.Drawing.Size(35, 52);
            this.txtLetter8.TabIndex = 14;
            this.txtLetter8.Text = "A";
            this.txtLetter8.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter9
            // 
            this.txtLetter9.Enabled = false;
            this.txtLetter9.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter9.Location = new System.Drawing.Point(568, 56);
            this.txtLetter9.Name = "txtLetter9";
            this.txtLetter9.ReadOnly = true;
            this.txtLetter9.Size = new System.Drawing.Size(35, 52);
            this.txtLetter9.TabIndex = 15;
            this.txtLetter9.Text = "A";
            this.txtLetter9.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtLetter10
            // 
            this.txtLetter10.Enabled = false;
            this.txtLetter10.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtLetter10.Location = new System.Drawing.Point(609, 56);
            this.txtLetter10.Name = "txtLetter10";
            this.txtLetter10.ReadOnly = true;
            this.txtLetter10.Size = new System.Drawing.Size(35, 52);
            this.txtLetter10.TabIndex = 16;
            this.txtLetter10.Text = "A";
            this.txtLetter10.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(676, 39);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(112, 15);
            this.label2.TabIndex = 17;
            this.label2.Text = "Remaining Guesses:";
            // 
            // txtRemainingGuess1
            // 
            this.txtRemainingGuess1.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess1.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess1.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess1.Location = new System.Drawing.Point(718, 57);
            this.txtRemainingGuess1.Name = "txtRemainingGuess1";
            this.txtRemainingGuess1.ReadOnly = true;
            this.txtRemainingGuess1.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess1.TabIndex = 18;
            this.txtRemainingGuess1.Text = "A";
            this.txtRemainingGuess1.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtRemainingGuess2
            // 
            this.txtRemainingGuess2.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess2.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess2.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess2.Location = new System.Drawing.Point(718, 115);
            this.txtRemainingGuess2.Name = "txtRemainingGuess2";
            this.txtRemainingGuess2.ReadOnly = true;
            this.txtRemainingGuess2.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess2.TabIndex = 19;
            this.txtRemainingGuess2.Text = "A";
            this.txtRemainingGuess2.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtRemainingGuess3
            // 
            this.txtRemainingGuess3.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess3.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess3.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess3.Location = new System.Drawing.Point(718, 173);
            this.txtRemainingGuess3.Name = "txtRemainingGuess3";
            this.txtRemainingGuess3.ReadOnly = true;
            this.txtRemainingGuess3.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess3.TabIndex = 20;
            this.txtRemainingGuess3.Text = "A";
            this.txtRemainingGuess3.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtRemainingGuess4
            // 
            this.txtRemainingGuess4.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess4.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess4.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess4.Location = new System.Drawing.Point(718, 231);
            this.txtRemainingGuess4.Name = "txtRemainingGuess4";
            this.txtRemainingGuess4.ReadOnly = true;
            this.txtRemainingGuess4.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess4.TabIndex = 21;
            this.txtRemainingGuess4.Text = "A";
            this.txtRemainingGuess4.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtRemainingGuess5
            // 
            this.txtRemainingGuess5.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess5.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess5.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess5.Location = new System.Drawing.Point(718, 289);
            this.txtRemainingGuess5.Name = "txtRemainingGuess5";
            this.txtRemainingGuess5.ReadOnly = true;
            this.txtRemainingGuess5.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess5.TabIndex = 22;
            this.txtRemainingGuess5.Text = "A";
            this.txtRemainingGuess5.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtRemainingGuess6
            // 
            this.txtRemainingGuess6.BackColor = System.Drawing.Color.ForestGreen;
            this.txtRemainingGuess6.Font = new System.Drawing.Font("Segoe UI", 25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.txtRemainingGuess6.ForeColor = System.Drawing.Color.White;
            this.txtRemainingGuess6.Location = new System.Drawing.Point(718, 347);
            this.txtRemainingGuess6.Name = "txtRemainingGuess6";
            this.txtRemainingGuess6.ReadOnly = true;
            this.txtRemainingGuess6.Size = new System.Drawing.Size(35, 52);
            this.txtRemainingGuess6.TabIndex = 23;
            this.txtRemainingGuess6.Text = "A";
            this.txtRemainingGuess6.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // btnLetterA
            // 
            this.btnLetterA.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterA.Location = new System.Drawing.Point(236, 235);
            this.btnLetterA.Name = "btnLetterA";
            this.btnLetterA.Size = new System.Drawing.Size(39, 48);
            this.btnLetterA.TabIndex = 24;
            this.btnLetterA.Text = "A";
            this.btnLetterA.UseVisualStyleBackColor = true;
            this.btnLetterA.Click += new System.EventHandler(this.btnLetterA_Click);
            // 
            // btnLetterB
            // 
            this.btnLetterB.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterB.Location = new System.Drawing.Point(281, 235);
            this.btnLetterB.Name = "btnLetterB";
            this.btnLetterB.Size = new System.Drawing.Size(39, 48);
            this.btnLetterB.TabIndex = 25;
            this.btnLetterB.Text = "B";
            this.btnLetterB.UseVisualStyleBackColor = true;
            this.btnLetterB.Click += new System.EventHandler(this.btnLetterB_Click);
            // 
            // btnLetterC
            // 
            this.btnLetterC.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterC.Location = new System.Drawing.Point(326, 235);
            this.btnLetterC.Name = "btnLetterC";
            this.btnLetterC.Size = new System.Drawing.Size(39, 48);
            this.btnLetterC.TabIndex = 26;
            this.btnLetterC.Text = "C";
            this.btnLetterC.UseVisualStyleBackColor = true;
            this.btnLetterC.Click += new System.EventHandler(this.btnLetterC_Click);
            // 
            // btnLetterD
            // 
            this.btnLetterD.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterD.Location = new System.Drawing.Point(371, 235);
            this.btnLetterD.Name = "btnLetterD";
            this.btnLetterD.Size = new System.Drawing.Size(39, 48);
            this.btnLetterD.TabIndex = 27;
            this.btnLetterD.Text = "D";
            this.btnLetterD.UseVisualStyleBackColor = true;
            this.btnLetterD.Click += new System.EventHandler(this.btnLetterD_Click);
            // 
            // btnLetterE
            // 
            this.btnLetterE.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterE.Location = new System.Drawing.Point(416, 235);
            this.btnLetterE.Name = "btnLetterE";
            this.btnLetterE.Size = new System.Drawing.Size(39, 48);
            this.btnLetterE.TabIndex = 28;
            this.btnLetterE.Text = "E";
            this.btnLetterE.UseVisualStyleBackColor = true;
            this.btnLetterE.Click += new System.EventHandler(this.btnLetterE_Click);
            // 
            // btnLetterF
            // 
            this.btnLetterF.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterF.Location = new System.Drawing.Point(461, 235);
            this.btnLetterF.Name = "btnLetterF";
            this.btnLetterF.Size = new System.Drawing.Size(39, 48);
            this.btnLetterF.TabIndex = 29;
            this.btnLetterF.Text = "F";
            this.btnLetterF.UseVisualStyleBackColor = true;
            this.btnLetterF.Click += new System.EventHandler(this.btnLetterF_Click);
            // 
            // btnLetterG
            // 
            this.btnLetterG.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterG.Location = new System.Drawing.Point(506, 235);
            this.btnLetterG.Name = "btnLetterG";
            this.btnLetterG.Size = new System.Drawing.Size(39, 48);
            this.btnLetterG.TabIndex = 30;
            this.btnLetterG.Text = "G";
            this.btnLetterG.UseVisualStyleBackColor = true;
            this.btnLetterG.Click += new System.EventHandler(this.btnLetterG_Click);
            // 
            // btnLetterH
            // 
            this.btnLetterH.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterH.Location = new System.Drawing.Point(551, 235);
            this.btnLetterH.Name = "btnLetterH";
            this.btnLetterH.Size = new System.Drawing.Size(39, 48);
            this.btnLetterH.TabIndex = 31;
            this.btnLetterH.Text = "H";
            this.btnLetterH.UseVisualStyleBackColor = true;
            this.btnLetterH.Click += new System.EventHandler(this.btnLetterH_Click);
            // 
            // btnLetterI
            // 
            this.btnLetterI.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterI.Location = new System.Drawing.Point(596, 235);
            this.btnLetterI.Name = "btnLetterI";
            this.btnLetterI.Size = new System.Drawing.Size(39, 48);
            this.btnLetterI.TabIndex = 32;
            this.btnLetterI.Text = "I";
            this.btnLetterI.UseVisualStyleBackColor = true;
            this.btnLetterI.Click += new System.EventHandler(this.btnLetterI_Click);
            // 
            // btnLetterJ
            // 
            this.btnLetterJ.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterJ.Location = new System.Drawing.Point(236, 293);
            this.btnLetterJ.Name = "btnLetterJ";
            this.btnLetterJ.Size = new System.Drawing.Size(39, 48);
            this.btnLetterJ.TabIndex = 33;
            this.btnLetterJ.Text = "J";
            this.btnLetterJ.UseVisualStyleBackColor = true;
            this.btnLetterJ.Click += new System.EventHandler(this.btnLetterJ_Click);
            // 
            // btnLetterK
            // 
            this.btnLetterK.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterK.Location = new System.Drawing.Point(281, 293);
            this.btnLetterK.Name = "btnLetterK";
            this.btnLetterK.Size = new System.Drawing.Size(39, 48);
            this.btnLetterK.TabIndex = 34;
            this.btnLetterK.Text = "K";
            this.btnLetterK.UseVisualStyleBackColor = true;
            this.btnLetterK.Click += new System.EventHandler(this.btnLetterK_Click);
            // 
            // btnLetterL
            // 
            this.btnLetterL.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterL.Location = new System.Drawing.Point(326, 293);
            this.btnLetterL.Name = "btnLetterL";
            this.btnLetterL.Size = new System.Drawing.Size(39, 48);
            this.btnLetterL.TabIndex = 35;
            this.btnLetterL.Text = "L";
            this.btnLetterL.UseVisualStyleBackColor = true;
            this.btnLetterL.Click += new System.EventHandler(this.btnLetterL_Click);
            // 
            // btnLetterM
            // 
            this.btnLetterM.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterM.Location = new System.Drawing.Point(371, 293);
            this.btnLetterM.Name = "btnLetterM";
            this.btnLetterM.Size = new System.Drawing.Size(39, 48);
            this.btnLetterM.TabIndex = 36;
            this.btnLetterM.Text = "M";
            this.btnLetterM.UseVisualStyleBackColor = true;
            this.btnLetterM.Click += new System.EventHandler(this.btnLetterM_Click);
            // 
            // btnLetterN
            // 
            this.btnLetterN.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterN.Location = new System.Drawing.Point(416, 293);
            this.btnLetterN.Name = "btnLetterN";
            this.btnLetterN.Size = new System.Drawing.Size(39, 48);
            this.btnLetterN.TabIndex = 37;
            this.btnLetterN.Text = "N";
            this.btnLetterN.UseVisualStyleBackColor = true;
            this.btnLetterN.Click += new System.EventHandler(this.btnLetterN_Click);
            // 
            // btnLetterO
            // 
            this.btnLetterO.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterO.Location = new System.Drawing.Point(461, 293);
            this.btnLetterO.Name = "btnLetterO";
            this.btnLetterO.Size = new System.Drawing.Size(39, 48);
            this.btnLetterO.TabIndex = 38;
            this.btnLetterO.Text = "O";
            this.btnLetterO.UseVisualStyleBackColor = true;
            this.btnLetterO.Click += new System.EventHandler(this.btnLetterO_Click);
            // 
            // btnLetterP
            // 
            this.btnLetterP.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterP.Location = new System.Drawing.Point(506, 293);
            this.btnLetterP.Name = "btnLetterP";
            this.btnLetterP.Size = new System.Drawing.Size(39, 48);
            this.btnLetterP.TabIndex = 39;
            this.btnLetterP.Text = "P";
            this.btnLetterP.UseVisualStyleBackColor = true;
            this.btnLetterP.Click += new System.EventHandler(this.btnLetterP_Click);
            // 
            // btnLetterQ
            // 
            this.btnLetterQ.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterQ.Location = new System.Drawing.Point(551, 293);
            this.btnLetterQ.Name = "btnLetterQ";
            this.btnLetterQ.Size = new System.Drawing.Size(39, 48);
            this.btnLetterQ.TabIndex = 40;
            this.btnLetterQ.Text = "Q";
            this.btnLetterQ.UseVisualStyleBackColor = true;
            this.btnLetterQ.Click += new System.EventHandler(this.btnLetterQ_Click);
            // 
            // btnLetterR
            // 
            this.btnLetterR.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterR.Location = new System.Drawing.Point(596, 293);
            this.btnLetterR.Name = "btnLetterR";
            this.btnLetterR.Size = new System.Drawing.Size(39, 48);
            this.btnLetterR.TabIndex = 41;
            this.btnLetterR.Text = "R";
            this.btnLetterR.UseVisualStyleBackColor = true;
            this.btnLetterR.Click += new System.EventHandler(this.btnLetterR_Click);
            // 
            // btnLetterS
            // 
            this.btnLetterS.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterS.Location = new System.Drawing.Point(236, 347);
            this.btnLetterS.Name = "btnLetterS";
            this.btnLetterS.Size = new System.Drawing.Size(39, 48);
            this.btnLetterS.TabIndex = 42;
            this.btnLetterS.Text = "S";
            this.btnLetterS.UseVisualStyleBackColor = true;
            this.btnLetterS.Click += new System.EventHandler(this.btnLetterS_Click);
            // 
            // btnLetterT
            // 
            this.btnLetterT.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterT.Location = new System.Drawing.Point(281, 347);
            this.btnLetterT.Name = "btnLetterT";
            this.btnLetterT.Size = new System.Drawing.Size(39, 48);
            this.btnLetterT.TabIndex = 43;
            this.btnLetterT.Text = "T";
            this.btnLetterT.UseVisualStyleBackColor = true;
            this.btnLetterT.Click += new System.EventHandler(this.btnLetterT_Click);
            // 
            // btnLetterU
            // 
            this.btnLetterU.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterU.Location = new System.Drawing.Point(326, 347);
            this.btnLetterU.Name = "btnLetterU";
            this.btnLetterU.Size = new System.Drawing.Size(39, 48);
            this.btnLetterU.TabIndex = 44;
            this.btnLetterU.Text = "U";
            this.btnLetterU.UseVisualStyleBackColor = true;
            this.btnLetterU.Click += new System.EventHandler(this.btnLetterU_Click);
            // 
            // btnLetterV
            // 
            this.btnLetterV.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterV.Location = new System.Drawing.Point(371, 347);
            this.btnLetterV.Name = "btnLetterV";
            this.btnLetterV.Size = new System.Drawing.Size(39, 48);
            this.btnLetterV.TabIndex = 45;
            this.btnLetterV.Text = "V";
            this.btnLetterV.UseVisualStyleBackColor = true;
            this.btnLetterV.Click += new System.EventHandler(this.btnLetterV_Click);
            // 
            // btnLetterW
            // 
            this.btnLetterW.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterW.Location = new System.Drawing.Point(416, 347);
            this.btnLetterW.Name = "btnLetterW";
            this.btnLetterW.Size = new System.Drawing.Size(39, 48);
            this.btnLetterW.TabIndex = 46;
            this.btnLetterW.Text = "W";
            this.btnLetterW.UseVisualStyleBackColor = true;
            this.btnLetterW.Click += new System.EventHandler(this.btnLetterW_Click);
            // 
            // btnLetterX
            // 
            this.btnLetterX.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterX.Location = new System.Drawing.Point(461, 347);
            this.btnLetterX.Name = "btnLetterX";
            this.btnLetterX.Size = new System.Drawing.Size(39, 48);
            this.btnLetterX.TabIndex = 47;
            this.btnLetterX.Text = "X";
            this.btnLetterX.UseVisualStyleBackColor = true;
            this.btnLetterX.Click += new System.EventHandler(this.btnLetterX_Click);
            // 
            // btnLetterY
            // 
            this.btnLetterY.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterY.Location = new System.Drawing.Point(506, 347);
            this.btnLetterY.Name = "btnLetterY";
            this.btnLetterY.Size = new System.Drawing.Size(39, 48);
            this.btnLetterY.TabIndex = 48;
            this.btnLetterY.Text = "Y";
            this.btnLetterY.UseVisualStyleBackColor = true;
            this.btnLetterY.Click += new System.EventHandler(this.btnLetterY_Click);
            // 
            // btnLetterZ
            // 
            this.btnLetterZ.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnLetterZ.Location = new System.Drawing.Point(551, 347);
            this.btnLetterZ.Name = "btnLetterZ";
            this.btnLetterZ.Size = new System.Drawing.Size(39, 48);
            this.btnLetterZ.TabIndex = 49;
            this.btnLetterZ.Text = "Z";
            this.btnLetterZ.UseVisualStyleBackColor = true;
            this.btnLetterZ.Click += new System.EventHandler(this.btnLetterZ_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnLetterZ);
            this.Controls.Add(this.btnLetterY);
            this.Controls.Add(this.btnLetterX);
            this.Controls.Add(this.btnLetterW);
            this.Controls.Add(this.btnLetterV);
            this.Controls.Add(this.btnLetterU);
            this.Controls.Add(this.btnLetterT);
            this.Controls.Add(this.btnLetterS);
            this.Controls.Add(this.btnLetterR);
            this.Controls.Add(this.btnLetterQ);
            this.Controls.Add(this.btnLetterP);
            this.Controls.Add(this.btnLetterO);
            this.Controls.Add(this.btnLetterN);
            this.Controls.Add(this.btnLetterM);
            this.Controls.Add(this.btnLetterL);
            this.Controls.Add(this.btnLetterK);
            this.Controls.Add(this.btnLetterJ);
            this.Controls.Add(this.btnLetterI);
            this.Controls.Add(this.btnLetterH);
            this.Controls.Add(this.btnLetterG);
            this.Controls.Add(this.btnLetterF);
            this.Controls.Add(this.btnLetterE);
            this.Controls.Add(this.btnLetterD);
            this.Controls.Add(this.btnLetterC);
            this.Controls.Add(this.btnLetterB);
            this.Controls.Add(this.btnLetterA);
            this.Controls.Add(this.txtRemainingGuess6);
            this.Controls.Add(this.txtRemainingGuess5);
            this.Controls.Add(this.txtRemainingGuess4);
            this.Controls.Add(this.txtRemainingGuess3);
            this.Controls.Add(this.txtRemainingGuess2);
            this.Controls.Add(this.txtRemainingGuess1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtLetter10);
            this.Controls.Add(this.txtLetter9);
            this.Controls.Add(this.txtLetter8);
            this.Controls.Add(this.txtLetter7);
            this.Controls.Add(this.txtLetter6);
            this.Controls.Add(this.txtLetter5);
            this.Controls.Add(this.txtLetter4);
            this.Controls.Add(this.txtLetter3);
            this.Controls.Add(this.txtLetter2);
            this.Controls.Add(this.txtLetter1);
            this.Controls.Add(this.btnGuess);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtGuessLetter);
            this.Controls.Add(this.btnHelp);
            this.Controls.Add(this.lblTitle);
            this.Controls.Add(this.lblSecretWord);
            this.Controls.Add(this.btnResetGame);
            this.Name = "Form1";
            this.Text = "Form1";
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.Form1_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Button btnResetGame;
        private Label lblSecretWord;
        private Label lblTitle;
        private Button btnHelp;
        private TextBox txtGuessLetter;
        private Label label1;
        private Button btnGuess;
        private TextBox txtLetter1;
        private TextBox txtLetter2;
        private TextBox txtLetter3;
        private TextBox txtLetter4;
        private TextBox txtLetter5;
        private TextBox txtLetter6;
        private TextBox txtLetter7;
        private TextBox txtLetter8;
        private TextBox txtLetter9;
        private TextBox txtLetter10;
        private Label label2;
        private TextBox txtRemainingGuess1;
        private TextBox txtRemainingGuess2;
        private TextBox txtRemainingGuess3;
        private TextBox txtRemainingGuess4;
        private TextBox txtRemainingGuess5;
        private TextBox txtRemainingGuess6;
        private Button btnLetterA;
        private Button btnLetterB;
        private Button btnLetterC;
        private Button btnLetterD;
        private Button btnLetterE;
        private Button btnLetterF;
        private Button btnLetterG;
        private Button btnLetterH;
        private Button btnLetterI;
        private Button btnLetterJ;
        private Button btnLetterK;
        private Button btnLetterL;
        private Button btnLetterM;
        private Button btnLetterN;
        private Button btnLetterO;
        private Button btnLetterP;
        private Button btnLetterQ;
        private Button btnLetterR;
        private Button btnLetterS;
        private Button btnLetterT;
        private Button btnLetterU;
        private Button btnLetterV;
        private Button btnLetterW;
        private Button btnLetterX;
        private Button btnLetterY;
        private Button btnLetterZ;
    }
}