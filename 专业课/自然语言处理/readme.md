# 武大网安NLP自然语言处理实验和理论课资料

by 2023级 🦖

本项目包含了武汉大学国家网络安全学院自然语言处理(NLP)实验，涵盖了从基础的词向量表示到高级的大模型应用等多个方面。

## 实验目录

### 1. 词向量实验

* 使用jieba分词对中文文本进行预处理
* 利用gensim库训练Word2Vec模型
* 计算词语相似度和词向量运算
* 使用PCA对词向量进行降维可视化

### 2. 文本分类实验

基于THUCNews数据集(20万条新闻标题，10个类别)进行中文文本分类研究，实现了多种深度学习模型：

#### 模型架构

* **FastText**: 简单高效的浅层神经网络模型
* **TextCNN**: 卷积神经网络模型，利用不同尺寸的卷积核提取文本特征
* **TextRNN**: 循环神经网络模型，能够捕捉文本序列信息
* **TextRNN+Attention**: 在TextRNN基础上引入注意力机制
* **TextRCNN**: 结合RNN和CNN的优势
* **DPCNN**: 深度金字塔CNN模型
* **BiLSTM**: 双向长短期记忆网络
* **Transformer**: 基于自注意力机制的模型

### 3. 句法分析实验

基于PyTorch实现的神经依赖解析器(Biaffine Dependency Parsing)

### 4. 实体识别实验

基于ResumeNER数据集进行命名实体识别(NER)任务，对比了多种模型效果：

#### 模型对比

* **HMM**: 隐马尔可夫模型
* **CRF**: 条件随机场
* **BiLSTM**: 双向LSTM模型
* **BiLSTM+CRF**: 结合BiLSTM和CRF
* **CNN+CRF**: 卷积神经网络结合CRF

### 5. 预训练模型实验

实现了简化版的BERT模型(MyBERT)，用于理解预训练语言模型的核心原理：

#### 核心组件

* **Masked Language Model(MLM)**: 掩码语言模型任务
* **Next Sentence Prediction(NSP)**: 下一句预测任务
* **Multi-Head Self-Attention**: 多头自注意力机制
* **Positional Encoding**: 位置编码

#### 参数调优

通过实验分析了不同超参数(batch_size, d_model, n_heads等)对模型性能的影响

### 6. 大模型应用实验

基于阿里云通义千问(Qwen)大模型构建的代码生成Web应用：

#### 功能特性

* 网页交互界面，支持任务描述输入
* 调用Qwen模型生成Python代码
* 可调节生成参数(max_tokens, temperature)
* 实时展示生成结果和输出说明

#### 技术栈

* Flask Web框架
* OpenAI API接口调用
* Bootstrap前端样式
* Markdown格式化渲染

#### 使用方法

1. 配置阿里云API Key
2. 运行`python app.py`启动服务
3. 访问`http://localhost:5000`使用应用

## 注意事项

1. 部分实验需要较大的内存和计算资源
2. 运行前请确保已安装所需依赖
3. 某些实验可能需要下载预训练模型或数据集
