'定义一维数组并赋值
Sub test()
Dim arr(1 To 4) '1到4

arr(1) = "张三"  '1
arr(2) = "李四"  '2
arr(3) = "王五"  '3
arr(4) = "赵六"  '4

Range("b1") = arr(4)

'一维数组是“横”的
Range("a10:d10") = arr

End Sub

''''''''''''''''''''''''''''''''''''''''
'定义二维数组，用单元格区域赋值
'
'Split()返回的就是数组
'
Sub testArr()
Dim arr()

arr = Range("a1:a5")

Range("c1") = arr(2, 1)


End Sub

''''''''''''''''''''''''''''''''''''''''
'定义二维数组并赋值
Sub test1()
Dim arr(1 To 4, 1 To 2)
Dim i, j As Integer

arr(1, 1) = "张三"
arr(1, 2) = 30
arr(2, 1) = "李四"
arr(2, 2) = 35
arr(3, 1) = "王五"
arr(3, 2) = 40

For i = 1 To 4
    For j = 1 To 2
      Debug.Print Trim(arr(i, j))
    Next j
Next i

End Sub
'Output:
'张三
'30
'李四
'35
'王五
'40

''''''''''''''''''''''''''''''''''''''''
'将数组中的某个值输出到单元格
Sub test3()
Dim arr(1 To 4)

arr(1) = "张三"
arr(2) = "李四"
arr(3) = "王五"

Range("b2") = arr(2)

Debug.Print Range("b2") '李四

End Sub

''''''''''''''''''''''''''''''''''''''''
'将一维数组中的所有值输出到单元格区域
Sub test4()
Dim arr(1 To 4)
Dim i As Integer

arr(1) = "张三"
arr(2) = "李四"
arr(3) = "王五"

Range("a7:d7") = arr

For i = LBound(arr) To UBound(arr)
    Debug.Print Trim(arr(i))
Next i

End Sub
'Output:
'张三
'李四
'王五

''''''''''''''''''''''''''''''''''''''''

'将二维数组中的所有值输出到单元格区域
Sub test5()
Dim arr(1 To 3, 1 To 2)
Dim i, j As Integer

arr(1, 1) = "张三"
arr(1, 2) = 30
arr(2, 1) = "李四"
arr(2, 2) = 35
arr(3, 1) = "王五"
arr(3, 2) = 40

Range("a15:b17") = arr

For i = 1 To 3
    For j = 1 To 2
      Debug.Print Trim(arr(i, j))
    Next j
Next i

End Sub
'Output:
'张三
'30
'李四
'35
'王五
'40

''''''''''''''''''''''''''''''''''''''''
'将区域赋值给数组

Sub test6()
Dim arr()

arr = Range("a1:a5")

End Sub

Private Sub Constant_demo_Click()
  Dim arr(2, 3) As Variant  ' Which has 3 rows and 4 columns
  arr(0, 0) = "Apple"
  arr(0, 1) = "Orange"
  arr(0, 2) = "Grapes"
  arr(0, 3) = "pineapple"
  arr(1, 0) = "cucumber"
  arr(1, 1) = "beans"
  arr(1, 2) = "carrot"
  arr(1, 3) = "tomato"
  arr(2, 0) = "potato"
  arr(2, 1) = "sandwitch"
  arr(2, 2) = "coffee"
  arr(2, 3) = "nuts"
           
  Range("D1:G3") = arr
  
  MsgBox ("Value in Array index 0,1 : " & arr(0, 1))
  MsgBox ("Value in Array index 2,2 : " & arr(2, 2))
  
End Sub
