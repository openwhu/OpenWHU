# 社会计算实验报告
> * 实验项目-2-虚假新闻识别
> * yaoyue123

此实验是一个文本二分类问题，实验内容主要依照老师模板完成


### 环境要求
```
scikit-learn                       0.19.2
numpy                              1.17.3
pandas                             0.23.4
```


### 数据处理
这里用的是pandas库进行处理数据，比较简单方便，但要注意数据集里有一些错误。
```python
>>fp['label'].value_counts()
0       11604
1        3626
fake        2
Name: label, dtype: int64
```
比如此数据集label中含有两个fake字符,应这样读取label。
```python
 fp['label'].replace("fake", "0").tolist()
```
在读取新闻的时候，除了读取新闻标题，也应考虑到新闻的来源以及新闻属于的版块。
通常情况下，报道过虚假新闻的网站也有很大可能再次报道假新闻，故对url进行处理,
去除掉某些符号和数字，以及开头的https:// 与结尾的.html或.php并添加到文本数据中。
因为不会爬虫，所以tweet_id的数据在这里就忽略了。
```python
url_list = fp['news_url'].tolist()
url_cut = []
for line in url_list:
    newline = str(line).lstrip("htps:/w.").rstrip("html.ph").replace(
        "/", " ").replace("-", " ")
    for i in range(0, 10):
        i = str(i)
        newline = newline.replace(i, "")
    url_cut.append(newline)

news_list = fp['title'].tolist()

for i in range(len(news_list)):
    news_list[i] = news_list[i] + url_cut[i]
```
经测试，使用加入了url的文本数据进行训练要比没加入url的文本数据的准确度高大概1%。


### 特征提取
sklearn库里提供了不少特征提取工具，比如常见的TfidfVectorizer.
这里我是用的是CountVectorizer，因为经过测试由此得出来的准确率要比其他方法高
经测试启用停用词反而准确率会下降。ngram_range=(1, 3)的时候准确零最高，会比
ngram_range=(1, 1)高大概2%
具体代码如下
```python
count_vectorizer = CountVectorizer(stop_words=None, ngram_range=(1, 3))
count_train = count_vectorizer.fit_transform(train_data)
count_valid = count_vectorizer.transform(valid_data)
count_test = count_vectorizer.transform(test_data)
return count_train, count_valid, count_test
```
同理TfidfVectorizer，HashingVectorizer使用方式类似，就不赘述了。


### 训练模型
sklearn库里同样提供了不少方法来训练模型，这里我选择的是逻辑回归算法。
使用库里提供的LogisticRegression()函数，相比与其他函数，LR具有训练时间短，
准确率高等优点，经过测试，比其他方法大概高4%-10%。具体代码如下
```python
LR_model = LogisticRegression()
LR_model.fit(train_x, train_label)
pred = LR_model.predict(valid_x)
print("\nLogisticRegression-score: \nAc\tPr\tRe\tF1\n", score(valid_label, pred)
```
同理sklearn其他函数使用方法也类似，就不赘述了。


### 实验结果
> * 使用CountVectorizer的结果

函数 | accuracy_score | precision_score | recall_score | f1_score
:-: | :-: | :-: | :-: | :-:
MNB|0.8723739495798319| 0.8377483443708609| 0.5659955257270693| 0.6755674232309746
BNB|0.7767857142857143| 0.8928571428571429| 0.05592841163310962| 0.10526315789473684
PAC|0.8786764705882353| 0.7783505154639175| 0.6756152125279642| 0.7233532934131737
LR|0.8823529411764706| 0.8213256484149856| 0.6375838926174496| 0.7178841309823677
ABC|0.8482142857142857| 0.8134920634920635| 0.45861297539149887| 0.5865522174535049
GBC|0.8434873949579832|0.8860103626943006|0.3825503355704698|0.534375
RFC|0.8350840336134454|0.8715083798882681|0.348993288590604|0.49840255591054317
DTC|0.8293067226890757|0.6763005780346821|0.5234899328859061|0.5901639344262295

> * 使用TfidfVectorizer的结果

函数 | accuracy_score | precision_score | recall_score | f1_score
:-: | :-: | :-: | :-: | :-:
MNB|0.805672268907563|0.9529411764705882|0.18120805369127516|0.3045112781954887
BNB|0.7767857142857143|0.8928571428571429|0.05592841163310962|0.10526315789473684
PAC|0.875|0.7391304347826086|0.7225950782997763|0.7307692307692307
LR|0.8671218487394958|0.8592592592592593|0.5190156599552572|0.6471408647140865
ABC|0.8282563025210085|0.6785714285714286|0.5100671140939598|0.5823754789272032
GBC|0.8471638655462185|0.819672131147541|0.44742729306487694|0.5788712011577424
RFC|0.8345588235294118|0.7538461538461538|0.43847874720357943|0.5544554455445545
DTC|0.7778361344537815|0.5240963855421686|0.5838926174496645|0.5523809523809523

> * 使用HashingVectorizer的结果

函数 | accuracy_score | precision_score | recall_score | f1_score
:-: | :-: | :-: | :-: | :-:
MNB|0.7678571428571429|1.0|0.011185682326621925|0.022123893805309738
BNB|0.7652310924369747|0.0|0.0|0.0
PAC|0.8618697478991597|0.764367816091954|0.5950782997762863|0.6691823899371069
LR|0.8639705882352942|0.8643410852713178|0.4988814317673378|0.6326241134751773
ABC|0.8398109243697479|0.77734375|0.4451901565995526|0.566145092460882
CBC|0.8434873949579832|0.8669950738916257|0.39373601789709173|0.5415384615384615
RFC|0.8392857142857143|0.8373205741626795|0.39149888143176736|0.5335365853658537
DTC|0.8172268907563025|0.6341463414634146|0.5234899328859061|0.5735294117647058

> 可以看出CountVectorizer的LR模型效果最好，准确率达到了88.24%


### 写入文件
直接将test_id与预测结果写入submit.txt即可。
预测结果代码如下
```python
result = model.predict(test_data)
print("test result", result)
```

写入文件代码如下
```python
test_result = predict(model, test_x)
    
with open("submit.txt", "w", encoding='utf-8') as fp:
    fp.write('label' + ',' + 'id' + '\n')
    for i in range(len(test_result)):
        label = str(test_result[i])
        id = str(test_id[i])
        fp.write(label + ',' + id + '\n')
```

部分预测结果展示
```
label,id
1,gossipcop-152704263
0,gossipcop-403336283
0,gossipcop-870486
0,gossipcop-907793
0,gossipcop-8960795420
0,gossipcop-929592
1,gossipcop-907418
0,gossipcop-898468
0,gossipcop-895517
0,gossipcop-899671
1,gossipcop-2123292210
1,gossipcop-5722761061
0,gossipcop-883288
0,gossipcop-882628
```

### 总结反思
sklearn 提供了许多函数供我们使用，不过使用时需要注意使用的格式。
Python以其第三方库丰富而著称，有时候选择适当的工具，可以更加方便
也可减少代码行数，比如读取文件用Pandas，比用自带的函数要更简洁，
也更不容易报错。然后通过这次实验，自己实现了一个简单的文本分类模型，
自己也对深度学习有了更深入的认识。

