namespace exp6xapp
{
    partial class Form_exp6
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.sortByNameToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sortByNameDownToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sortByIDToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sortByIDDownToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sortByIQToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sortByIQDownToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.SS1 = new System.Windows.Forms.StatusStrip();
            this.tb_result = new System.Windows.Forms.TextBox();
            this.SSL1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.menuStrip1.SuspendLayout();
            this.SS1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.sortByNameToolStripMenuItem,
            this.sortByNameDownToolStripMenuItem,
            this.sortByIDToolStripMenuItem,
            this.sortByIDDownToolStripMenuItem,
            this.sortByIQToolStripMenuItem,
            this.sortByIQDownToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(774, 28);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // sortByNameToolStripMenuItem
            // 
            this.sortByNameToolStripMenuItem.Name = "sortByNameToolStripMenuItem";
            this.sortByNameToolStripMenuItem.Size = new System.Drawing.Size(112, 24);
            this.sortByNameToolStripMenuItem.Text = "SortByName";
            this.sortByNameToolStripMenuItem.Click += new System.EventHandler(this.sortByNameToolStripMenuItem_Click);
            // 
            // sortByNameDownToolStripMenuItem
            // 
            this.sortByNameDownToolStripMenuItem.Name = "sortByNameDownToolStripMenuItem";
            this.sortByNameDownToolStripMenuItem.Size = new System.Drawing.Size(154, 24);
            this.sortByNameDownToolStripMenuItem.Text = "SortByNameDown";
            this.sortByNameDownToolStripMenuItem.Click += new System.EventHandler(this.sortByNameDownToolStripMenuItem_Click);
            // 
            // sortByIDToolStripMenuItem
            // 
            this.sortByIDToolStripMenuItem.Name = "sortByIDToolStripMenuItem";
            this.sortByIDToolStripMenuItem.Size = new System.Drawing.Size(84, 24);
            this.sortByIDToolStripMenuItem.Text = "SortByID";
            this.sortByIDToolStripMenuItem.Click += new System.EventHandler(this.sortByIDToolStripMenuItem_Click);
            // 
            // sortByIDDownToolStripMenuItem
            // 
            this.sortByIDDownToolStripMenuItem.Name = "sortByIDDownToolStripMenuItem";
            this.sortByIDDownToolStripMenuItem.Size = new System.Drawing.Size(126, 24);
            this.sortByIDDownToolStripMenuItem.Text = "SortByIDDown";
            this.sortByIDDownToolStripMenuItem.Click += new System.EventHandler(this.sortByIDDownToolStripMenuItem_Click);
            // 
            // sortByIQToolStripMenuItem
            // 
            this.sortByIQToolStripMenuItem.Name = "sortByIQToolStripMenuItem";
            this.sortByIQToolStripMenuItem.Size = new System.Drawing.Size(85, 24);
            this.sortByIQToolStripMenuItem.Text = "SortByIQ";
            this.sortByIQToolStripMenuItem.Click += new System.EventHandler(this.sortByIQToolStripMenuItem_Click);
            // 
            // sortByIQDownToolStripMenuItem
            // 
            this.sortByIQDownToolStripMenuItem.Name = "sortByIQDownToolStripMenuItem";
            this.sortByIQDownToolStripMenuItem.Size = new System.Drawing.Size(127, 24);
            this.sortByIQDownToolStripMenuItem.Text = "SortByIQDown";
            this.sortByIQDownToolStripMenuItem.Click += new System.EventHandler(this.sortByIQDownToolStripMenuItem_Click);
            // 
            // SS1
            // 
            this.SS1.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.SS1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.SSL1});
            this.SS1.Location = new System.Drawing.Point(0, 302);
            this.SS1.Name = "SS1";
            this.SS1.Size = new System.Drawing.Size(774, 25);
            this.SS1.TabIndex = 1;
            this.SS1.Text = "statusStrip1";
            // 
            // tb_result
            // 
            this.tb_result.Location = new System.Drawing.Point(12, 31);
            this.tb_result.Multiline = true;
            this.tb_result.Name = "tb_result";
            this.tb_result.ReadOnly = true;
            this.tb_result.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.tb_result.Size = new System.Drawing.Size(750, 270);
            this.tb_result.TabIndex = 2;
            this.tb_result.TabStop = false;
            // 
            // SSL1
            // 
            this.SSL1.Name = "SSL1";
            this.SSL1.Size = new System.Drawing.Size(100, 20);
            this.SSL1.Text = "SortByName";
            // 
            // Form_exp6
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(774, 327);
            this.Controls.Add(this.tb_result);
            this.Controls.Add(this.SS1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form_exp6";
            this.Text = "Sort by various keys";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.SS1.ResumeLayout(false);
            this.SS1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.StatusStrip SS1;
        private System.Windows.Forms.ToolStripMenuItem sortByNameToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sortByNameDownToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sortByIDToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sortByIDDownToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sortByIQToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sortByIQDownToolStripMenuItem;
        private System.Windows.Forms.TextBox tb_result;
        private System.Windows.Forms.ToolStripStatusLabel SSL1;
    }
}

