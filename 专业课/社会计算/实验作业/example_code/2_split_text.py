import jieba


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


if __name__ == '__main__':
	#开始执行步骤
	run_step()
