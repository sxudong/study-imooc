# 04 第四课 操作工作薄

## 1）For Each循环语法

```vb
 For Each 变量 In 集合或者数据名称
    ......
 Next
```

## 2）Workbooks 工作簿对象操作方法：“打开”、“保存”、“另存为”、“关闭”、“新建”、"当前活动的工作薄"

 Workbooks.Open Filename:="d:\data\1.xlsx"
 .Save   .Save As  .Close   .Add   .ActivateWorkbook 

DEMO-2-删除工作表 

DEMO-5 Del&Create&Open Sheets

## 3）使用Dim声明一张表

Dim sht As Worksheet

DEMO-1-取表名

