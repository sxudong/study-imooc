'图表属性太多，靠录制
Sub test()
    Dim shp As Shape

    '插入图表
    Set shp = Sheet1.Shapes.AddChart                   '添加一张图表
        shp.Chart.SetSourceData Range("b2:c14")        '数据源
        shp.Chart.ChartType = xlLine                   'x轴折线图
        shp.Chart.Axes(xlValue).MinimumScale = 1000000 '最小精度1000000
End Sub