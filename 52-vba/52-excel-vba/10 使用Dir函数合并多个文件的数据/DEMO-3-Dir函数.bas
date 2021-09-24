Sub test1()
    Range("a1") = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\北京.xlsx")
End Sub

###################################
'
'判断是否有此文件
'
'
Sub test2()
Dim i As Integer


For i = 1 To 5
    
    'If Dir("d:\data\" & Range("a" & i) & ".xls*") = "" Then
    If Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\" & Range("a" & i) & ".xlsx") = "" Then
        Range("b" & i) = "无此文件"
    Else
        Range("b" & i) = "有文件"
    End If
    
Next

End Sub

###################################
'
'获得所有文件名
'
'
Sub getFileName()
Dim str As String

'str = Dir("d:\data\*.*")
str = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\*.*")

For i = 1 To 100

    Range("a" & i) = str
    str = Dir
    
    '如果等于空，退出循环
    If str = "" Then
        Exit For
    End If
Next

End Sub

###################################
'
'把所有文件都打一遍再关闭
'
'
Sub openFiles()
Dim str As String
Dim wb As Workbook

'str = Dir("d:\data\*.xls*")
str = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\*.xls*")

For i = 1 To 100

    'Set wb = Workbooks.Open("d:\data\" & str)
    Set wb = Workbooks.Open("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\" & str)
    

    '该干什么干什么
    
    
    wb.Close
    str = Dir
    
    If str = "" Then
        Exit For
    End If
Next

End Sub
