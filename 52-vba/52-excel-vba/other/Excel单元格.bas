'最后一行/列
ActiveSheet.Range("A:A").Find(What: = "*", LookIn: = xlFormulas, SearchOrder: = xlByRows, SearchDirection: = xlPrevious).Row
ActiveSheet.Range("1:1").Find(What: = "*", LookIn: = xlFormulas, SearchOrder: = xlByRows, SearchDirection: = xlPrevious).Column

'---------------------------------------------------------------------------------------------------------
'单元格复制粘贴
Sub RangeCopy()
    Application.DisplayAlerts = False
    Sheet1.Range("A1").CurrentRegion.Copy Sheet2.Range("A1")
    Application.DisplayAlerts = True
End Sub

'---------------------------------------------------------------------------------------------------------
'设置单元格格式
Public Sub RngFont()
    With Range("A1").Font '对A1单元格进行字体设置
        .Name = "华文彩云" 'Name属性返回或设置对象的名称
        .FontStyle = "Bold" 'FontStyle属性返回或设置字体样式。设置为”Bold” 加粗字体，设置为”Italic”倾斜字体
        .Size = 18 'Size属性返回或设置字体大小
        .ColorIndex = 3 'ColorIndex属性返回或设置字体的颜色，该颜色可指定为当前调色板中颜色的编号
        .Underline = 2 'Underline属性返回或设置应用于字体的下划线
    End With
End Sub



















