
'Sheets1.Select  对象.动作
'
'表的3种选法：
'
'
Sub test()

Sheet1.Select         '表1被选中
Sheets(1).Select      '第1张表被选中
Sheets("1月").Select  '1月这张表被选中

End Sub

###############################
'
'新增表 - count属性  name属性  属性用"="赋值
'
' Sheets.Add 新增表
'  - "空格"以后会给提供4个参数,给"参数"赋值用":="
'  - 两个参数之间用逗号","隔开
'
'             
Sub test1()

'count属性 在最后一张表后面新增一张表
'第二个Sheets.Count是新增表后的数量，它就是最后一张表
Sheets.Add after:=Sheets(Sheets.Count)
Sheets(Sheets.Count).Name = "新表"

End Sub


###############################
'
'新增100张表
'
'
Sub addSheets()
'建100张表，分别叫1,2,3,4.....
For i = 1 To 100
    '先计算有几张表，然后面后面插入表
    Sheets.Add after:=Sheets(Sheets.Count)
    Sheets(Sheets.Count).Name = i
Next

End Sub


###############################
'
'删除100张表
'
'注意：删表时注意位置
'
Sub delSheets()
 
    '关闭警告
    Excel.Application.DisplayAlerts = False
    
    For i = 1 To 100
      Sheets(1).Delete '永远删除表1
    Next
    
    Excel.Application.DisplayAlerts = True

End Sub


###############################
'
'复制表
'
'
Sub copySheets()

    Excel.Application.DisplayAlerts = False
    '新建一个工作簿，存放复制的工作表
    Sheets.Copy after:=Sheets(Sheets.Count)
    
    Excel.Application.DisplayAlerts = True

End Sub

###############################

'
'获取“表名”保存到单元格A列中
'
'
Sub getSheetName()
Dim i As Integer

For i = 2 To Sheets.Count
    Range("a" & i - 1) = Sheets(i).Name
Next

End Sub


###############################
'模板创建日报表
'
'代码逻辑：
'
'循环31次
'
'新建表       (在所有表后面)
'最后这张表。 名字 = 5月x日
'表的E5单元格 = 2016-5-x
'
'结束循环
'
'

Sub 日报表()

Dim i As Integer

For i = 1 To 31

Sheet1.Copy after:= Sheets(Sheets. Count)

Sheets(Sheets. Count). Name = "5月" & i & "日"

Sheets(Sheets. Count). Range("E5") = "2016-5-" & i

Next

End Sub

###############################
'
'多表汇总
'
'
'循环 2 到 sheets.count
'取值
'
'结束循环
'

Sub summary()

Dim i As Integer

For i = 2 To Sheets.Count
    Sheet1.Range("b" & i + 8) = Sheets(i).Range("e5")
    Sheet1.Range("c" & i + 8) = Sheets(i).Range("e6")
    Sheet1.Range("d" & i + 8) = Sheets(i).Range("e44")
Next

End Sub




