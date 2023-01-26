namespace CCAD8GameSystem
{
    partial class GameStats
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.lblNumGamesPlayed = new System.Windows.Forms.Label();
            this.lblNumGamesWon = new System.Windows.Forms.Label();
            this.lblNumGamesLost = new System.Windows.Forms.Label();
            this.lblWinPercentage = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(54, 46);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(84, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "Games Played:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(54, 74);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(74, 15);
            this.label2.TabIndex = 1;
            this.label2.Text = "Games Won:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(54, 103);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(71, 15);
            this.label3.TabIndex = 2;
            this.label3.Text = "Games Lost:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(57, 135);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(93, 15);
            this.label4.TabIndex = 3;
            this.label4.Text = "Win Percentage:";
            // 
            // lblNumGamesPlayed
            // 
            this.lblNumGamesPlayed.AutoSize = true;
            this.lblNumGamesPlayed.Location = new System.Drawing.Point(181, 46);
            this.lblNumGamesPlayed.Name = "lblNumGamesPlayed";
            this.lblNumGamesPlayed.Size = new System.Drawing.Size(13, 15);
            this.lblNumGamesPlayed.TabIndex = 4;
            this.lblNumGamesPlayed.Text = "0";
            // 
            // lblNumGamesWon
            // 
            this.lblNumGamesWon.AutoSize = true;
            this.lblNumGamesWon.Location = new System.Drawing.Point(181, 74);
            this.lblNumGamesWon.Name = "lblNumGamesWon";
            this.lblNumGamesWon.Size = new System.Drawing.Size(13, 15);
            this.lblNumGamesWon.TabIndex = 5;
            this.lblNumGamesWon.Text = "0";
            // 
            // lblNumGamesLost
            // 
            this.lblNumGamesLost.AutoSize = true;
            this.lblNumGamesLost.Location = new System.Drawing.Point(181, 103);
            this.lblNumGamesLost.Name = "lblNumGamesLost";
            this.lblNumGamesLost.Size = new System.Drawing.Size(13, 15);
            this.lblNumGamesLost.TabIndex = 6;
            this.lblNumGamesLost.Text = "0";
            // 
            // lblWinPercentage
            // 
            this.lblWinPercentage.AutoSize = true;
            this.lblWinPercentage.Location = new System.Drawing.Point(181, 135);
            this.lblWinPercentage.Name = "lblWinPercentage";
            this.lblWinPercentage.Size = new System.Drawing.Size(13, 15);
            this.lblWinPercentage.TabIndex = 7;
            this.lblWinPercentage.Text = "0";
            // 
            // GameStats
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.lblWinPercentage);
            this.Controls.Add(this.lblNumGamesLost);
            this.Controls.Add(this.lblNumGamesWon);
            this.Controls.Add(this.lblNumGamesPlayed);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "GameStats";
            this.Text = "GameStats";
            this.Load += new System.EventHandler(this.GameStats_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label lblNumGamesPlayed;
        private Label lblNumGamesWon;
        private Label lblNumGamesLost;
        private Label lblWinPercentage;
    }
}