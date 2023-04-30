using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.DirectoryServices;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CCAD8GameSystem
{
    public partial class MainForm : Form
    {
        private int childFormNumber = 0;
        private int _numGamesLost = 0;
        private int _numGamesWon = 0;

        private Form1 _hangmanForm = new Form1();
        private GameStats _statsForm = new GameStats();

        public delegate void UpdateGamePlayedStatCounters(bool isWin);

        public void UpdateGamesPlayedStats(bool isWin)
        {
            if (InvokeRequired)
            {
                Invoke(new UpdateGamePlayedStatCounters(UpdateGamesPlayedStats), isWin);
                return;
            }

            if (isWin)
            {
                _numGamesWon++;
            }
            else 
            {
                _numGamesLost++;
            }
        }

        public MainForm()
        {
            InitializeComponent();
        }

        private void ShowNewForm(object sender, EventArgs e)
        {
            Form childForm = new Form();
            childForm.MdiParent = this;
            childForm.Text = "Window " + childFormNumber++;
            childForm.Show();
        }

        private void OpenFile(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.InitialDirectory = Environment.GetFolderPath(Environment.SpecialFolder.Personal);
            openFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*";
            if (openFileDialog.ShowDialog(this) == DialogResult.OK)
            {
                string FileName = openFileDialog.FileName;
            }
        }

        private void SaveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.InitialDirectory = Environment.GetFolderPath(Environment.SpecialFolder.Personal);
            saveFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*";
            if (saveFileDialog.ShowDialog(this) == DialogResult.OK)
            {
                string FileName = saveFileDialog.FileName;
            }
        }

        private void ExitToolsStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void CutToolStripMenuItem_Click(object sender, EventArgs e)
        {
        }

        private void CopyToolStripMenuItem_Click(object sender, EventArgs e)
        {
        }

        private void PasteToolStripMenuItem_Click(object sender, EventArgs e)
        {
        }

        private void ToolBarToolStripMenuItem_Click(object sender, EventArgs e)
        {
            toolStrip.Visible = toolBarToolStripMenuItem.Checked;
        }

        private void StatusBarToolStripMenuItem_Click(object sender, EventArgs e)
        {
            statusStrip.Visible = statusBarToolStripMenuItem.Checked;
        }

        private void CascadeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            LayoutMdi(MdiLayout.Cascade);
        }

        private void TileVerticalToolStripMenuItem_Click(object sender, EventArgs e)
        {
            LayoutMdi(MdiLayout.TileVertical);
        }

        private void TileHorizontalToolStripMenuItem_Click(object sender, EventArgs e)
        {
            LayoutMdi(MdiLayout.TileHorizontal);
        }

        private void ArrangeIconsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            LayoutMdi(MdiLayout.ArrangeIcons);
        }

        private void CloseAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            foreach (Form childForm in MdiChildren)
            {
                childForm.Close();
            }
        }

        private void hangmanToolStripMenuItem_Click(object sender, EventArgs e)
        {
            _hangmanForm.Close();
            //subscribe to the event
            
            _hangmanForm = new Form1();
            _hangmanForm.UpdateStatsEvent += new UpdateGamePlayedStatCounters(UpdateGamesPlayedStats);
            _hangmanForm.MdiParent = this;
            _hangmanForm.WindowState = FormWindowState.Maximized;
            _hangmanForm.Text = "Hangman";
            _hangmanForm.Show();
        }

        private void gameStatsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            _statsForm.Close();
            _statsForm = new GameStats(_numGamesWon, _numGamesLost);
            _statsForm.MdiParent = this;
            _statsForm.WindowState = FormWindowState.Maximized;
            _statsForm.Text = "Stats";
            _statsForm.Show();
        }
    }
}
