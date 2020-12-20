import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score


"""
这个是用LogisticsRegression做二分类的代码
"""

def get_data(data_name='train'):
	if data_name == 'train':
		train_x = np.array([[0.2, -1.2, 0.3, -1.5, 0.0], 
			  	[2.1, 0.3, -2.1, 3.0, 2.0],
			  	[1.2, 0.4, 1.2, -0.8, 1.3],
			  	[1.3, -2.0, 4.5, 2.0, -2.4],
			  	[0.3, 1.0, 2.5, 1.0, 2.1],
			  	[0.1, 0.1, -2.5, 1.9, -1.0]])

		train_y = np.array([1, 0, 0, 1, 1, 0]) 
		return train_x, train_y
	if data_name == 'valid':
		valid_x = np.array([[1.0, 2.3, 0.4, 1.1, 0.9],
					 [0.2, -0.3, -2.0, 2.8, 0.3],
					 [1.2, -2.3, 0.0, 1.8, 1.3]])
		valid_y = np.array([0, 1, 1])

		return valid_x, valid_y

	test_id = [1,2,3,4]
	test_x = np.array([[0.08, 2.3,-0.4, 1.1, 1.9],
					 [0.2, 0.3, 2.0, -1.8, 1.3],
					 [1.1, 0.8, -2.0, 1.8, -1.3],
					 [2.2, 0.1, 2.0, -1.7, 0.0]])

	return test_id, test_x

def train_model(train_x, train_y, valid_x, valid_y):
	#定义模型
	model = LogisticRegression()
	#开始训练,使用训练集的train_x 和train_y
	model.fit(train_x, train_y)
	#训练完毕，预测一下验证集
	prediction = model.predict(valid_x)
	#评估一下真正的结果和预测的结果的差异
	score = accuracy_score(valid_y, prediction)
	#打印预测的结果和得分
	print(prediction, "score: {:.4f}".format(score))
	return model


def run_step():

	#得到训练、验证和测试数据，这一步只是演示，所以没有使用文本数据
	#数据都是随机生成的
	train_x, train_y = get_data(data_name='train')
	valid_x, valid_y= get_data(data_name='valid')
	test_id, test_x = get_data(data_name='test')

	# 开始训练模型，使用train_x, train_y训练，valid_x, valid_y验证
	model = train_model(train_x, train_y, valid_x, valid_y)
	#使用训练好的模型训练，得到预测结果
	result = model.predict(test_x)
	#打印预测结果
	print("test result", result)
	#将结果和id写入文件夹中
	with open("submit.txt", "w", encoding='utf-8') as f:
		f.write("id\tlabels\n")
		for i in range(len(result)):
			idx = str(test_id[i])
			lable = str(result[i])
			f.write(idx + '\t' + lable + '\n')


if __name__ == '__main__':
	run_step()