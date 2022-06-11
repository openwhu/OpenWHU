# 过程设计中的图

通常来说画一个图基本就是将代码的形式通过图展示出来,只要掌握了图的画法我相信代码实现并不复杂

你可以在这里找到我[所有图的绘制源文件](https://www.yuque.com/books/share/7a36531d-5b56-4a7a-b04e-87630f62eb41?#)

## 流程图

流程图属于最常见的一种图了,它的画法我相信应该比较熟悉了,除了顺序结构和分支结构,这里需要注意的是while循环和util循环的写法

|顺序|选择|while|util|
|:--:|:--:|:--:|:--:|
|![20220609181712](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609181712.png)|![20220609181856](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609181856.png)|![20220609181918](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609181918.png)|![20220609181930](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609181930.png)|

> while和util的区别就是何时跳出循环,你可以将util理解成do-while

还有一个不常用的case判断

![20220609182101](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609182101.png)

**例: 求N个元素中的最大值。试画出流程图**

![20220609183125](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609183125.png)

## 盒图(N_S图)

|顺序|选择|while|util|
|:--:|:--:|:--:|:--:|
|![20220609183328](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609183328.png)|![20220609183348](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609183348.png)|![20220609183406](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609183406.png)|![20220609183419](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609183419.png)|

这里的while和util的图形之间的位置不相同

如果某一个分支选择并没有内容那么使用箭头直接指下

![20220609201826](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609201826.png)

如果在流程的内部有函数调用那么画一个圈

![20220609202335](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609202335.png)

一些盒图的例子

![20220609202355](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609202355.png)

对于之前的**例: 求N个元素中的最大值。试画出流程图**

> 可以看到盒图还是要麻烦不少的,如果是更复杂的逻辑那么使用盒图来表示其实是很不方便的

![20220609202408](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609202408.png)

## PAD图

![20220609202538](https://raw.githubusercontent.com/learner-lu/picbed/master/20220609202538.png)

这一部分基本不会用到,了解即可

## 判定图和判定表

这一部分基本不会用到,略了

---

如果确实需要这部分的画法还是建议去搜索一下相关的博客,老师的[PDF](https://github.com/luzhixing12345/WHU-software-engineering/releases/download/v0.0.1/progress-design.pdf)讲的我觉得也不错,看看图看看表示基本就知道怎么画了
