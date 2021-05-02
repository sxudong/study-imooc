'启用和禁用屏幕刷新
Application.ScreenUpdating = False

Application.ScreenUpdating = True


'---------------------------------------------------------------------------------------------------------
'启用和禁用警告
Application.DisplayAlerts = False

Application.DisplayAlerts = True

'---------------------------------------------------------------------------------------------------------
'启用和禁用事件
Application.EnableEvents = False

Application.EnableEvents = True

'---------------------------------------------------------------------------------------------------------
'手动计算
Application.Calculation = xlManual

'---------------------------------------------------------------------------------------------------------
'自动计算
Application.Calculation = xlAutomatic

'---------------------------------------------------------------------------------------------------------
'取消复制选区
Application.CutCopyMode = False


'---------------------------------------------------------------------------------------------------------
'状态栏进度
Sub Main()

    Dim oldStatusBar

    oldStatusBar = Application.DisplayStatusBar

    Application.DisplayStatusBar = True

    Application.StatusBar = "正在刷新..."



    Application.StatusBar = "刷新完成!"

    delay 2

    Application.StatusBar = False

    Application.DisplayStatusBar = oldStatusBar

End Sub



