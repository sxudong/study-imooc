Sub 宏1()
'
' 手动录制宏1 宏
'
'Selection.Placement = xlMoveAndSize(大小和位置随单元格而变)
'Selection.Placement = xlMove (大小固定，位置随单元格而变)
'Selection.Placement = xlFreeFloating(大小和位置固定)
'
    ActiveSheet.Shapes.Range(Array("Picture 28")).Select
    Selection.Placement = xlFreeFloating
End Sub


Sub 宏2()
'
' 手动录制宏2 宏
'

'
    ActiveSheet.Shapes.Range(Array("Picture 35")).Select
    Selection.Placement = xlMoveAndSize
End Sub

'==================================================

'Shapes.AddPicture 方法
'
'表达式: AddPicture(文件名，链接，SaveWithDocument，左侧，顶部，宽度，高度)
'
'(1)Filename 必需 String 要在其中创建OLE对象的文件
'
'(2)LinkToFile 必需 MsoTriSate 要链接至的文件。
'
'(3)SaveWithDocument 必需 MsoTriSate 将图片与文档一起保存
'
'(4)Left 必需 Single 图片左上角相对于文档左上角的位置（以磅为单位）
'
'(5)Top 必需 Single 图片左上角相对于文档顶部的位置（以磅为单位）
'
'(6)Width 必需 Single 图片的宽度（以磅为单位）
'
'(7)Height 必需 Single 图片的高度（以磅为单位）
'
Sub test1()

    '插入图片
    Set shp = Sheet1.Shapes.AddPicture("d:\data\汪梅.jpg", msoFalse, msoCTrue, Range("d2").Left, Range("d2").Top, Range("d2").Width, Range("d2").Height)

End Sub


'==================================================
'批量插入图片
Sub test()
    On Error Resume Next
    Dim shp, shp1 As Shape
    
    '加图片前，删除表中所以图片
    For Each shp1 In Sheet4.Shapes
        shp1.Delete
    Next
    
    '根据A列姓名，批量插入图片
    For i = 2 To 12
        Set shp = Sheet4.Shapes.AddPicture("d:\data\" & Range("a" & i) & ".jpg", msoFalse, msoCTrue, Range("d" & i).Left, Range("d" & i).Top, Range("d" & i).Width, Range("d" & i).Height)
        '大小随单元格变（这段代码是宏录制的）
        shp.Placement = xlMoveAndSize
    Next
End Sub