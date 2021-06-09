### 1 QMainWindow

#### 1.1 菜单栏 QMenuBar * bar = MenuBar()  只能最多有一个

- 1.1.1 把这个栏添加到 窗口中 setMenuBar

- 1.1.2 添加菜单 addMenu（文件）
- 1.1.3 文件里添加菜单项 addAction（新建） 返回QAction
- 1.1.4 添加分隔符 addSeparator

#### 1.2 工具栏 可以有多个

- 1.2.1 tBar =  new QToolBar
- 1.2.2 addToolBar（ 默认停靠位置，tBar）
- 1.2.3 设置 停靠、浮动、移动
- 1.2.4  添加菜单项

#### 1.3 状态栏 statusBar  只能一个

- 1.3.1 左侧添加 
- 1.3.2 右侧添加

#### 1.4 铆接部件 可以多个

- 1.4.1 QDockWidget
- 1.4.2 addDockWidget（默认位置，。。）
- 1.4.3 设置后期的停靠位置

#### 1.5 核心部件  只能一个

- 1.5.1 setCentralWidget

#### 2 添加资源文件

- 2.1 首先将资源导入到项目中
- 2.2 右键项目 -  添加新文件 – Qt  - Qt Resource File 
- 2.3 给资源起名称 res
- 2.4 Qt会生成res.qrc 文件
- 2.5 右键res.qrc  open in Editor
- 2.6 添加前缀 
- 2.7 添加文件
- 2.8  使用 “ : + 前缀名 + 文件名 ”
- 2.9 可以设置别名，但是不建议，因为设置别名，原来的方式就不可用了

#### 3 对话框

- 3.1 模态对话框

  - 3.1.1 Dialog dlg

  - 3.1.2 dlg.exec() 阻塞功能

- 3.2 非模态对话框

  - 3.2.1 Dialog dlg

  - 3.2.2 dlg.show() 会一闪而过 所以创建在堆上

  - 3.2.3 new dlg dlg->show()

  - 3.2.4 设置属性 55号 setAttribute（Qt::WA_DeleteOnClose）

#### 4 QMessageBox

- 4.1 错误、信息、警告、问题
- 4.2 问题 5个参数
  - 4.2.11 父亲 2 标题 3 显示内容 4 按键类型 5 默认关联回车按键

#### 5 QFileDialog  

- 5.1 getOpenFileName（父亲，标题，默认路径，过滤文件格式）
- 5.2 返回值是文件路径

#### 6  QColorDialog 

- 6.1 getColor（ 默认色 QColor(r,g,b)）
- 6.2 返回值 QColor 

#### 7 界面布局

- 7.1 登陆窗口
- 7.2 水平布局 和 垂直布局
- 7.3 默认widget和控件之间有9像素的间隙
- 7.4 灵活运用弹簧

#### 8 控件

- 8.1 按钮组

  - 8.1.1 QPushButton 可以加Icon

  - 8.1.2 QToolButton 主要显示Icon，想显示图片和文字 ，修改属性toolButtonStyle
    - 8.1.2.1 自带效果 透明效果 autoRaise

  - 8.1.3 QRadioButton

    - 8.1.3.1 setChecked 设置默认选中

    - 8.1.3.2 监听clicked信号

  - 8.1.4 QCheckButton
    - 8.1.4.1 statusChanged 状态改变 0 未选中 1 半选 2 全选

- 8.2 ListWidget

  - 8.2.1 QListWidgetItem * item = new … (“诗词”)

  - 8.2.2 ui->listWidget->addItem(item);

  - 8.2.3 设置对齐方式 item->setTextAlignment(Qt::AlignHCenter);

  - 8.2.4 addItems( QStringlist)

- 8.3 TreeWidget

  - 8.3.1 设置头

  - 8.3.2 ui->treeWidget->setHeaderLabels(QStringList() << "英雄"<<"英雄介绍");
    - 8.3.2.1    设置具体内容

  - 8.3.3 创建顶层的item

    - 8.3.3.1 QTreeWidgetItem * liItem = new …

    - 8.3.3.2 ui->treeWidget->addTopLevelItem(liItem);

  - 8.3.4     设置子节点
    - 8.3.4.1 addChild()

- 8.4 TableWidget

  - 8.4.1 设置列数

  - 8.4.2 设置头 姓名 性别 年龄

  - 8.4.3 设置行数

  - 8.4.4  设置正文  setItem（row,col,QTableWidgetItem）

  - 8.4.5 添加赵云

    - 8.4.5.1 判断是否为空

    - 8.4.5.2 为空 添加 insertRow

  - 8.4.6 删除赵云

    - 8.4.6.1 判断是否为空

    - 8.4.6.2 先确定赵云所在的row

    - 8.4.6.3 removeRow

- 8.5 其他常用控件

  - 8.5.1 stackedwidget 栈容器
    - 8.5.1.1 设置所以 setCurrentIndex

  - 8.5.2 下拉框
    - 8.5.2.1 addItem添加项目

  - 8.5.3 利用QLabel显示图片
    - 8.5.3.1 setPixmap(QPixmap(“文件路径”))

  - 8.5.4  利用QLabel显示gif图片

    - 8.5.4.1 QMovie * movie = new QMovie(":/Image/mario.gif");

    - 8.5.4.2  ui->label_gif->setMovie(movie);

    - 8.5.4.3  movie->start();