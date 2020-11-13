namespace EmojiForm
{
    partial class ModifyForm
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
            this.pictureBoxEmoji = new System.Windows.Forms.PictureBox();
            this.button1 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.seriesTextBox = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.targetTextBox = new System.Windows.Forms.TextBox();
            this.keywordTextBox = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxEmoji)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // pictureBoxEmoji
            // 
            this.pictureBoxEmoji.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBoxEmoji.Location = new System.Drawing.Point(10, 10);
            this.pictureBoxEmoji.Margin = new System.Windows.Forms.Padding(4);
            this.pictureBoxEmoji.Name = "pictureBoxEmoji";
            this.pictureBoxEmoji.Size = new System.Drawing.Size(743, 340);
            this.pictureBoxEmoji.TabIndex = 4;
            this.pictureBoxEmoji.TabStop = false;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(82, 241);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(251, 38);
            this.button1.TabIndex = 16;
            this.button1.Text = "确认";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(42, 41);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(125, 18);
            this.label1.TabIndex = 10;
            this.label1.Text = "标签/关键字：";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(69, 103);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(98, 18);
            this.label2.TabIndex = 11;
            this.label2.Text = "目标对象：";
            // 
            // seriesTextBox
            // 
            this.seriesTextBox.Location = new System.Drawing.Point(212, 152);
            this.seriesTextBox.Name = "seriesTextBox";
            this.seriesTextBox.Size = new System.Drawing.Size(147, 28);
            this.seriesTextBox.TabIndex = 15;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(105, 162);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(62, 18);
            this.label3.TabIndex = 12;
            this.label3.Text = "系列：";
            // 
            // targetTextBox
            // 
            this.targetTextBox.Location = new System.Drawing.Point(212, 93);
            this.targetTextBox.Name = "targetTextBox";
            this.targetTextBox.Size = new System.Drawing.Size(147, 28);
            this.targetTextBox.TabIndex = 14;
            // 
            // keywordTextBox
            // 
            this.keywordTextBox.Location = new System.Drawing.Point(212, 38);
            this.keywordTextBox.Name = "keywordTextBox";
            this.keywordTextBox.Size = new System.Drawing.Size(147, 28);
            this.keywordTextBox.TabIndex = 13;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.button1);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Controls.Add(this.seriesTextBox);
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.targetTextBox);
            this.panel1.Controls.Add(this.keywordTextBox);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(348, 10);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(405, 340);
            this.panel1.TabIndex = 19;
            // 
            // ModifyForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 18F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(763, 360);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.pictureBoxEmoji);
            this.Name = "ModifyForm";
            this.Padding = new System.Windows.Forms.Padding(10);
            this.Text = "ModifyForm";
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxEmoji)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.PictureBox pictureBoxEmoji;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox seriesTextBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox targetTextBox;
        private System.Windows.Forms.TextBox keywordTextBox;
        private System.Windows.Forms.Panel panel1;
    }
}