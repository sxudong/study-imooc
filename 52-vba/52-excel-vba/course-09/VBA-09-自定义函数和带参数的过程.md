# 09 第九课 自定义函数和带参过程
## 1）创建自定义函数Function

```vb
 '转美金
 Function ConvertToDollar(x)
     ConvertToDollar = x / 6.03 - x * 0.03
 End Function

 '还可以在Sub过程中调用函数：
 Sub abc()
     Range("L2") = ConvertToDollar(Range("K2"))
 End Sub
```

## 2）创建带参数的过程Sub

DEMO-4-创建带参数的过程

## 3）让代码可以在所有文件中运行-使用加载宏工具

- STEP1 把代码放在“代码库”里
    新建一个xlsx代码库文件，把代码放进来，选择“*.xla”的格式另存，office软件会默认选择路径，不要修改默认路径。

- STEP2 告诉Excel每次打开文件都加载
    开发工具 -> 加载项 -> 选择保存的代码库加载
- STEP3 在Excel右上角快速访问工具栏，设置宏按钮。
    关掉所有的excel文档，新一个文档打开
    文件 -> 选项 -> 快速访问工具栏  -> 从下列位置选择命令 -> 宏 ->添加

## 4）加载宏 -> 加载函数

跟上面一样，少了第3步函数不需要设置按钮。

## 5）删除加载的宏

  在“加载项”中把勾去掉后，到文件路径下删除加载的文件：
  C:\Users\Arron\AppData\Roaming\Microsoft\AddIns