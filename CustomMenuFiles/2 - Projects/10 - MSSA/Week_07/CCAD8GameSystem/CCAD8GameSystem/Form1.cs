using System.Diagnostics.Metrics;
using System.Windows.Forms;
using WordGenerator;
using wg = WordGenerator;

namespace CCAD8GameSystem
{
    public partial class Form1 : Form
    {
        private const int MAX_INCORRECT_GUESSES = 6;

        //list of words:
        private string[] words;
        private Random r;

        //dictionary of reused words
        private Dictionary<int, bool> WordUseTracker = new Dictionary<int, bool>();

        private int currentNumberOfIncorrectGuesses = 0;

        //dictionary for guessed letters
        private const string ALL_LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        private Dictionary<string, bool> GuessTracker = new Dictionary<string, bool>();

        public Form1()
        {
            InitializeComponent();
            
            //todo: Create a Factory that generates the correct behavior based on choice:

            ILoadWordsBehavior loadWordsBehavior = new LoadWordsFromFileUsingFile();
            //loadWordsBehavior = new LoadWordsFromWeb();

            var wordGenerator = new wg.WordGenerator(loadWordsBehavior);

            r = new Random();

            words = wordGenerator.GetWords();

            ResetGame();
        }


        /// <summary>
        /// reset game to starting state
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnResetGame_Click(object sender, EventArgs e)
        {
            ResetGame();
        }

        private void ResetGame()
        {
            //MessageBox.Show("Resetting Game", "Resetting!"
            //                                , MessageBoxButtons.OK
            //                                , MessageBoxIcon.Information);

            //get a new word
            lblSecretWord.Text = words[r.Next(words.Length-1)];

            //build the boxes
            ResetLetterBoxes();
            ResetIncorrectGuessBoxes();

            //reset incorrect guess count
            currentNumberOfIncorrectGuesses = 0;

            //reset the guess tracker
            ResetGuessTracker();

            //enable boxes
            SetBoxes();

            //enable the game:
            EnableGame(true);
        }

        private void ResetLetterBoxes()
        {
            ResetLetterTextBox(txtLetter1);
            ResetLetterTextBox(txtLetter2);
            ResetLetterTextBox(txtLetter3);
            ResetLetterTextBox(txtLetter4);
            ResetLetterTextBox(txtLetter5);
            ResetLetterTextBox(txtLetter6);
            ResetLetterTextBox(txtLetter7);
            ResetLetterTextBox(txtLetter8);
            ResetLetterTextBox(txtLetter9);
            ResetLetterTextBox(txtLetter10);
        }

        private void ResetIncorrectGuessBoxes()
        {
            ResetIncorrectGuessBox(txtRemainingGuess1);
            ResetIncorrectGuessBox(txtRemainingGuess2);
            ResetIncorrectGuessBox(txtRemainingGuess3);
            ResetIncorrectGuessBox(txtRemainingGuess4);
            ResetIncorrectGuessBox(txtRemainingGuess5);
            ResetIncorrectGuessBox(txtRemainingGuess6);
        }

        private void ResetGuessButtons(bool enabled)
        {
            btnLetterA.Enabled = enabled;
            btnLetterB.Enabled = enabled;
            btnLetterC.Enabled = enabled;
            btnLetterD.Enabled = enabled;
            btnLetterE.Enabled = enabled;
            btnLetterF.Enabled = enabled;
            btnLetterG.Enabled = enabled;
            btnLetterH.Enabled = enabled;
            btnLetterI.Enabled = enabled;
            btnLetterJ.Enabled = enabled;
            btnLetterK.Enabled = enabled;
            btnLetterL.Enabled = enabled;
            btnLetterM.Enabled = enabled;
            btnLetterN.Enabled = enabled;
            btnLetterO.Enabled = enabled;
            btnLetterP.Enabled = enabled;
            btnLetterQ.Enabled = enabled;
            btnLetterR.Enabled = enabled;
            btnLetterS.Enabled = enabled;
            btnLetterT.Enabled = enabled;
            btnLetterU.Enabled = enabled;
            btnLetterV.Enabled = enabled;
            btnLetterW.Enabled = enabled;
            btnLetterX.Enabled = enabled;
            btnLetterY.Enabled = enabled;
            btnLetterZ.Enabled = enabled;
        }

        private void ResetIncorrectGuessBox(TextBox t)
        {
            t.Text = string.Empty;
            t.BackColor = Color.ForestGreen;
            t.ForeColor = Color.White;
            t.Enabled = true;
            t.ReadOnly = false;
        }

        private void ResetGuessTracker()
        {
            GuessTracker = new Dictionary<string, bool>();

            foreach (var c in ALL_LETTERS)
            {
                GuessTracker.Add(c.ToString(), false);
            }
        }

        private void SetBoxes()
        {
            for (int i = 1; i <= lblSecretWord.Text.Length; i++)
            {
                switch (i)
                {
                    case 1:
                        SetBoxForGameplay(txtLetter1);
                        break;
                    case 2:
                        SetBoxForGameplay(txtLetter2);
                        break;
                    case 3:
                        SetBoxForGameplay(txtLetter3);
                        break;
                    case 4:
                        SetBoxForGameplay(txtLetter4);
                        break;
                    case 5:
                        SetBoxForGameplay(txtLetter5);
                        break;
                    case 6:
                        SetBoxForGameplay(txtLetter6);
                        break;
                    case 7:
                        SetBoxForGameplay(txtLetter7);
                        break;
                    case 8:
                        SetBoxForGameplay(txtLetter8);
                        break;
                    case 9:
                        SetBoxForGameplay(txtLetter9);
                        break;
                    case 10:
                        SetBoxForGameplay(txtLetter10);
                        break;
                    default:
                        break;
                }
            }
        }

        private void SetBoxForGameplay(TextBox t)
        {
            t.Visible = true;
        }

        private void ResetLetterTextBox(TextBox t)
        {
            t.Text = string.Empty;
            t.Enabled = false;
            t.BackColor = Color.White;
            t.ForeColor = Color.Black;
            t.Visible = false;
        }

        //private void BuildBoxes()
        //{
        //    //get the word
        //    var word = lblSecretWord.Text;
        //    //number of boxes
        //    var wordLength = word.Length;

        //    var font = new Font("Verdana", 20);

        //    int i = 0;
        //    var offset = 45;
        //    var start = 275;

        //    //for each char
        //    foreach (char c in word)
        //    {
        //        var left = start + (offset * i);
        //        //create a box
        //        TextBox txtBox = new TextBox();
        //        //set it's properties
        //        txtBox.Name = $"txtCharacter{i}";

        //        txtBox.Font = font;
        //        txtBox.TextAlign = HorizontalAlignment.Center;
        //        var point = new Point();
        //        point.X = left;
        //        point.Y = 40;
        //        txtBox.Location = point;

        //        txtBox.Width = 35;

        //        //Add to form
        //        this.Controls.Add(txtBox);
        //        i++;
        //    }
        //}

        private void EnableGame(bool enable)
        { 
            txtGuessLetter.Enabled = enable;
            btnGuess.Enabled = enable;

            ResetGuessButtons(enable);
            
        }

        private void Form1_KeyDown(object sender, KeyEventArgs e)
        {
            lblSecretWord.Visible = true;
        }

        private void btnHelp_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Here's how you play...");
        }

        private void btnHelp_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F1)
            {
                lblSecretWord.Visible = !lblSecretWord.Visible;
            }
            if (e.KeyCode == Keys.F2)
            {
                Solve();
            }
        }

        private void Solve()
        {
            //what the word is
            int i = 1;
            foreach (char c in lblSecretWord.Text)
            {
                UpdateCorrectLetterBox(c.ToString().ToUpper(), i);
                
                i++;
            }
        }

        private void btnGuess_Click(object sender, EventArgs e)
        {
            //get the letter that they are guessing:
            //todo: Constrain the text box to only take one letter
            //      or just take the first letter only from this value:
            var nextGuess = txtGuessLetter.Text;
            if (string.IsNullOrWhiteSpace(nextGuess))
            {
                MessageBox.Show("You entered a bad guess, please enter A-Z only!");
                return;
            }
            var nextGuessCharacter = nextGuess.Substring(0, 1);

            //capitalize it
            nextGuessCharacter = nextGuessCharacter.ToUpper();

            var min = 65;  //inclusive ASCII A
            var max = 90; //inclusive ASCII Z
            var nextGuessCharacterAsciiValue = Convert.ToInt32(Convert.ToChar(nextGuessCharacter));

            //the input should be between A-Z
            if (nextGuessCharacterAsciiValue < min || nextGuessCharacterAsciiValue > max)
            {
                MessageBox.Show("You entered a bad guess, please enter A-Z only!");
                return;
            }

            //submit the letter
            SubmitGuess(nextGuessCharacter);

            //clear the guess box after submit
            txtGuessLetter.Text = string.Empty;
        }

        private void SubmitGuess(string letter)
        {
            var guessLetter = letter.ToUpper();

            //update the guess tracker with the guessed letter
            GuessTracker[guessLetter] = true;

            //check if it's part of the word
            var secretWord = lblSecretWord.Text;
            if (secretWord.Contains(letter, StringComparison.OrdinalIgnoreCase))
            {
                DisplayCorrectLetter(letter);
            }
            else
            {
                RecordIncorrectGuess(letter);
            }
        }

        private void DisplayCorrectLetter(string letter)
        {
            //find all matches in the current word
            int i = 1;
            foreach (char c in lblSecretWord.Text)
            {
                //for each match,
                if (c.ToString().Equals(letter, StringComparison.OrdinalIgnoreCase))
                {
                    //set the correct box with the letter as text
                    UpdateCorrectLetterBox(letter, i);
                }

                i++;
            }

            CheckWinCondition();
        }

        private void CheckWinCondition()
        {
            //determine if each letter in the word has been marked as guessed

            //O(n^2) => for every letter in word
            //            for every letter in dictionary
            //                  if match 
            //                      if is marked false get out

            for (int i = 0; i < lblSecretWord.Text.Length; i++)
            {
                //foreach (string k in GuessTracker.Keys)
                //{
                //    if (k == lblSecretWord.Text[i].ToString())
                //    {
                //        //is the value true/false
                //        var isGuessed = GuessTracker[k];
                //        if (!isGuessed)
                //        { 
                //            //not a win
                //        }
                //    }
                //}
                var isGuessed = GuessTracker[lblSecretWord.Text[i].ToString().ToUpper()];
                if (!isGuessed)
                {
                    return;
                }
            }

            //won
            EndGame(true);
        }

        private void UpdateCorrectLetterBox(string letter, int boxNumber, bool wasCorrect = true)
        {
            var box = new TextBox();
            switch (boxNumber)
            {
                case 1:
                    box = txtLetter1;
                    break;
                case 2:
                    box = txtLetter2;
                    break;
                case 3:
                    box = txtLetter3;
                    break;
                case 4:
                    box = txtLetter4;
                    break;
                case 5:
                    box = txtLetter5;
                    break;
                case 6:
                    box = txtLetter6;
                    break;
                case 7:
                    box = txtLetter7;
                    break;
                case 8:
                    box = txtLetter8;
                    break;
                case 9:
                    box = txtLetter9;
                    break;
                case 10:
                    box = txtLetter10;
                    break;
                default:
                    break;
            }
            box.Text = letter;
            if (!wasCorrect)
            {
                box.BackColor = Color.Yellow;
                box.ForeColor = Color.Black;
                box.Enabled = true;
                box.ReadOnly = true;
            }
        }

        private void RecordIncorrectGuess(string letter)
        {
            //MessageBox.Show($"Letter {letter} is not in the word!");

            //determine what number of guess that is incorrect this was
            currentNumberOfIncorrectGuesses++;

            //affect the appropriate box to show incorrect guess
            MarkIncorrectGuess(letter);

            //if now out of guesses display endgame(loss)
            if (currentNumberOfIncorrectGuesses == MAX_INCORRECT_GUESSES)
            {
                EndGame(false);
            }
        }

        private void MarkIncorrectGuess(string letter)
        {
            switch (currentNumberOfIncorrectGuesses)
            {
                case 1:
                    SetIncorrectTextBox(txtRemainingGuess1, letter);
                    break;
                case 2:
                    SetIncorrectTextBox(txtRemainingGuess2, letter);
                    break;
                case 3:
                    SetIncorrectTextBox(txtRemainingGuess3, letter);
                    break;
                case 4:
                    SetIncorrectTextBox(txtRemainingGuess4, letter);
                    break;
                case 5:
                    SetIncorrectTextBox(txtRemainingGuess5, letter);
                    break;
                case 6:
                    SetIncorrectTextBox(txtRemainingGuess6, letter);
                    break;
                default:
                    break;
            }
        }

        private void SetIncorrectTextBox(TextBox t, string letter)
        {
            t.Text = letter;
            t.ForeColor = Color.White;
            t.BackColor = Color.Red;
        }

        private void EndGame(bool isWin)
        {
            //disable everything
            EnableGame(false);

            //display a message (win/loss)
            if (isWin)
            {
                //throw a party
                MessageBox.Show("You Win!", "Winner", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            else
            {
                //fill in the boxes
                FillMissingBoxes();

                //funeral procession
                MessageBox.Show("You Lose!", "Loser", MessageBoxButtons.OK, MessageBoxIcon.Stop);
            }
        }

        private void FillMissingBoxes()
        {
            //what the word is
            int i = 1;
            foreach (char c in lblSecretWord.Text)
            {
                var guessKey = c.ToString().ToUpper();
                var isGuessed = GuessTracker[guessKey];

                if (!isGuessed)
                {
                    //fill in the missing boxes
                    UpdateCorrectLetterBox(guessKey, i, false);
                }
                i++;
            }
        }

        private void btnLetterA_Click(object sender, EventArgs e)
        {
            btnLetterA.Enabled = false;
            SubmitGuess("A");
        }

        private void btnLetterB_Click(object sender, EventArgs e)
        {
            btnLetterB.Enabled = false;
            SubmitGuess("B");
        }

        private void btnLetterC_Click(object sender, EventArgs e)
        {
            btnLetterC.Enabled = false;
            SubmitGuess("C");
        }

        private void btnLetterD_Click(object sender, EventArgs e)
        {
            btnLetterD.Enabled = false;
            SubmitGuess("D");
        }

        private void btnLetterE_Click(object sender, EventArgs e)
        {
            btnLetterE.Enabled = false;
            SubmitGuess("E");
        }

        private void btnLetterF_Click(object sender, EventArgs e)
        {
            btnLetterF.Enabled = false;
            SubmitGuess("F");
        }

        private void btnLetterG_Click(object sender, EventArgs e)
        {
            btnLetterG.Enabled = false;
            SubmitGuess("G");
        }

        private void btnLetterH_Click(object sender, EventArgs e)
        {
            btnLetterH.Enabled = false;
            SubmitGuess("H");
        }

        private void btnLetterI_Click(object sender, EventArgs e)
        {
            btnLetterI.Enabled = false;
            SubmitGuess("I");
        }

        private void btnLetterJ_Click(object sender, EventArgs e)
        {
            btnLetterJ.Enabled = false;
            SubmitGuess("J");
        }

        private void btnLetterK_Click(object sender, EventArgs e)
        {
            btnLetterK.Enabled = false;
            SubmitGuess("K");
        }

        private void btnLetterL_Click(object sender, EventArgs e)
        {
            btnLetterL.Enabled = false;
            SubmitGuess("L");
        }

        private void btnLetterM_Click(object sender, EventArgs e)
        {
            btnLetterM.Enabled = false;
            SubmitGuess("M");
        }

        private void btnLetterN_Click(object sender, EventArgs e)
        {
            btnLetterN.Enabled = false;
            SubmitGuess("N");
        }

        private void btnLetterO_Click(object sender, EventArgs e)
        {
            btnLetterO.Enabled = false;
            SubmitGuess("O");
        }

        private void btnLetterP_Click(object sender, EventArgs e)
        {
            btnLetterP.Enabled = false;
            SubmitGuess("P");
        }

        private void btnLetterQ_Click(object sender, EventArgs e)
        {
            btnLetterQ.Enabled = false;
            SubmitGuess("Q");
        }

        private void btnLetterR_Click(object sender, EventArgs e)
        {
            btnLetterR.Enabled = false;
            SubmitGuess("R");
        }

        private void btnLetterS_Click(object sender, EventArgs e)
        {
            btnLetterS.Enabled = false;
            SubmitGuess("S");
        }

        private void btnLetterT_Click(object sender, EventArgs e)
        {
            btnLetterT.Enabled = false;
            SubmitGuess("T");
        }

        private void btnLetterU_Click(object sender, EventArgs e)
        {
            btnLetterU.Enabled = false;
            SubmitGuess("U");
        }

        private void btnLetterV_Click(object sender, EventArgs e)
        {
            btnLetterV.Enabled = false;
            SubmitGuess("V");
        }

        private void btnLetterW_Click(object sender, EventArgs e)
        {
            btnLetterW.Enabled = false;
            SubmitGuess("W");
        }

        private void btnLetterX_Click(object sender, EventArgs e)
        {
            btnLetterX.Enabled = false;
            SubmitGuess("X");
        }

        private void btnLetterY_Click(object sender, EventArgs e)
        {
            btnLetterY.Enabled = false;
            SubmitGuess("Y");
        }

        private void btnLetterZ_Click(object sender, EventArgs e)
        {
            btnLetterZ.Enabled = false;
            SubmitGuess("Z");
        }
    }
}