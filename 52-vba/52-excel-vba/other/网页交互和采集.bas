'Head 提交
Set ohttp = CreateObject("WinHttp.WinHttpRequest.5.1")
ohttp.Open "Head", URL, False
ohttp.send
strResText = ohttp.responseText

'---------------------------------------------------------------------------------------------------------
'GET提交
Set ohttp = CreateObject("WinHttp.WinHttpRequest.5.1")
ohttp.Open "GET", URL, False
ohttp.send
strResText = ohttp.responseText

'---------------------------------------------------------------------------------------------------------
'Xmlhttp采集
Option Explicit
'''如果出现乱码，UTF-8可改为GB2312
Public Function GetBody(ByVal URL$, Optional ByVal Coding$ = "UTF-8")

    Dim ObjXML
    On Error Resume Next
    Set ObjXML = CreateObject("Microsoft.XMLHTTP")
    With ObjXML
        .Open "Get", URL, False, "", ""
        .setRequestHeader "If-Modified-Since", "0"
        .Send
        GetBody = .ResponseBody
    End With
    GetBody = BytesToBstr(GetBody, Coding)
    Set ObjXML = Nothing
End Function

Public Function GetHtmlDoc(ByVal url$, Optional ByVal Coding$ = "utf-8")
    Dim HtmlDoc
    Set HtmlDoc = CreateObject("htmlfile")
    HtmlDoc.body.innerhtml = GetBody(url, Coding)
    Set GetHtmlDoc = HtmlDoc
End Function

Public Function BytesToBstr(strBody, CodeBase)
    Dim ObjStream
    Set ObjStream = CreateObject("Adodb.Stream")
    With ObjStream
        . Type  = 1
        .Mode = 3
        .Open
        .Write strBody
        .Position = 0
        . Type  = 2
        .Charset = CodeBase
        BytesToBstr = .ReadText
        .Close
    End With
    Set ObjStream = Nothing
End Function

Private Sub Test()
    Dim i&, j&, k&, arr, brr
    URL = "http://www.gettyimages.cn/newsr.php?local=true&colflag=1&signel_c=35#1"
    Debug.Print GetBody(URL)
End Sub

Function ReplaceList(ByVal s, ParamArray list() As Variant)
    '默认参数设置为#1# #2# #3#... 按参数数组的依次替换
    Dim i
    For i = 0 To UBound(list())
        s = Replace(s, "#" & (i + 1) & "#", list(i))
    Next
    ReplaceList = s
End Function

Function EvalByHtml(strText As String) As String
    '解决64位office执行js的问题
    With CreateObject("htmlfile")
        .write "<html><script></script></html>"
        EvalByHtml = CallByName(.parentwindow, "eval", VbMethod, strText)
    End With
End Function


'---------------------------------------------------------------------------------------------------------
'去除所有HTML标签
Private Function delHtmltag(text As Variant) As String
    Dim i&, textLen&, char$, tagFlag As Boolean

    textLen = Len(text)
    tagFlag = False
    delHtmltag = ""

    For i = 1 To textLen
        char = Mid(text, i, 1)
        If char = "<" Then tagFlag = True
        If Not tagFlag Then delHtmltag = delHtmltag + char
        If char = ">" Then tagFlag = False
    Next
End Function


'---------------------------------------------------------------------------------------------------------
'转换HTML字符实体
Function EnCodeByHTML(strText As String)
    With CreateObject("htmlfile")
        .write strText
        EnCodeByHTML = .body.innertext
    End With
End Function












