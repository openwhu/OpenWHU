# 状态图

## 什么是状态图

状态转换图英文全称State transition diagram,缩写STD,简称状态图。通过描绘系统的状态及引起系统状态的事件,来表示系统的行为.

它属于事件驱动模型,表示系统对外部事件的响应方式,能清晰的描述系统状态之间的转换顺序和状态之间的关系,在节省大量文字描述的情况下帮助工程师更好的理解需求和讨论设计思路,避免开发时出现状态转换逻辑错误,并且系统实现后还要用状态模型来论证系统的结构和操作。状态图还明确的定义了状态发生转换时必要的触发事件和影响状态转换的关键因素,有利于在开发过程中避免非法事件的进入。通过绘制状态图,还可以帮助我们检测系统设计中是否存在缺陷。状态图既可以表示系统循环运行过程,也可以表示系统单程生命期。

> 状态图有点类似数电/编译原理的DFA,用于表示由于信号导致的状态变化

状态图的基本符号

![1798247-20210329233628304-998019882](https://raw.githubusercontent.com/learner-lu/picbed/master/1798247-20210329233628304-998019882.png)

- 初态用实心圆表示,终态用同心圆表示(內圆为实心圆)
- 中间状态用圆角矩形表示
- 中间态的状态变量和活动都是可选的

一个比较常见的状态图的流程如下所示,从初态出发,经过迁移,依次经过两个状态,最后到达终态

![v2-3ecd95de43bedcb50bff62abea1979c0_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-3ecd95de43bedcb50bff62abea1979c0_720w.jpg)

你可以观察到中间状态的活动表里有三种模式:

- entry: 事件指定进入该状态的动作
- do: 事件则指定在该状态下的动作
- exit: 事件指定退出该状态的动作

> entry,exit有点类似于c++的class的构造函数和析构函数,do就是内部定义的函数
>
> 状态变量这个,emmm一般来说用不到

箭头代表触发的事件,由一个状态转移到另一个状态

## 怎么画状态图

举一个智能洗衣机的例子,它具备：

- 一个用来显示按钮和设备设置的触控屏
- 一个用来选择洗涤模式的按钮,可以选择强力洗涤和超快洗涤两种方式
- 一个用来设置水量的数字键盘
- 一个能控制开始/停止的按钮

  - 具备安全锁功能,在没关闭洗衣机仓门时洗衣机不会工作
  - 工作中打开盖子洗衣机会暂停工作
  - 工作完成后洗衣机会发出提示音提示用户来取衣物

假设该智能洗衣机的操作步骤如下：

- 选择洗涤模式,强力洗涤或超快洗涤
- 用数字键盘设置本次洗涤所需水量
- 点击开始按钮,使用相应洗涤模式和水量开始洗涤

### 步骤1：列出产品/系统的所有状态

根据题目的描述,我们可以构造一个初始的待机状态,强力洗涤和超快洗涤两种方式两个状态,设置水量的一个状态,就绪/异常/工作三个状态

![v2-b68894f6f9a212d0acba40a2779e8349_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-b68894f6f9a212d0acba40a2779e8349_720w.jpg)

### 步骤2：列出每个状态须执行的动作

![v2-4d6ab9f9d99c0f655d9ce77f7c70da7a_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-4d6ab9f9d99c0f655d9ce77f7c70da7a_720w.jpg)

这里值得一提的是,语雀画板的状态只有一个框,我们可以将两个框并到一起,一起选中然后右键添加到素材库,这样就可以使用了

![20220607225123](https://raw.githubusercontent.com/learner-lu/picbed/master/20220607225123.png)

### 步骤3：确认并绘制出引起状态发生转换的事件

> 这里作者构建了一个状态表,我个人感觉可以用,但是有点麻烦,直接画或许更加直观

![v2-c4178d5e5ab34eba179e7316deae18ad_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-c4178d5e5ab34eba179e7316deae18ad_720w.jpg)

![v2-018930acf1b7c90db86fa29e25532307_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-018930acf1b7c90db86fa29e25532307_720w.jpg)

### 步骤4：标注初态和终态并细化状态图

对于终态来说,有可能不存在,有可能存在多个终态.

比如说一个电梯系统,正常情况下他就不存在终止/结束这种状态,或者是一个系统,他也不应该在一次完整的流程之后结束,而是应该回到初态/待机状态

如果是题目中这种洗衣机的情况,我们可以认为经过一次洗衣流程之后结束

![v2-85b9f783499c658917aea360ffcf8e8f_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-85b9f783499c658917aea360ffcf8e8f_720w.jpg)

当然可以说是再次回到初态(一个箭头指回去).

值得一提的是,并不是说一个一直在运行的系统就不存在终态,有可能因为某些异常情况导致出现终态,或者主动退出系统进入终态

最后的状态描述我们可以使用一个表格把状态和相应的事件都列举出来

|![v2-8530b2acf8e1c1192c669a632ebab334_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-8530b2acf8e1c1192c669a632ebab334_720w.jpg)|![v2-66b857ef6925186243cf3b73880341f1_720w](https://raw.githubusercontent.com/learner-lu/picbed/master/v2-66b857ef6925186243cf3b73880341f1_720w.jpg)|
|:--:|:--:|

如果你觉得这种方式太麻烦了,你可以使用一段文字,比较详细的描述你的整个过程,例如在状态A如果遇到事件T那么进入状态B,然后把该状态的活动行为也描述一下

## 另一个例子

你可以浏览一下期中考试的试题,其中提到了状态图的绘制

> 这是我室友的

![20220607233549](https://raw.githubusercontent.com/learner-lu/picbed/master/20220607233549.png)

大概就是一个状态的名字,接着它内部的活动(简单的语言描述)

---

参考

https://www.cxymm.net/article/budding0828/86556936

https://blog.csdn.net/budding0828/article/details/86556936

https://www.zhihu.com/question/27669588/answer/552638287