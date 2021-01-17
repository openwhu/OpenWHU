import numpy as np
import pandas as pd
from sklearn import tree
from sklearn.ensemble import (AdaBoostClassifier, GradientBoostingClassifier,
                              RandomForestClassifier)
from sklearn.feature_extraction.text import (CountVectorizer,
                                             HashingVectorizer,
                                             TfidfVectorizer)
from sklearn.linear_model import (LogisticRegression,
                                  PassiveAggressiveClassifier)
from sklearn.metrics import (accuracy_score, f1_score, precision_score,
                             recall_score)
from sklearn.naive_bayes import BernoulliNB, MultinomialNB
"""
@author: yaoyue123
2019/11/26
社会计算（跨）第一次作业demo
"""


def read_train_valid(filename):
    """
    读取训练或者验证文件
    :param filename: 训练集/验证集的文件名字
    :return:
    返回训练集的文本和标签
    其中文本是一个list, 标签是一个list(每个元素为int)
    返回示例：['我很开心', '你不是真正的快乐', '一切都是假的], [1, 0, 0]
    """

    fp = pd.read_table(filename, sep=',', error_bad_lines=False)

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

    #绝了，虚假新闻数据集里的label里有俩 "fake"字符
    return news_list, list(map(int, fp['label'].replace("fake", "0").tolist()))


def read_test(filename):
    """
    读取测试文件
    :param filname: 测试集文件名字
    :return:
    返回测试集文本和对应的id编号
    其中文本是一个list, id就是文件中的id
    返回示例：['我很开心', '你不是真正的快乐', '一切都是假的], [1,2,3]
    """

    fp = pd.read_table(filename, sep=',', error_bad_lines=False)
    url_list = fp['news_url'].tolist()
    url_cut = []

    #对url进行清洗
    for line in url_list:
        newline = str(line).lstrip("htps:/w.").rstrip("html.ph").replace(
            "/", " ").replace("-", " ")
        #去除数字
        for i in range(0, 10):
            i = str(i)
            newline = newline.replace(i, "")
        url_cut.append(newline)

    news_list = fp['title'].tolist()

    for i in range(len(news_list)):
        news_list[i] = news_list[i] + url_cut[i]

    return news_list, fp['id'].tolist()


def split_text(text_data):
    """
    将原始文本分词
    例如：输入['今天星期四', '明天有雨'],
             返回[['今天','星期四'], ['明天','有','雨']]

    或者例如：输入['I don't want to go', ''Who are you?’],
            返回[['I', 'don't', 'want', 'to', 'go',],['Who', ' are', 'you',' ?']]
        中文推荐jieba分词(请pip install jieba)，英文直接用空格切分句子即可
    :param text_data:
    :return:
    """
    #英文文本无需分词，直接返回即可
    return text_data


#此特征提取方法最好
def vectorizer(train_data, valid_data, test_data):
    """
    将原始文本转化为向量
    可选方法
    1. one hot 方法, 2. tf-idf方法，3. 词向量或者其他方法
    推荐使用1或者2的方法，两种方法都可以选择调用第三方包或者自己实现
    可用的包：
    CountVectorizer, TfidfVectorizer可以实现one-hot和tfd-idf编码
    使用tf-idf比onehot有加分; 自己实现比调用第三方包有额外加分
    愿意使用词向量也可
    返回示例：[[0,0,1,2], [2,3,3,4]]
                   [[0,0,1,2], [2,3,3,4]]
                    [[0,0,1,2], [2,3,3,4]]
    分别对应train, valid, test的向量化结果，每一个结果都是一个二维的list, 每一个元素都是int or float
    :param text:  一个list, 每个元素是一句话
    :return: 3个二维list
    """
    #经测试启用stop_words反而准确率会下降， ngram_range=(1, 3)的时候准确零最高
    count_vectorizer = CountVectorizer(stop_words=None, ngram_range=(1, 3))
    count_train = count_vectorizer.fit_transform(train_data)
    count_valid = count_vectorizer.transform(valid_data)
    count_test = count_vectorizer.transform(test_data)
    return count_train, count_valid, count_test


#tfidf
def vectorizer1(train_data, valid_data, test_data):
    tfidf_vectorizer = TfidfVectorizer(stop_words=None, ngram_range=(1, 3))
    tfidf_train = tfidf_vectorizer.fit_transform(train_data)
    tfidf_valid = tfidf_vectorizer.transform(valid_data)
    tfidf_test = tfidf_vectorizer.transform(test_data)
    return tfidf_train, tfidf_valid, tfidf_test


#hash
def vectorizer2(train_data, valid_data, test_data):
    hash_vectorizer = HashingVectorizer(stop_words=None,non_negative=True)
    hash_train = hash_vectorizer.fit_transform(train_data)
    hash_valid = hash_vectorizer.transform(valid_data)
    hash_test = hash_vectorizer.transform(test_data)
    return hash_train, hash_valid, hash_test


#评分函数
def score(valid_label, pred):
    return accuracy_score(valid_label, pred), precision_score(
        valid_label, pred), recall_score(valid_label,
                                         pred), f1_score(valid_label, pred)


def train_valid(train_x, train_label, valid_x, valid_label):
    """
    开始训练模型并使用验证集验证效果
    推荐方法
    1. 朴素贝叶斯: 可用包 BernoulliNB,
    2. LogisticRegression 可用包 sklearn中的LogisticsRegression
    3. 其他方法不做强制性要求
    以上方法，自己实现比调包加分，手动实现 LR比手动实现朴素贝叶斯加分
    调包示例：
        model = one_model()
        model.some_func(train_data, train_label)
        score = model.score_function(valid_data, valid_label)
        print("valid accuracy score is {:.4f}".format(score}


        以上只计算了accuracy score，如果能打印验证集precision_score, recall_score, F1_score， 加分
        可以调用 sklearn.metric 中的precision_score, recall_score, F1_score
        请试着调节模型的参数，将你的各项score尽量提高，验证集分数越高，测试集的效果也可能越好
        也推荐同学们尝试交叉验证方法，提升模型的泛化能力
        最终返回训练完成的模型 model
    :param train_data:
    :param train_label:
    :param valid_data:
    :param valid_label:
    :return:
    """
    """
    # 定义模型
    model = LogisticRegression()
    # 开始训练,使用训练集的train_x 和train_y
    model.fit(train_x, train_label)
    # 训练完毕，预测一下验证集
    prediction = model.predict(valid_x)
    # 打印预测的结果和得分
    print(prediction)
    print('Accuracy score: {:.4f}'.format(
        accuracy_score(valid_label, prediction)))
    print('Precision score: {:.4f}'.format(
        precision_score(valid_label, prediction)))
    print('Recall score: {:.4f}'.format(recall_score(valid_label, prediction)))
    print('F1 score: {:.4f}'.format(f1_score(valid_label, prediction)))

    return model
    """

    #两种朴素贝叶斯分布

    #1 多项式分布的朴素贝叶斯
    MNB_model = MultinomialNB()
    MNB_model.fit(train_x, train_label)
    pred = MNB_model.predict(valid_x)
    print("\nMultinomialNB-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #2 伯努利分布的朴素贝叶斯
    BNB_model = BernoulliNB()
    BNB_model.fit(train_x, train_label)
    pred = BNB_model.predict(valid_x)
    print("\nBernoulliNB-score: \nAc\tPr\tRe\tF1\n", score(valid_label, pred))

    #两种线性回归算法模型

    #1 被动攻击算法
    PAC_model = PassiveAggressiveClassifier()
    PAC_model.fit(train_x, train_label)
    pred = PAC_model.predict(valid_x)
    print("\nPassiveAggressiveClassifier-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #2 逻辑回归算法
    LR_model = LogisticRegression()
    LR_model.fit(train_x, train_label)
    pred = LR_model.predict(valid_x)
    print("\nLogisticRegression-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #剩下几种模型运行时间较长，效果也无明显提升，可选择注释掉
    #三种集成学习分类
    #1
    ABC_model = AdaBoostClassifier()
    ABC_model.fit(train_x, train_label)
    pred = ABC_model.predict(valid_x)
    print("\nAdaBoostClassifier-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #2 此模型训练时间较长
    GBC_model = GradientBoostingClassifier(n_estimators=200)
    GBC_model.fit(train_x, train_label)
    pred = GBC_model.predict(valid_x)
    print("\nGradientBoostingClassifier-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #3
    RFC_model = RandomForestClassifier(n_estimators=8)
    RFC_model.fit(train_x, train_label)
    pred = RFC_model.predict(valid_x)
    print("\nRandomForestClassifier-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    #决策树
    DTC_model = tree.DecisionTreeClassifier()
    DTC_model.fit(train_x, train_label)
    pred = DTC_model.predict(valid_x)
    print("\nDecisionTreeClassifier-score: \nAc\tPr\tRe\tF1\n",
          score(valid_label, pred))

    # LR 在此表现最好故返回为LR_model
    return LR_model


def predict(model, test_data):
    """
    使用训练好的模型预测测试数据
    返回预测的标签，为list
    :param mode:
    :param test_data:
    :return:
    """
    result = model.predict(test_data)
    print("test result", result)
    return result


def run_step():
    """
        选择相应的任务和文件
        读文件，train_data, train_label = some_function(filename='')
                    valid_data, validlabel = some_function(filename='')
                   test_data, test_ids = some_function(filename='')
        将原始文本分词：
                  train_data = split_function(train_data)
                  valid_data = split_function(valid_data)
                  test_data = split_function(test_data)
        将分词后的文本变成向量：
                  train_vec, valid_vec, test_vec = vectorizer(train_data, valid_data, test_data)
        开始训练模型：
                model = train_function(train_vec, train_label, valid_vec, valid_label)
        开始预测结果：
                 test_result = predict(mode, test_data)
        写入文件：
                将test和对应的test写入test_result, 结果样本如submit所示
        请大家尽量按照步骤来，顺利完成整个流程。有余力的同学可以试试提高预测的精度
    :return:
    """
    train_sentences, train_label = read_train_valid(filename=r'training.txt')
    test_sentences, test_id = read_test(filename=r'test.txt')
    valid_sentences, valid_label = read_train_valid(filename=r'validation.txt')

    train_sentences_split = split_text(train_sentences)
    test_sentences_split = split_text(test_sentences)
    valid_sentences_split = split_text(valid_sentences)
    """
    # 遍历所有的句子，并打印编号和句子内容
    print(1, train_sentences, train_label)
    print(2, test_sentences, test_id)
    print(3, valid_sentences, valid_label)
    print(4, train_sentences_split)
    print(
        5,
        vectorizer(train_sentences_split, valid_sentences_split,
                   test_sentences_split))
    """
    train_x, valid_x, test_x = vectorizer(train_sentences_split,
                                          valid_sentences_split,
                                          test_sentences_split)

    model = train_valid(train_x, train_label, valid_x, valid_label)

    test_result = predict(model, test_x)
    
    with open("submit.txt", "w", encoding='utf-8') as fp:
        fp.write('label' + ',' + 'id' + '\n')
        for i in range(len(test_result)):
            label = str(test_result[i])
            id = str(test_id[i])
            fp.write(label + ',' + id + '\n')


if __name__ == '__main__':
    run_step()
