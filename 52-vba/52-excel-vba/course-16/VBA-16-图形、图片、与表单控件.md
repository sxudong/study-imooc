# 16 第十六课 触类旁通 ：图形 图片 与表单控件
## 1）关于Shapes大家族

Shapes代表工作表上的所有形状。

## 2）图形对象常用属性Shape

```vb
  Set shp = Sheet1.shapes
    Shp.count  '数量
    Shp.Type   '类型
    Shp.Name   '名字
    Shp.TopLeftCell.Address 'cell地址
    Shp.Top
    Shp.Left
    Shp.Height
    Shp.Width
    Shp.Visible
```

## 3）图片对象常用方法和属性Picture

Sheet1.Shapes.AddPicture  // 善用帮助(按F1)
AddPicture(文件名，链接，SaveWithDocument，左侧，顶部，宽度，高度)

参数：
	Filename  文件名
	LinkToFile 链接
	SaveWithDocument 将图片与文档一起保存
	Left  左侧
	Top  顶部
	Width  宽度
	Height 高度

  示例：

```vb
  Set shp = Sheet1.Shapes.AddPicture(
     "d:\data\汪梅.jpg", 
      msoFalse, 
      msoCTrue, 
      Range("d2").Left, 
      Range("d2").Top, 
      Range("d2").Width, 
      Range("d2").Height )
```

shp.Placement = xlMoveAndSize '大小随单元格变

## 4）为外部图片重命名

 重命名磁盘文件、目录或文件夹。
 语法：Name 旧路径名称 As 新路径名称
 重点：使用VBA帮助文件
 示例：DEMO-3-改文件名.xlsm

## 5）操作插入图表

```vb
Set shp = Sheet4.Shapes.AddChart          ' 插入图表
    shp.Chart.SetSourceData               ' 设置数据源
    shp.Chart.ChartType                   ' 设置轴线
    shp.Chart.Axes(xlValue).MinimumScale  ' 最小精度
```

示例：DEMO-4-图表对象（靠录制）.xlsm



## 6）隐藏表单控件的“分组框”

示例：DEMO-5-完成自动生成调查问卷程序.xlsm

## 7）使用Like语句

  *               任意字符
  #              任意数字
  ？             一位字符
  ！             逻辑非
  [A-Z]        大写字母
  [A-Za-z]   字母
  [0-9]         数字
  [!A-Z]       非大写字母
  [!0-9]        非数字

## 需要理解并记住写法的概念
  Shapes
  Name …as…
  Like

## 需要理解的概念
  Shapes中包含哪些对象
  如何使用VBA帮助文件
  基本的VBA语法

