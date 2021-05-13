'重新定义数组
ReDim Preserve

'---------------------------------------------------------------------------------------------------------
'一维数组遍历
For i = LBound(aryData) To UBound(aryData)
    aryData(i) = 1
Next

'---------------------------------------------------------------------------------------------------------
'二维数组遍历
For i = LBound(aryData) To UBound(aryData)
    For j = LBound(aryData, 2) To UBound(aryData, 2)
        aryData(i, j) = 1
    Next
Next

'---------------------------------------------------------------------------------------------------------
'数组维数
Public Function NumberOfArrayDimensions(arr As Variant) As Integer
    '计算数组维数
    Dim Ndx As Integer
    Dim Res As Integer
    On Error Resume Next
    Do
        Ndx = Ndx + 1
        Res = UBound(arr, Ndx)
    Loop Until Err.Number <> 0
    NumberOfArrayDimensions = Ndx - 1
End Function


'功能 : 从单列二维数组中不重复随机抽取N个数,返回抽取的的二维数组(单列)
'变量 : RngArr 单元格区域/二维单列数组
'       N      要抽取的个数
'---------------------------------------------------------------------------------------------------------
Function RndFromArr(RngArr, N & )
    Dim M&, arr, rng As Range, r&, i&, t
    Application.Volatile
    arr = RngArr
    ReDim brr(1 To N, 1 To 1) '定义结果数组
    M = UBound(arr) '
    If N > M Then RndFromArr = "Err": Exit Function
    Randomize '随机种子初始化 以保证每次得到不同的随机序列
    For i = 1 To N '遍历提取n个数据
        r = Int(Rnd * (M - i + 1)) + i '从剩余数据中得到随机位置r (注意里面剩余数计算用m 不是n)
        t = arr(r, 1): arr(r, 1) = arr(i, 1): brr(i, 1) = t
        '用临时变量t进行随机位置和当前位置的交换 保证得到随机不重复乱序结果
    Next
    RndFromArr = brr
End Function