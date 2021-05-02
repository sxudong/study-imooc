'标准模块
''ModuleName="BasOne2Many"
Sub testCls()
    Dim dic As Object, i&, j&
    Dim item As clsItem

    Set dic = CreateObject("Scripting.Dictionary") '后期绑定引用字典对象

    For i = 1 To 3
        Set item = New clsItem
        item.Name = "name" & i
        item.id = "id" & i
        item.idx = i
        '定义用于输出的数组大小
        Call item.RedimData(0, 3)
        For j = 0 To 3
            Call item.InputData("key" & i & "data" & j, j) '给数组赋值
        Next
        dic.Add "key" & i, item
        Set item = Nothing
    Next
    [A1:C1] = dic("key2").Outputdata '输出
    Set dic = Nothing
End Sub


'---------------------------------------------------------------------------------------------------------

'类模块
''ModuleName="ClsOne2Many"
Public Name As String
Public id As String
Public idx As Long

Private data()

Public Sub RedimData(ByVal l As Long, ByVal r As Long)
    ReDim data(l To r)
End Sub

Public Sub InputData(ByVal Str As String, ByVal i As Long)
    data(i) = Str
End Sub

Public Property Get Outputdata() As Variant
    Outputdata = data
End Property

Private Sub Class_Initialize()

End Sub

Private Sub Class_Terminate()
    Erase data
End Sub