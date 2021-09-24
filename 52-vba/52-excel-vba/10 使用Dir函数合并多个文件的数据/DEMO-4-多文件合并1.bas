Sub 宏1()
'
'宏1 宏 录制宏将一张表复制到另一个工作薄中
'

'
    Windwos().Activate
    Sheets("北京").Select
    Sheets("北京").Copy After:=Workbooks("DEMO-4-多文件合并1.xlsx").Sheets(1)
    Applictaion.WindowState = xlMinimized
End Sub

#############################
'
'文件合并1
'
'
Sub wjhb()
Dim str As String
Dim wb As Workbook

str = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\*.*")

For i = 1 To 100

    Set wb = Workbooks.Open("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\" & str)
    
    '因为跨文件了，所以要写ThisWorkbook (就是“工程VBAProject”中的ThisWorkbook)
    wb.Sheets(1).Copy After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)          'wb.Sheets(1)文件中的第一张表
    ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count).Name = Split(wb.Name, ".")(0)     '给表名赋值，split以点做分割，取0段
    
    wb.Close
    str = Dir
    If str = "" Then
        Exit For
    End If
Next
End Sub
