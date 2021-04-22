'有几个图形
'
Sub test1()
    Debug.Print Sheet1.Shapes.Count  '9
    'MsgBox Sheets(2).Type
End Sub


'==================================================
'查看图形属性
Sub test2()
    Dim shp As Shape
    
    For Each shp In Sheet1.Shapes
        i = i + 1
        '图片名字
        Range("a" & i) = shp.Name
        Debug.Print "图片名字: " & Range("a" & i)
        
        '图片所在单元格地址
        Range("b" & i) = shp.TopLeftCell.Address
        Debug.Print "图片所在单元格地: " & Range("b" & i)
        
        '类型就是数字
        Range("c" & i) = shp.Type
        Debug.Print "类型就是数字: " & Range("c" & i)
        Debug.Print " "
    Next
End Sub
'Output:
'图片名字: Picture 1
'图片所在单元格地: $B$13
'类型就是数字: 13
 
'图片名字: Rectangle 2
'图片所在单元格地: $E$13
'类型就是数字: 1
 
'图片名字: 圆角矩形 3
'图片所在单元格地: $H$13
'类型就是数字: 1
 
'图片名字: TextBox 4
'图片所在单元格地: $K$14
'类型就是数字: 17
 
'图片名字: Rectangle 6
'图片所在单元格地: $E$18
'类型就是数字: 1
 
'图片名字: Chart 7
'图片所在单元格地: $M$14
'类型就是数字: 3
 
'图片名字: Check Box 1
'图片所在单元格地: $B$25
'类型就是数字: 8
 
'图片名字: Diagram 8
'图片所在单元格地: $E$24
'类型就是数字: 24
 
'图片名字: CheckBox1
'图片所在单元格地: $B$29
'类型就是数字: 12


'==================================================
'类型它就是一个数字
'
Sub test3()

    Debug.Print Sheets(2).Type  '-4167
    
    'MsgBox Sheets(2).Type

End Sub


'==================================================
'删除图片
'
Sub test4()
    Dim shp As Shape
    
    For Each shp In Sheet1.Shapes
        'If shp.Type = msoPicture Then
        If shp.Type = 13 Then
            shp.Delete
        End If
    Next
End Sub
'Output:
'13
'1
'1
'17
'1
'3
'8
'24
'12