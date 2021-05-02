
'快速排序
Sub QuickSort(ByRef arr, ByRef nLeft&, ByRef nRight&)
    Dim i&, j&, vKey, vSwap
    If nLeft >= nRight Then Exit Sub
    vKey = arr(nLeft)
    i = nLeft + 1:j = nRight
    Do
        Do While i <= nRight
            If arr(i) > vKey Then Exit Do
            i = i + 1
        Loop
        Do While j > nLeft
            If arr(j) < vKey Then Exit Do
            j = j - 1
        Loop
        If i >= j Then Exit Do
        vSwap = arr(i): arr(i) = arr(j): arr(j) = vSwap
    Loop
    If nLeft <> j Then
        vSwap = arr(nLeft): arr(nLeft) = arr(j): arr(j) = vSwap
    End If
    If nLeft < j Then Call QuickSort(arr, nLeft, j)
    If j + 1 < nRight Then Call QuickSort(arr, j + 1, nRight)
End Sub


'---------------------------------------------------------------------------------------------------------
'七种排序算法
''ModuleName="SevenSortingAlgorithms"
'排序算法常用的有七种，分别是冒泡排序，选择排序，希尔排序，堆排序，桶排序，插入排序和快速排序。
Public Const ZERO = 0

Enum eOrderType
    ASCENDING_ORDER = 0
    DESCENDING_ORDER = 1
End Enum

'用于指明重复次数的全局变量
Public gIterations

'冒泡排序
Sub BubbleSort(MyArray(), ByVal nOrder As eOrderType)
    Dim Index
    Dim TEMP
    Dim NextElement
    '先将已处理的元素个数置为0
    NextElement = ZERO
    '遍历每一个元素
    Do While (NextElement < UBound(MyArray))
        '读取当前最大下标
        Index = UBound(MyArray)
        '与前面的每一个元素比较
        Do While (Index > NextElement)
            '根据是升序或降序进行分别处理
            If nOrder = ASCENDING_ORDER Then
                '升序:如果当前值小于上一个值,则互换
                If MyArray(Index) < MyArray(Index - 1) Then
                    TEMP = MyArray(Index)
                    MyArray(Index) = MyArray(Index - 1)
                    MyArray(Index - 1) = TEMP
                End If
            ElseIf nOrder = DESCENDING_ORDER Then
                '降序:如果当前值大于上一个值,则互换
                If MyArray(Index) > MyArray(Index - 1) Then
                    TEMP = MyArray(Index)
                    MyArray(Index) = MyArray(Index - 1)
                    MyArray(Index - 1) = TEMP
                End If
            End If
            '将当前下标移到上一个值
            Index = Index - 1
            '用于指明重复次数的全局变量
            gIterations = gIterations + 1
        Loop
        '将已处理的元素个数加1
        NextElement = NextElement + 1
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Loop
End Sub

'桶排序
Sub Bucket(MyArray(), ByVal nOrder As eOrderType)
    Dim Index
    Dim NextElement
    Dim TheBucket
    '先将已处理的元素个数为最小下标加1
    NextElement = LBound(MyArray) + 1
    '遍历每一个元素
    While (NextElement <= UBound(MyArray))
        '读取当前元素
        TheBucket = MyArray(NextElement)
        '读取当前下标
        Index = NextElement
        Do
            '如果当前下标大于最小下标,则处理
            If Index > LBound(MyArray) Then
                '根据是升序或降序进行分别处理
                If nOrder = ASCENDING_ORDER Then
                    '升序:如果当前值小于上一个值
                    '则将下一个值放到当前值(当前值在TheBucket中不动)
                    If TheBucket < MyArray(Index - 1) Then
                        MyArray(Index) = MyArray(Index - 1)
                        Index = Index - 1
                    Else
                        Exit Do
                    End If
                ElseIf nOrder = DESCENDING_ORDER Then
                    '降序:如果当前值大于上一个值
                    '则将下一个值放到当前值(当前值在TheBucket中不动)
                    If TheBucket > MyArray(Index - 1) Then
                        MyArray(Index) = MyArray(Index - 1)
                        Index = Index - 1
                    Else
                        Exit Do
                    End If
                End If
            Else
                Exit Do
            End If
            '用于指明重复次数的全局变量
            gIterations = gIterations + 1
        Loop
        MyArray(Index) = TheBucket
        NextElement = NextElement + 1
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
End Sub

'堆排序
Sub Heap(MyArray())
    Dim Index
    Dim Size
    Dim TEMP

    '读取最大下标
    Size = UBound(MyArray)
    '将当前要处理的置为1
    Index = 1
    '处理每一个元素
    While (Index <= Size)
        '向上筛选
        Call HeapSiftup(MyArray(), Index)
        Index = Index + 1
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
    Index = Size
    While (Index > 0)
        '当前值与第一个值互换
        TEMP = MyArray(0)
        MyArray(0) = MyArray(Index)
        MyArray(Index) = TEMP
        '向下筛选
        Call HeapSiftdown(MyArray(), Index - 1)
        Index = Index - 1
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
End Sub

'堆排序的向下筛选子程序
Sub HeapSiftdown(MyArray(), M)
    Dim Index
    Dim Parent
    Dim TEMP
    Index = 0
    'Parent位置定位于2 * Index
    Parent = 2 * Index
    Do While (Parent <= M)
        '如果当前Parent位的值后面的值要大,向后移Parent位
        If (Parent < M And MyArray(Parent) < MyArray(Parent + 1)) Then
            Parent = Parent + 1
        End If
        '如果当前值大于Parent位的值,结束筛选
        If MyArray(Index) >= MyArray(Parent) Then
            Exit Do
        End If
        '否则交换两个值
        TEMP = MyArray(Index)
        MyArray(Index) = MyArray(Parent)
        MyArray(Parent) = TEMP
        '当前位置移到Parent
        Index = Parent
        Parent = 2 * Index
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Loop
End Sub

'堆排序的向上筛选子程序
Sub HeapSiftup(MyArray(), M)
    Dim Index
    Dim Parent
    Dim TEMP
    Index = M
    Do While (Index > 0)
        '只要Index / 2位置的值大于当前值就结束筛选
        Parent = Int(Index / 2)
        If MyArray(Parent) >= MyArray(Index) Then
            Exit Do
        End If
        '否则交换两值
        TEMP = MyArray(Index)
        MyArray(Index) = MyArray(Parent)
        MyArray(Parent) = TEMP
        '将当前点移到Index / 2
        Index = Parent
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Loop

End Sub


'插入排序
Sub Insertion(MyArray(), ByVal nOrder As eOrderType)
    Dim Index
    Dim TEMP
    Dim NextElement
    '先将已处理的元素个数为最小下标加1
    NextElement = LBound(MyArray) + 1
    '遍历每一个元素
    While (NextElement <= UBound(MyArray))
        '读取当前下标
        Index = NextElement
        Do
            '如果当前下标大于最小下标,则处理
            If Index > LBound(MyArray) Then
                '根据是升序或降序进行分别处理
                If nOrder = ASCENDING_ORDER Then
                    '升序:如果当前值小于上一个值,则互换
                    If MyArray(Index) < MyArray(Index - 1) Then
                        TEMP = MyArray(Index)
                        MyArray(Index) = MyArray(Index - 1)
                        MyArray(Index - 1) = TEMP
                        Index = Index - 1
                    Else
                        Exit Do
                    End If
                ElseIf nOrder = DESCENDING_ORDER Then
                    '降序:如果当前值大于上一个值,则互换
                    If MyArray(Index) > MyArray(Index - 1) Then
                        TEMP = MyArray(Index)
                        MyArray(Index) = MyArray(Index - 1)
                        MyArray(Index - 1) = TEMP
                        Index = Index - 1
                    Else
                        Exit Do
                    End If
                End If
            Else
                Exit Do
            End If
            '用于指明重复次数的全局变量
            gIterations = gIterations + 1
        Loop
        NextElement = NextElement + 1
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
End Sub

'快速排序
Sub QuickSort(MyArray(), L, R)
    Dim i, j, X, Y
    i = L
    j = R

    '找出数组的中点
    X = MyArray((L + R) / 2)


    While (i <= j)
        '找出比中点大的数
        While (MyArray(i) < X And i < R)
            i = i + 1
        Wend
        '找出比中点小的数
        While (X < MyArray(j) And j > L)
            j = j - 1
        Wend
        '互换这两个数
        If (i <= j) Then
            Y = MyArray(i)
            MyArray(i) = MyArray(j)
            MyArray(j) = Y
            i = i + 1
            j = j - 1
        End If
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
    '未完成时递归调用
    If (L < j) Then Call QuickSort(MyArray(), L, j)
    If (i < R) Then Call QuickSort(MyArray(), i, R)
End Sub

'选择排序
Sub Selection(MyArray(), ByVal nOrder As eOrderType)
    Dim Index
    Dim Min
    Dim NextElement
    Dim TEMP '已处理的元素的个数置为0 NextElement = 0
    '遍历所有元素
    While (NextElement < UBound(MyArray))
        '读取最大下标,作为当前最小值下标
        Min = UBound(MyArray)
        '取倒数第二个下标
        Index = Min - 1
        '与所有元素比较
        While (Index >= NextElement)
            '根据是升序或降序进行分别处理
            If nOrder = ASCENDING_ORDER Then
                '根据比较结果重置最小下标
                If MyArray(Index) < MyArray(Min) Then

                    Min = Index
                End If
            ElseIf nOrder = DESCENDING_ORDER Then
                '根据比较结果重置最小下标
                If MyArray(Index) > MyArray(Min) Then
                    Min = Index
                End If
            End If
            Index = Index - 1
            '用于指明重复次数的全局变量
            gIterations = gIterations + 1
        Wend
        '根据最小下,与当前值互换
        TEMP = MyArray(Min)
        MyArray(Min) = MyArray(NextElement)
        MyArray(NextElement) = TEMP
        NextElement = NextElement + 1
        '用于指明重复次数的全局变量
        gIterations = gIterations - 1
    Wend
End Sub

'希尔排序
Sub ShellSort(MyArray(), ByVal nOrder As eOrderType)
    Dim Distance
    Dim Size
    Dim Index
    Dim NextElement
    Dim TEMP
    '读取元素的数量
    Size = UBound(MyArray) - LBound(MyArray) + 1
    '定义当前跨度
    Distance = 1
    '将跨度定义为小于元素的数量的2的最大幂
    While (Distance <= Size)
        Distance = 2 * Distance
    Wend
    '再找出跨度的中点
    Distance = (Distance / 2) - 1

    While (Distance > 0)
        '读取中点的下标
        NextElement = LBound(MyArray) + Distance
        '移排序并移动中点(不大于最大下标)
        While (NextElement <= UBound(MyArray))
            '将中点作为当前下标
            Index = NextElement
            Do
                '中点在跨度后面则要处理
                If Index >= (LBound(MyArray) + Distance) Then
                    '根据是升序或降序进行分别处理
                    If nOrder = ASCENDING_ORDER Then
                        '升序:如果当前值小于上一个值,则互换
                        If MyArray(Index) < MyArray(Index - Distance) Then
                            TEMP = MyArray(Index)
                            MyArray(Index) = MyArray(Index - Distance)
                            MyArray(Index - Distance) = TEMP
                            Index = Index - Distance
                            '用于指明重复次数的全局变量
                            gIterations = gIterations + 1
                        Else
                            Exit Do
                        End If
                    ElseIf nOrder = DESCENDING_ORDER Then
                        '降序:如果当前值大于上一个值,则互换
                        If MyArray(Index) > MyArray(Index - Distance) Then
                            TEMP = MyArray(Index)
                            MyArray(Index) = MyArray(Index - Distance)
                            MyArray(Index - Distance) = TEMP
                            Index = Index - Distance
                            '用于指明重复次数的全局变量
                            gIterations = gIterations + 1
                        Else
                            Exit Do
                        End If
                    End If
                Else
                    Exit Do
                End If
            Loop
            NextElement = NextElement + 1
            '用于指明重复次数的全局变量
            gIterations = gIterations + 1
        Wend
        Distance = (Distance - 1) / 2
        '用于指明重复次数的全局变量
        gIterations = gIterations + 1
    Wend
End Sub

















