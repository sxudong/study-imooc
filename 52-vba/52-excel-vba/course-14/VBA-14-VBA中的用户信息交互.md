# 14 第十四课 VBA中的用户信息交换
## 1）VBA.Interaction.MsgBox函数

 参数：Msgbox(提示文字，按钮类型，标题文字，帮助文件，帮助文件索引)

 示例：MsgBox "你还好吗？", 4 + 32, "打招呼对话框", "C:/a.chm", 0

显示样式：可使用加号连接

| 常数                  | 值      | 描述                                                         |
| --------------------- | ------- | ------------------------------------------------------------ |
| vbOKOnly              | 0       | 只显示 确定 按钮                                             |
| VbOKCancel            | 1       | 显示 确定 及 取消 按钮。                                     |
| VbAbortRetryIgnore    | 2       | 显示 放弃、重试 及 忽略 按钮。                               |
| VbYesNoCancel         | 3       | 显示 是、否 及 取消 按钮。                                   |
| VbYesNo               | 4       | 显示 是 及 否 按钮。                                         |
| VbRetryCancel         | 5       | 显示 重试 及 取消 按钮。                                     |
| VbCritical            | 16      | 危险图标                                                     |
| VbQuestion            | 32      | 询问图标                                                     |
| VbExclamation         | 48      | 警告图示                                                     |
| VbInformation         | 64      | 信息图标                                                     |
| vbDefaultButton1      | 0       | 第一个按钮是缺省值。                                         |
| vbDefaultButton2      | 256     | 第二个按钮是缺省值。                                         |
| vbDefaultButton3      | 512     | 第三个按钮是缺省值。                                         |
| vbDefaultButton4      | 768     | 第四个按钮是缺省值。                                         |
| vbApplicationModal    | 0       | 应用程序强制返回；应用程序一直被挂起，直到用户对消息框作出响应才继续工作。 |
| vbSystemModal         | 4096    | 系统强制返回；全部应用程序都被挂起，直到用户对消息框作出响应才继续工作。 |
| vbMsgBoxHelpButton    | 16384   | 将Help按钮添加到消息框                                       |
| VbMsgBoxSetForeground | 65536   | 指定消息框窗口作为前景窗口,就是显示在窗口的最上层            |
| vbMsgBoxRight         | 524288  | 文本为右对齐                                                 |
| vbMsgBoxRtlReading    | 1048576 | 指定文本应为在希伯来和阿拉伯语系统中的从右到左显示           |

返回值

| 常数     | 值   | 说明 |
| -------- | ---- | ---- |
| vbOK     | 1    | 确定 |
| vbCancel | 2    | 取消 |
| vbAbort  | 3    | 终止 |
| vbRetry  | 4    | 重试 |
| vbIgnore | 5    | 忽略 |
| vbYes    | 6    | 是   |
| vbNo     | 7    | 否   |



## 2）VBA.Interaction.InputBox函数

 参数：Inputbox(提示文字，标题文字，默认值，左边距，上边距，帮助文件，帮助文件索引)

 示例：
 Dim name As String
 name = InputBox("请输入姓名", "登陆框", "此处输入", 100, 100, "C:/a.chm", 0)

## 3）Application.InputBox方法

 参数：
 Inputbox(提示文字，标题文字，默认值，左边距，上边距，帮助文件，帮助文件索引，输入类型)

 VBA里有两个InputBox，还有一个是Application.InputBox。
          
 示例：
 Dim i As Integer
 i = Application.InputBox("输入金额", "汇率计算", "此处输入", 100, 100, "C:/a.chm", 0, 1)

 如果输入的类型不对，会提示，InputBox函数没有这个功能。

 Inputbox方法的类型值
 类型值可使用加号连接

| 值   | 含义                            |
| ---- | ------------------------------- |
| 0    | 公式                            |
| 1    | 数字                            |
| 2    | 文本 (字符串)                   |
| 4    | 逻辑值 (True 或 False)          |
| 8    | 单元格引用，作为一个 Range 对象 |
| 16   | 错误值，如 #N/A                 |
| 64   | 数值数组                        |

## 4）文件选择对话框 Application.GetOpenFilename

 参数：
 GetOpenFilename (文件类型，优先类型，对话框标题，按钮文字，是否支持多选)

 示例：DEMO-3-GetOpenFileName.xlsm
 A= Application.GetOpenFilename("新表,*.xlsx,老表,*.xls", 1, "快特么选！", "确定", False)

 注意：
 这个方法并不会真正打开文件，只是返回文件完整路径！
 文件类型参数中，先指定文件类型名，再指定后缀，要成对出现。
 优先类型是指文件类型中列出的各种类型，哪种优先显示。
 例如："Excel文件,*.xlsx,老表,*.xls,所有文件,*.*"

 第10讲用到Dir("E/data/*.xlsx") 通过指定目录批量打开。



## 5）操作Excel中的所有对话框 Application.Dialogs

参数：Dialogs(对话框)

示例：Application.Dialogs(xlDialogSaveAs).Show
          Application.Dialogs(5).Show '“另存为”对话框



## 6）使用加载宏工具

 1 你要有宏：另存为加载宏文件
 2 让他默默跟随Excel：勾选加载项
 3 让他出来被看见：Excel界面上设置按钮

 注意，用于制作加载宏的文件不能在代码里有ThisWorkbook。
这段代码如果制作成加载宏，不能用！哪里不一样呢？这里有一个关键指标放在加载宏里不能用,如果这个文件我另存为".xla"文件放在加载宏里，如果打开一个文件执行，它就会跑到另一个表里往这个表里执行操作。对于".xla"文件它只是一个第3者，它只是一个旁观者，对于".xla"来讲，它是对两个文件做操作，一个是目标文件，一个是源文件，把源文件拷到目标文件中。
如果在代码里提到"ThisWorkbook"写代码的这个表，谁是写代码的这个表？实际上是说".xla"才是写代码的这个表。