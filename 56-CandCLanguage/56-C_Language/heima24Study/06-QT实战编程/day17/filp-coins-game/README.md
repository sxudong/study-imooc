## FilpCoins Game(翻金币游戏)

### 环境说明

> 编译环境：QT 5.12.6 MinGW 32-bit
>
> 开发环境：Qt Creator 4.10.2 (Community)
>
> 语言：C++

### 需求分析

1、三个场景：

+ 开始场景；

  + 开始按钮：点击后进入第二个场景；

+ 关卡选择场景；

  + 20个按钮：点击后进入第三个场景；第三个场景的硬币盘面不同；

+ 游戏场景；

  + 4*4的宫格，放置16个硬币，同时翻转上下左右4个硬币(如果有的话)，金币变成银币，银币变成金币；

  胜利条件：全部变成金币的时候游戏胜利，同时播放动画和音效；

2、窗口组件分析：

+ 窗口标题、icon
+ 窗口大小固定
+ 菜单栏-退出；

### 文件结构

> 以下描述顺序是按照文件名顺序，不是开发顺序；

+ `coinbutton.h`、`coinbutton.cpp`文件：

  关于游戏中翻转的硬币按钮的定义与实现；

+ `dataconfig.h`、`dataconfig.cpp`文件：

  游戏中关卡的设计文档；

+ `mymainwindows.h`、`mymainwindow.cpp`文件：

  自定义根窗口，本项目中的窗口都继承于此；

+ `mypushbutton.h`、`mypushbutton.cpp`文件：

  开始和回撤按钮在这里定义，共用接口；

+ `playscreen.h`、`playscreen.cpp`文件：

  游戏主界面；

+ `selectscreen.h`、`selectscreen.cpp`：

  选择关卡窗口；

+ `startscreen.h`、`startscreen.cpp`文件：

  开始游戏界面；

### 项目总结

> 以下描述作为QT初学者，在开发流程中清理的一些信息要点或者知识点；

+ `main.cpp`文件中对窗口的开启，可以通过直接显示的方式可以快速调试开发多窗口项目；

![image-20210517080205420](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517080205420.png)

+ 关于`.h`文件重复加载的问题；

  我在做这个案例的时候发现，在定义时会将头文件里需要的`.h`文件声明，在`.cpp`文件中也会将需要的`.h`文件声明;

  这里我就有一个担忧，就是我们需要在`IDE`环境中去依靠`IDE`提醒我们，需要添加依赖的时候再添加，如果没有`IDE`环境，我们就可能漏加或者重复加载；

  后来想起学C语言的时候，我们使用的`#ifndef`、`#define`、`#endif`；

截图以`startscreen.h`和`startscreen.cpp`文件的头文件为例；

![image-20210517082332610](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517082332610.png)

![image-20210517082401699](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517082401699.png)

+ 关于字符串填充，让我想起了C++11中的`Bind()`函数，同样是使用占位符绑定；

  ![image-20210517083123904](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517083123904.png)

+ 关于信号与槽

  目前我看到了两种形式：

  + 一种是声明式，格式为（信号发送者，触发行为，接收槽，响应行为）；

  ![image-20210517084443246](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517084443246.png)

  + 一种是响应信号(`函数`)使用`lambda`表达式给出；

  ![image-20210517084749350](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517084749350.png)

  总结一下，虽然我没看过实现源码，就我目前知识储备，我怀疑是使用观察者模式(设计模式)实现的该功能；

+ 关于动画

  在本例中存在三种主要动画；

  + 一种是开始菜单按钮的放大缩小动态，使用了定时器和改变按钮形态的函数来实现；

  ![image-20210517085639063](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517085639063.png)

  + 一种是硬币翻转，虽然还是使用了定时器，这里主要的体现是使用了一个整型`coinState`保存了状态帧，然后通过加载对应的图片来实现硬币翻转效果；

    这个操作我觉得值得学习，还是去看源码，注释的很清晰；

  ![image-20210517090042340](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517090042340.png)

  + 第三种就是胜利后下落的横幅，这里使用了属性动画，在检测是否赢`judgeWin`函数中，当判断赢了就会自动调用属性动画；

  ![image-20210517090639338](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517090639338.png)

  在这里还有一个运动曲线，可以通过帮助菜单查找`QEasingCurve`字段进行运动曲线函数的查询；

+ 关于内存泄漏问题；

  严格来讲，内存泄漏并不会发生在程序退出进程后，但在程序持续运行阶段，出现的这个问题就令人焦灼了;

  所以在调用新控件、窗口的时候，要记得在撤回的时候要删除或者说注销；

  比如说：

  + 当胜利的时候，进行横幅动画播放，结束了还要进行删除；

  ![image-20210517092929222](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517092929222.png)

  + 打开游戏窗口，在关闭游戏窗口的时候，需要进行窗口注销；

  ![image-20210517093044025](https://imagesubmit001.oss-cn-beijing.aliyuncs.com/gitImg/image-20210517093044025.png)



### 版本更迭

**V1.2**：

根据教程，实现翻金币游戏的主体功能；

**V2.0**：

游戏玩法的多元化，下一步计划……

