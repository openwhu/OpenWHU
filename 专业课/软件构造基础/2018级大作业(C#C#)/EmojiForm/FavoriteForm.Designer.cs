namespace EmojiForm
{
    partial class FavoriteForm
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
            this.components = new System.ComponentModel.Container();
            this.BtnChange = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.export = new System.Windows.Forms.Button();
            this.imageList = new System.Windows.Forms.ImageList(this.components);
            this.dataGridViewImage = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.selectedText = new System.Windows.Forms.Label();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewImage)).BeginInit();
            this.flowLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // BtnChange
            // 
            this.BtnChange.Location = new System.Drawing.Point(14, 14);
            this.BtnChange.Margin = new System.Windows.Forms.Padding(4);
            this.BtnChange.Name = "BtnChange";
            this.BtnChange.Size = new System.Drawing.Size(130, 50);
            this.BtnChange.TabIndex = 7;
            this.BtnChange.Text = "修改";
            this.BtnChange.UseVisualStyleBackColor = true;
            this.BtnChange.Click += new System.EventHandler(this.BtnChange_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Location = new System.Drawing.Point(13, 71);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(130, 50);
            this.btnDelete.TabIndex = 6;
            this.btnDelete.Text = "删除";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // export
            // 
            this.export.Location = new System.Drawing.Point(13, 127);
            this.export.Name = "export";
            this.export.Size = new System.Drawing.Size(130, 50);
            this.export.TabIndex = 5;
            this.export.Text = "批量导出";
            this.export.UseVisualStyleBackColor = true;
            this.export.Click += new System.EventHandler(this.export_Click);
            // 
            // imageList
            // 
            this.imageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit;
            this.imageList.ImageSize = new System.Drawing.Size(100, 100);
            this.imageList.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // dataGridViewImage
            // 
            this.dataGridViewImage.AllowUserToAddRows = false;
            this.dataGridViewImage.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewImage.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGridViewImage.Location = new System.Drawing.Point(0, 0);
            this.dataGridViewImage.Name = "dataGridViewImage";
            this.dataGridViewImage.RowHeadersWidth = 62;
            this.dataGridViewImage.RowTemplate.Height = 30;
            this.dataGridViewImage.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dataGridViewImage.Size = new System.Drawing.Size(1100, 690);
            this.dataGridViewImage.TabIndex = 8;
            this.dataGridViewImage.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewImage_CellContentClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(20, 190);
            this.label1.Margin = new System.Windows.Forms.Padding(10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(98, 18);
            this.label1.TabIndex = 8;
            this.label1.Text = "当前选中：";
            // 
            // selectedText
            // 
            this.selectedText.AutoSize = true;
            this.selectedText.Location = new System.Drawing.Point(20, 228);
            this.selectedText.Margin = new System.Windows.Forms.Padding(10);
            this.selectedText.Name = "selectedText";
            this.selectedText.Size = new System.Drawing.Size(0, 18);
            this.selectedText.TabIndex = 9;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.BtnChange);
            this.flowLayoutPanel1.Controls.Add(this.btnDelete);
            this.flowLayoutPanel1.Controls.Add(this.export);
            this.flowLayoutPanel1.Controls.Add(this.label1);
            this.flowLayoutPanel1.Controls.Add(this.selectedText);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(943, 0);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Padding = new System.Windows.Forms.Padding(10);
            this.flowLayoutPanel1.Size = new System.Drawing.Size(157, 690);
            this.flowLayoutPanel1.TabIndex = 10;
            // 
            // FavoriteForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 18F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1100, 690);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Controls.Add(this.dataGridViewImage);
            this.Name = "FavoriteForm";
            this.Text = "我的收藏";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewImage)).EndInit();
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button BtnChange;
        private System.Windows.Forms.Button btnDelete;
        private System.Windows.Forms.Button export;
        private System.Windows.Forms.ImageList imageList;
        private System.Windows.Forms.DataGridView dataGridViewImage;
        private System.Windows.Forms.Label selectedText;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
    }
}