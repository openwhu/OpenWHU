namespace FirstWindowApp
{
    partial class Form1
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
            this.button_large = new System.Windows.Forms.Button();
            this.button_small = new System.Windows.Forms.Button();
            this.button_cancel = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // button_large
            // 
            this.button_large.Location = new System.Drawing.Point(47, 277);
            this.button_large.Name = "button_large";
            this.button_large.Size = new System.Drawing.Size(94, 37);
            this.button_large.TabIndex = 0;
            this.button_large.Text = "放大";
            this.button_large.UseVisualStyleBackColor = true;
            this.button_large.Click += new System.EventHandler(this.button1_Click);
            // 
            // button_small
            // 
            this.button_small.Location = new System.Drawing.Point(240, 277);
            this.button_small.Name = "button_small";
            this.button_small.Size = new System.Drawing.Size(92, 37);
            this.button_small.TabIndex = 1;
            this.button_small.Text = "缩小";
            this.button_small.UseVisualStyleBackColor = true;
            this.button_small.Click += new System.EventHandler(this.button2_Click);
            // 
            // button_cancel
            // 
            this.button_cancel.Location = new System.Drawing.Point(409, 277);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(108, 37);
            this.button_cancel.TabIndex = 2;
            this.button_cancel.Text = "结束";
            this.button_cancel.UseVisualStyleBackColor = true;
            this.button_cancel.Click += new System.EventHandler(this.button3_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(257, 73);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(39, 15);
            this.label1.TabIndex = 3;
            this.label1.Text = "Test";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(632, 351);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.button_small);
            this.Controls.Add(this.button_large);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button_large;
        private System.Windows.Forms.Button button_small;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.Label label1;
    }
}

