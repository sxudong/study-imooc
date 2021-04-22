'
'删除工作表
'
'
Sub delSheet()

Dim sht As Worksheet

Application.DisplayAlerts = False  '不弹出警告

For Each sht In Sheets

    If sht.Name <> "绝不能删" Then
        sht.Delete
    End If
    
Next

Application.DisplayAlerts = True


End Sub


'
'删除空隔
'
'
Sub delRange()

Dim rag As Range


For Each rag In Range("a1:a21")

    If rag = "" Then
        rag.EntireRow.Delete
    End If

Next

End Sub

'
'打开文件
'
'
Sub openFile()

Application.ScreenUpdating = False  '关闭屏幕更新
Application.DisplayAlerts = False   '关闭警告

Workbooks.Open Filename:="E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\04第四课 操作工作薄\完成版\1.xlsx"
ActiveWorkbook.Sheets(1).Range("a1") = "又1到此一游"
ActiveWorkbook.Save
ActiveWorkbook.Close

Application.DisplayAlerts = True   '打开警告
Application.ScreenUpdating = True  '打开屏幕更新


End Sub

'
'创建文件
'
'
Sub createFile()

Workbooks.Add
ActiveWorkbook.Sheets(1).Range("a1") = "哈哈这是我自动创建出来的"
ActiveWorkbook.SaveAs Filename:="E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\04第四课 操作工作薄\完成版\data\222.xlsx"
ActiveWorkbook.Close

End Sub

