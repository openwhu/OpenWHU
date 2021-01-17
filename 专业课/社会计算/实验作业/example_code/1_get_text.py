

def readFile(filename):

	#读文件， filename是文件名，‘r’表示读，encoding='utf-8'表示以‘utf-8’打开文件
	#返回结果是一个类似字符串，即整篇文章可以当一个str处理
	content = open(filename, 'r', encoding='utf-8').read()

	#切分，按照换行符‘\n’切分成一句一句的
	#结果是一个list， 每一句里面都是一个str对象
	sentences = content.split('\n')


	return sentences


def run_step():
	sentences = readFile(filename='data/demo_train.txt')

	#遍历所有的句子，并打印编号和句子内容
	for i in range(len(sentences)):
		print(i, sentences[i])


if __name__ == '__main__':
	#开始执行步骤
	run_step()
