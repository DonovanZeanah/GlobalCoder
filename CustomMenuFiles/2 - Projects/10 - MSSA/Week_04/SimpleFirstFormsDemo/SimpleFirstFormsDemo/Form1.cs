using System.Diagnostics;
using System.Text;

namespace SimpleFirstFormsDemo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            var name = txtName.Text;
            var color = txtColor.Text;

            Debug.WriteLine($"Name: {name}");
            Debug.WriteLine($"Color: {color}");
        }

        private void btnShowDemo_Click(object sender, EventArgs e)
        {
            string one = "John";
            string two = "Doe";

            string fullName1 = one + " " + two;
            string fullName2 = $"{one} {two}";
            StringBuilder fullName3 = new StringBuilder();
            fullName3.Append(one);
            fullName3.Append(" ");
            fullName3.Append(two);
            fullName3.Append(" ");
            string fullName4 = string.Empty;

            for (int i = 1; i <= 10; i++)
            {
                fullName1 += " " + i;
                fullName2 += $" {i}";
                if (i > 1)
                {
                    fullName3.Append(", ");
                }
                fullName3.Append(i);
            }

            var item1 = new ListViewItem();
            item1.Text = fullName1;
            var item2 = new ListViewItem();
            item2.Text = fullName2;
            var item3 = new ListViewItem();
            item3.Text = fullName3.ToString();

            var formattedValue = string.Format("{0} {1} {2} {3} " +
                                                "{4} {5} {6} {7}"
                                            , one
                                            , two
                                            , 1
                                            , 2
                                            , 3
                                            , 4
                                            , 5
                                            , 6);

            var item4 = new ListViewItem();
            item4.Text = formattedValue;


            listBox1.Items.Add(item1.Text);
            listBox1.Items.Add(item2.Text);
            listBox1.Items.Add(item3.Text);
            listBox1.Items.Add(item4.Text);
        }
    }
}