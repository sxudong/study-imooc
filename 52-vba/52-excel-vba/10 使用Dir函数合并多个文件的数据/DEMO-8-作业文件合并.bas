'文件合并
Sub wjhb()
Dim str As String
Dim wb As Workbook
Dim i, j As Integer   'i用来计算数据源的表有多少行  j用来计算汇总表目前有多少行数据，例如有10行，就从11行开始复制数据

'str = Dir("d:\data\*.xls*")
str = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\*.xls*")

For i = 1 To 100
    'Set wb = Workbooks.Open("d:\data\" & str)
    Set wb = Workbooks.Open("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data\" & str)
'上面是壳子###################################################################
    
    i = wb.Sheets(1).Range("a65535").End(xlUp).Row                   '数据源A列最后一个单元格数
    j = ThisWorkbook.Sheets("数据").Range("a65535").End(xlUp).Row    '本表中A列最后一个单元格数
    
    wb.Sheets(1).Range("a2:g" & i).Copy ThisWorkbook.Sheets("数据").Range("a" & j + 1)        '数据源的数据复制到汇总表里面
    ThisWorkbook.Sheets("数据").Range("h" & j + 1).Resize(i - 1, 1) = Split(wb.Name, ".")(0)  '从汇总表复制数据那一行开始，用resize往下选i-1行，里面全写上城市名
    
    
'下面是壳子###################################################################
    wb.Close
    str = Dir
    If str = "" Then
        Exit For
    End If
Next
End Sub
