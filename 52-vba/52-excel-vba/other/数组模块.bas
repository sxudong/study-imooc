'数组截取功能
'arr 要截取的数组
'intStart 开始截取下标位置
'intEnd   结束截取下标位置
Function arrCut(arr, intStart, intEnd)  
    Dim tmp()

    If IsArray(arr) Then

        w1 = LBound(arr, 2) '获取数组2维的最低值
        w2 = UBound(arr, 2) '获取数组2维的最高值
        arrLen = intEnd - intStart + 1  '获取数组长度

        ReDim tmp(1 To arrLen, w1 To w2)    '重新定义数组

        n = 1   '设置新数组1维的最低值

        For i = intStart To intEnd  '循环需要截取的部分
            For j = w1 To w2    '循环2维内容
                tmp(n, j) = arr(i, j)   '将截取出来的数组放入新数组
            Next
            n = n + 1
        Next
    End If

    arrCut = tmp
End Function