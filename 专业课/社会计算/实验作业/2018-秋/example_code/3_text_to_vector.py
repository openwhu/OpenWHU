import jieba

#最低频率，即小于这个频率的单词都会被忽略
min_freq = 1

def readFile(filename):
	#读文件， filename是文件名，‘r’表示读，encoding='utf-8'表示以‘utf-8’打开文件
	#返回结果是一个类似字符串，即整篇文章可以当一个str处理
	content = open(filename, 'r', encoding='utf-8').read()
	#切分，按照换行符‘\n’切分成一句一句的
	#结果是一个list， 每一句里面都是一个str对象
	sentences = content.split('\n')

	return sentences


def split_text(sentences):
	#切分句子

	labels = []
	sentences_splited = []
	for i in range(len(sentences)):
		if i == 0:    #第一行是表头，不用管, 从第二行开始读
			continue 
		sentence = sentences[i]
		#对每一个句子按照'\t'切开为标签和文本
		sentence = sentence.split('\t')
		#第一个元素为标签，转换成int型
		label = int(sentence[0])
		#第二个元素为句子文本，分词并将每一个词变为str对象,最终得到一个列表
		sentence = list(jieba.cut(sentence[1]))

		#将每一次读到的label添加到最终的labels列表后面
		labels.append(label)
		#将每一次读到的分词后的文本添加到最终的sentences_splited列表后面
		sentences_splited.append(sentence)

	return sentences_splited, labels

def text_to_vector(sentences):
	"""
	#使用one-hot方法将文本转为向量, 例如：
		Sentence1 不 知道 你 在 说 什么 。
		Sentence2 我 就 知道 你 不 知道 。
		词表： 不 就 你 什么 我 说 知道 在 。
		S1 [1 0 1 1 0 1 1 1 1]
		S2 [1 1 1 0 1 0 2 0 1]
	即得到分词后的句子之后，先得到词表
	每个词对应一个位置，如“不”对应第一个位置，等等
	如果s1出现了不一次，就把s1的第一个位置设为1,如果没有出现就是0，
	 如果出现了两次“不”，那么s1的第一个位置就是2，以此类推
	"""

	# 先将所有句子合成一个超长列表
	print(sentences)
	all_list = []
	for i in range(len(sentences)):
		print(sentences[i])
		all_list += sentences[i]

	#然后统计每一个词出现的频率
	word_count = dict()

	for i in range(len(all_list)):
		word = all_list[i]
		if word in word_count:
			word_count[word] = word_count[word] + 1
		else:
			word_count[word] = 1

	#这样所有词语都在这个列表all_list里面，然后进行编号，利用一个类似hash的方法进行映射
	#遍历每个词语，如果他在前面出现了，就跳过，否则，就给他一个递增的编号
	#这里需要用到python 的dict，每一个key对应一个元素
	#可以以O(1)的方法查找一个元素key对应的value
	#具体dict的用法可以自行学习
	word_to_id = dict()
	for i in range(len(all_list)):
		# 得到一个词语
		word = all_list[i]
		# 查看word是否在word_to_id这个字典中出现
		if word in word_to_id:
			continue
		#这一行的作用是过滤低频单词，
		#如果word的频率小于最低频率，就忽略掉这个单词
		if word_count[word] < min_freq:
			continue
		#没有出现，那么给他一个id,假设前面已经有若干个词语["我"，"不能"，"是"]
		# 被编码为[0, 1, 2],即：{'我':0, '不能':1,'是':2}
		# 那么就给word编码为3，正好等于word_to_id的长度e
		word_index = len(word_to_id)
		word_to_id[word] = word_index
	#得到每一个单词对应的编号，就可以对句子进行编码
	#首先我们知道每一个句子对应的向量长度等于词表的大小
	#所以先初始化一个全0的向量

	onehot_result = []
	for i in range(len(sentences)):
		sentence = sentences[i]
		vector = [0 for i in range(len(word_to_id))]
		for j in range(len(sentence)):
			word = sentence[j]
			idx = word_to_id[word]
			vector[idx] += 1
		onehot_result.append(vector)

	return onehot_result

def run_step():
	sentences = readFile(filename='data/demo_train.txt')

	#遍历所有的句子，并打印编号和句子内容
	for i in range(len(sentences)):
		print("index: ", i, "sentence:", sentences[i])
	print("Read end..")
	print("Start split text..")

	sentences_splited, labels = split_text(sentences)

	#遍历所有的句子，并打印编号和句子内容
	for i in range(len(sentences_splited)):
		print("index=", i)
		print("sentence:", sentences_splited[i])
		print("label:",labels[i])
		print("====")

	print("Start transform sentence to one hot vector")
	onehot_vector = text_to_vector(sentences_splited)
	for i in range(len(onehot_vector)):
		print("index=", i)
		print("source_sentence", sentences_splited[i])
		print("one hot vector", onehot_vector[i])
		print("label:",labels[i])
		print("===")



if __name__ == '__main__':
	#开始执行步骤
	run_step()
