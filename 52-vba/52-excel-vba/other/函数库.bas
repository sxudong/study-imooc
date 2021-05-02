'URL编码（ANSI）
Function URLEncodePlus(strURL)
    'ANSI编码,空格处理成+号
    Dim i
    Dim tempStr
    For i = 1 To Len(strURL)
        If Asc(Mid(strURL, i, 1)) < 0 Then
            tempStr = "%" & Right(CStr(Hex(Asc(Mid(strURL, i, 1)))), 2)
            tempStr = "%" & Left(CStr(Hex(Asc(Mid(strURL, i, 1)))), Len(CStr(Hex(Asc(Mid(strURL, i, 1))))) - 2) & tempStr
            URLEncodePlus = URLEncodePlus & tempStr
        ElseIf (Asc(Mid(strURL, i, 1)) >= 65 And Asc(Mid(strURL, i, 1)) <= 90) Or (Asc(Mid(strURL, i, 1)) >= 97 And Asc(Mid(strURL, i, 1)) <= 122) Or (Asc(Mid(strURL, i, 1)) >= 48 And Asc(Mid(strURL, i, 1)) <= 57) Then
            URLEncodePlus = URLEncodePlus & Mid(strURL, i, 1)
        Else
            tempStr = Mid(strURL, i, 1)
            Select Case tempStr
                Case ".", "-", "~", "_"
                    URLEncodePlus = URLEncodePlus & tempStr
                Case " "
                    URLEncodePlus = URLEncodePlus & "+"
                Case Else
                    URLEncodePlus = URLEncodePlus & "%" & Hex(Asc(tempStr))
            End Select

        End If
    Next
End Function


'---------------------------------------------------------------------------------------------------------
'去除不可见字符
Function 去除不可见字符(rng As Range)
    Dim ar, i
    ar = Array(9, 10, 13, 28, 29, 30, 31, 32, 127)
    For i = 0 To UBound(ar)
        rng.Replace ChrW(ar(i)), ""
    Next

    For i = 129 To 254
        rng.Replace ChrW(i), ""
    Next
    rng.Replace " ", ""
End Function