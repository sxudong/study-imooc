Sub test()
    Dim arr()
    Dim dic As New Dictionary
    
    arr = Range("a2:e5")
    
    Range("a10") = arr(2, 2)

End Sub


'==================================================
Sub test2()
    Dim dic As New Dictionary '定义字典
    
    '这个相当于Java中的 Map
    dic.Add "张三", 3000
    dic.Add "李四", 2000
    
    Range("a10") = dic("李四")
    
    '改值
    dic("李四") = 8000
    Range("a10") = dic("李四")

End Sub


'==================================================
'不推荐使用Add方式给字典添加赋值，相同的 key 会报错
Sub test3()
    Dim dic As New Dictionary '定义字典
    
    For i = 2 To 4
        '使用Add添加，相同的 key 会报错
        dic.Add Range("d" & i).Value, Range("e" & i).Value
    Next
    
    Range("a10") = dic("李四")

End Sub


'==================================================
Sub test4()
    Dim dic As New Dictionary '定义字典
    
    '这个相当于Java中的 Map
    dic.Add "张三", 3000
    dic.Add "李四", 2000
    dic.Add "李四", 8000 '修改覆盖

Range("a10") = dic("李四")

End Sub


'==================================================
'这种方式给字典赋值，相同的key值不会覆盖也不会报错
Sub test5()

    Dim dic As New Dictionary
    
    arr = Range("a2:b13")
    
    For i = 2 To 5
        dic(Range("d" & i).Value) = Range("e" & i).Value
    Next
    
    Range("a15:d15") = dic.Keys

End Sub


'==================================================
Sub test6()
    Dim arr()
    
    Dim dic As New Dictionary '定义字典
    
    arr = Range("a2:e5") '区域赋值给数据
    
    
    For i = LBound(arr) To UBound(arr)
        dic(arr(i, 1)) = arr(i, 2)
    Next
    
    Range("a15:d15") = dic.Keys
    
    Range("a16") = dic(1)
    Range("a17") = dic(2)
    Range("a18") = dic(3)

End Sub


'==================================================
Sub test7()
    Dim arr()
    
    Dim dic As New Dictionary '定义字典
    
    arr = Range("a2:b13") '区域赋值给数据
    
    For i = LBound(arr) To UBound(arr) '2循环到13
        dic(arr(i, 2)) = 1             '筛选B列“类别”，等于几无所谓，只要这个key
    Next
    
    Sheet2.ListBox1.List = dic.Keys  '把keys赋值给ListBox1数据源，做下拉列表

End Sub