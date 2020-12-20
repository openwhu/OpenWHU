### 中文垃圾短信

这是一个常见文本二分类问题，使用了两种不同的模型进行处理。
> * [BERT模型](spam_massage_with_bert.ipynb)

不得不说谷歌的bert就是厉害，仅仅跑了一个epoch，准确率就达到了99%。
不过好是好，就是训练要求高，一个epochs用k80训练大概在10min左右。
推荐配合谷歌的colab进行使用。

> * [LR模型](main.py)

利用jieba分词，tfidf转换成词向量，LR进行训练