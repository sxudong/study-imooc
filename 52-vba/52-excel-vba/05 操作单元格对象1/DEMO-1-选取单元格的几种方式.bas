'将1赋值给单元格A10
Sub test1()
  [a10] = 1
  Debug.Print Range("A10") '1
End Sub

'将1赋值给单元格C10
Sub test2()
  Cells(10, 1) = 1
  Debug.Print Range("C10") '1
End Sub

'将1赋值给单元格C10
Sub test3()
  Range("C10") = 1
  Debug.Print Range("C10") '1
End Sub

'A1单元格向下偏移10行，向右偏移0列 = A10
'将1赋值给单元格A10
Sub test4()
  Range("a1").Offset(10, 0) = 1
  Debug.Print Range("A10") '1
End Sub

'A10单元格的行数值填到E1单元格中
Sub test5()
  Range("E1") = Range("a10").row
  Debug.Print Range("E1") '10
End Sub
'从A665单元格往上数非空单元格的行号值填入到E1单元格
Sub test6()
  Range("E1") = Range("a665").End(xlUp).row
  Debug.Print Range("E1") '20
End Sub
'删除A10整行单元格
Sub test7()
  Range("a10").EntireRow.Delete
End Sub

'根据D1单元格里的文本选中表
Sub select1()
  Sheets(Range("d1").Value).Select
End Sub
'选中A10-J10单元格
Sub resize()
  Range("a10").resize(1, 10).Select
End Sub
