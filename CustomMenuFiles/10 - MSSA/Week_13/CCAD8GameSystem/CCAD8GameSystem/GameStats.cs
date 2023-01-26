using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CCAD8GameSystem
{
    public partial class GameStats : Form
    {
        private int NumGamesPlayed => NumGamesWon + NumGamesLost;
        public int NumGamesWon { get; set; } = 0;
        public int NumGamesLost { get; set; } = 0;
        private double WinPercent => NumGamesPlayed == 0 ? 0 : (double)NumGamesWon / (double)NumGamesPlayed * 100.0;

        public GameStats()
        {
            InitializeComponent();
        }

        public GameStats(int numGamesWon, int numGamesLost)
        {
            InitializeComponent();
            NumGamesWon = numGamesWon;
            NumGamesLost = numGamesLost;
            ShowStats();
        }

        private void GameStats_Load(object sender, EventArgs e)
        {
            ShowStats();
        }

        private void ShowStats()
        {
            lblNumGamesLost.Text = NumGamesLost.ToString();
            lblNumGamesPlayed.Text = NumGamesPlayed.ToString();
            lblNumGamesWon.Text = NumGamesWon.ToString();
            lblWinPercentage.Text = WinPercent.ToString();
        }
    }
}
