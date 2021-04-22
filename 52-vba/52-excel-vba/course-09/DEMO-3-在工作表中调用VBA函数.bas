'
'截取字符串函数
'
'
'参数1：字符串
'参数2：根据指定字符串截断
'参数3：取第几段

' =jqzf(A3,"-",3) PW-023-2015-37-001 => 2015
Function jqzf(str As String, str1 As String, i As Integer)

  jqzf = Split(str, str1)(i - 1)
  Debug.Print jqzf  '2015
End Function