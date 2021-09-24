# 08 第八课 在VBA中使用公式

## 1）以前熟悉的那些函数在哪？使用工作表函数

- CountA()函数
     统计区域内包含文本和逻辑值的单元格个数。统计非空单元格的个数。
     Application.WorksheetFunction.CountA(range)
     另外：Count()函数是一个Excel函数，只能统计数字的个数，其它格式的忽略不统计。

- CountIf()函数
     在指定区域中按指定条件对单元格进行计数（单条件计数）
     Application.WorksheetFunction.CountIf(range，criteria)

-  Vlookup()函数
     Application.WorksheetFunction.Vlookup(查找目标, 查找范围, 在查找范围中要返回值所在的列数, 精确or模糊查找)
     精确查找：0     模糊查找：1

## 2）错误回避，当发生错误时继续执行下一行代码

On Error Resume Next

## 3）使用VBA函数

```vb
     VBA.Strings         文本函数
            .Math        数学函数
            .Datetime    日期时间
            .FileSystem  文件信息
            .Financial   财务函数
            .Information 信息函数
            .Interaction 交互函数     
```

## 4）VBA.Information.IsNumeric()函数

判断一个值是不是数字？返回false或true。

## 5）val()函数

val(value)函数 把一个文本转换为数字。

## 6）VBA.Strings.InStr()函数

指定一个字符串在另一个字符串中首次出现的位置，返回一个Long值。

 示例：查找"@"的位置
 InStr(Sheet1.Range("a2"), "@")  ' zhangsan@163.com 返回9

## 7）Left()函数

 可从字符串的左侧返回指定数目的字符，也就是截取指定位置的字符。
 语法：Left(string, length)

 示例：zhangsan@163.com 从左到右截取8个字符串。
 Range("b2") = Left(Range("a2"),  8) ' zhangsan

## 8）VBA.Strings.Split()函数

 示例：按“-”分开，取第2段
    Dim strString As String
    strString = "PW-023-2015-37-001"
    strString = Split(strString, "-")(2)
    Debug.Print strString  '2015

 Split 函数可返回基于 0 的一维数组，此数组包含指定数目的子字符串。
 语法：Split(expression[,delimiter[,count[,compare]]])

 expression  必需的。包含子字符串和分隔符的字符串表达式。
 delimiter      可选的。用于识别子字符串界限的字符。默认是空格字符。
 count           可选的。需被返回的子字符串的数目。-1 指示返回所有的子字符串。
 compare      可选的。规定要使用的字符串比较类型。0执行二进制比较。1执行文本比较。

## 9）附表：常用VBA变量类型

| 类型     | 存储空间                 | 范围                                                      |
| -------- | ------------------------ | --------------------------------------------------------- |
| Boolean  | 2 bytes                  | True 或者 False                                           |
| Byte     | 1 byte                   | 0 ~ 255                                                   |
| Integer  | 2 bytes                  | -32768 ~ 32768                                            |
| Long     | 4 bytes                  | -2147483648 ~ 2147483647                                  |
| LongLong | 8 bytes                  | -2147483648 ~ 2147483647                                  |
| String   | 10 bytes + string length | 0 ~ 20 亿个字符                                           |
| Object   | 4 bytes                  | 可以赋值给任何对象引用                                    |
| Single   | 4 bytes                  | -3.402823E38 ~ -1.401298E-45 (对负值)                     |
|          |                          | 1.401298E-45 ~ 3.402823E38 (对正值)                       |
| Double   | 8 bytes                  | -1.79769313486231E308 ~ -4.94065645841247E-324 (对负值)   |
|          |                          | 4.94065645841247E-324 ~ 1.79769313486231E308 (对负值)     |
| Date     | 8 bytes                  | 100 年 1 月 1 日 ~ 9999 年 12 月 31 日 0:00:00 ~ 23:59:59 |
| Variant  | 16 bytes                 | 任意值, 性能较低                                          |

