
'不重名就建，重名就不建
'
Sub test1()
    Dim sht, sht1 As Worksheet
    
    '有没有重名的表
    For Each sht In Sheets
        If sht.Name = "一月" Then
            k = k + 1
        End If
    Next
    
    '如果没有重名，新建表
    If k = 0 Then
        Set sht1 = Sheets.Add
        sht1.Name = "一月"
    End If

End Sub


'==================================================
' 新建表
'
Sub Sadd(str As String)
    Dim sht, sht1 As Worksheet
    
    For Each sht In Sheets
        If sht.Name = str Then
            k = k + 1
        End If
    Next
    
    If k = 0 Then
        Set sht1 = Sheets.Add
        sht1.Name = str
    End If
End Sub


'==================================================
Sub test2()
    Call test2("二月") '传参
End Sub


'==================================================
'删除表
'
Sub Sdelete(str As String)
    Dim sht As Worksheet
    
    For Each sht In Sheets
        If sht.Name = str Then
            Application.DisplayAlerts = False
            sht.Delete
            Application.DisplayAlerts = True
        End If
    Next
End Sub


'==================================================
Sub test3()
    Call Sdelete("二月")
End Sub


'==================================================
Sub test4()
    Dim aaa As New SuperSheets
    aaa.Add  '不带参的新增表
End Sub


'==================================================
Sub test5()
    Range("a1") = Sheets.Count  '只读属性
    Sheet1.Name = 999  '写入属性
End Sub


'==================================================
Function Scount()
    Scount = Sheets.Count  '只读属性
End Function


'==================================================
Sub test6()
    Range("a2") = Scount()  '调用函数，返回属性值
End Sub


'==================================================
'测试调用 类模块 方法
Sub test7()
    Dim aaa As New SuperSheets
    MsgBox aaa.Scount
    
    aaa.Sadd "八月"
End Sub


'==================================================
'测试 类模块 删除行
Sub test8()
    Dim bbb As New SuperRange
    For i = 1 To 25
        bbb.Rdelete Range("c" & i)
    Next
End Sub