import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import BernoulliNB

"""
@author: XXX
2019/10/30
社会计算（跨）第一次作业demo
"""
min_freq = 5

def read_train_valid(filname):
    """
    读取训练或者验证文件
    :param filname: 训练集/验证集的文件名字
    :return:
    返回训练集的文本和标签
    其中文本是一个list, 标签是一个list(每个元素为int)
    返回示例：['我很开心', '你不是真正的快乐', '一切都是假的], [1, 0, 0]
    """
    pass

def read_test(filename):
    """
    读取测试文件
    :param filname: 测试集文件名字
    :return:
    返回测试集文本和对应的id编号
    其中文本是一个list, id就是文件中的id
    返回示例：['我很开心', '你不是真正的快乐', '一切都是假的], [1,2,3]
    """
    pass

def split_text(text_data):
    """
    将原始文本分词
    例如：输入['今天星期四', '明天有雨'],
             返回[['今天‘，‘星期四’], ['明天','有‘，‘雨']]
            
    或者例如：输入['I don't want to go', ''Who are you?’],
            返回[['I', 'don't', 'want', 'to', 'go',],['Who', ' are', 'you',' ?']]
        中文推荐jieba分词(请pip install jieba)，英文直接用空格切分句子即可
    :param text_data:
    :return:
    """
    pass

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
    pass

def train_valid(train_data, train_label, valid_data, valid_label):
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
    pass

def predict(mode, test_data):
    """
    使用训练好的模型预测测试数据
    返回预测的标签，为list
    :param mode:
    :param test_data:
    :return:
    """
    pass

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
    pass
    
    
if __name__ == '__main__':
    run_step()
