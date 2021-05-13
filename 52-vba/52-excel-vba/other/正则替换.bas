Function regReplace(text As String, reg_pattern As String, replacement As String)
    '正则替换，用于替换字符串中，符合模板的字符
    'text           待替换的文字
    'reg_pattern    需要替换的模板
    'replacement    替换成的文字

    Dim reg As Object
    Set reg = CreateObject("vbscript.regexp")

    With reg
        .Global = True      '全局替换
        .ignorecase = True  '忽略大小写
        .MultiLine = True   '多行模式
        .pattern = reg_pattern  '定义替换模板
        regReplace = .Replace(text, replacement) '替换
    End With

End Function

Function regFind(text As String, reg_pattern As String)
    '正则查找，用于查找符合模板中的字符
    'text           待替换的文字
    'reg_pattern    需要查找的模板

    Dim reg As Object
    Set reg = CreateObject("vbscript.regexp")

    With reg
        .Global = True      '全局替换
        .ignorecase = True  '忽略大小写
        .MultiLine = True   '多行模式
        .pattern = reg_pattern  '定义替换模板
        Set tmp = .Execute(text) '查找
        regFind = tmp(0).Value
    End With

End Function