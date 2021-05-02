'字典声明
Dim dic

Set dic = CreateObject("scripting.dictionary")


'---------------------------------------------------------------------------------------------------------
'文件对象
Set fs = CreateObject("Scripting.FileSystemObject")



'---------------------------------------------------------------------------------------------------------
'AOD对象
Dim cnn As Object, rs As Object

Set cnn = CreateObject("adodb.connection")
Set cnn = CreateObject("adodb.connection"): mybook = ThisWorkbook.FullName
cnn.Open "Provider = Microsoft.Jet.Oledb.4.0;Extended Properties =Excel 8.0;Data Source =" & mybook


'---------------------------------------------------------------------------------------------------------
'Wscript
Set Wscript = CreateObject("Wscript.Shell")