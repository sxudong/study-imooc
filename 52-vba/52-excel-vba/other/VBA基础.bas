'错误处理
On Error Resume Next

Sub ErrTest()
    Dim x As Integer, y As Integer, z As Single
    x = 1
    y = 0
    On Error GoTo myerr1
    MsgBox x / y
    On Error GoTo myerr2
    MsgBox x / y
    MsgBox "?继续执行错误代码行的下一行代码?"
    Exit Sub
MyErr1:
    MsgBox "?第?1?次：除数不能为?0"
    Resume Next
MyErr2:
MsgBox "?第?2?次：除数不能为?0"
Resume Next
End Sub


'关键字大全
'---------------------------------------------------------------------------------------------------------
'单元格复制粘贴
'VBA关键词
'https://blog.csdn.net/hpdlzu80100/article/details/80529009   关键词
'https://docs.microsoft.com/zh-cn/office/vba/Language/Reference/keywords-visual-basic-for-applications

Option Base
Option Compare
Option Private
Option Explicit

Array
Private
Public
Dim
New
Static
Const
LBound
UBound
Erase
ReDim

#Const
#If  Then #Else
    Clear
    GoSub ...Return
    Goto
     On Error
    GoSub
    Goto
    DoEvents
    Error
    Raise
    Err
    Resume
    End
    Exit
    Stop
    Do Loop
    For Next
    For Each Next
    While Wend
    With
        Choose
        If  Then Else
        Select Case
                Switch
                Call
                Function
                    Property Get
                        Property Let
                            Property Set
                                Sub
                                    Chr
                                    LCase
                                    UCase
                                    Hex
                                    Oct
                                    Format
                                    Str
                                    Fix
                                    Int
                                    Val
                                    CBool
                                    CByte
                                    CCur
                                    CDate
                                    CDbl
                                    CDec
                                    CInt
                                    CLng
                                    CLngLng
                                    CLngPtr
                                    CSng
                                    CStr
                                    CVar
                                    CVErr
                                    Fix
                                     Boolean
                                     Byte
                                     Currency
                                     Double
                                     Integer
                                     Long
                                     LongLong
                                     LongPtr
                                     Object
                                     Single
                                     String
                                     Variant(Default )
                                    IsArray
                                    IsDate
                                    IsEmpty
                                    IsError
                                    IsMissing
                                    IsNull
                                    IsNumeric
                                    IsObject
                                     Date
                                    Now
                                    Time
                                    DateAdd
                                    DateDiff
                                    DatePart
                                    DateSerial
                                    DateValue
                                    TimeSerial
                                    TimeValue
                                    Timer
                                    Day
                                    Month
                                    Weekday
                                    Year
                                    Hour
                                    Minute
                                    Second
                                    Asc
                                    TimeSerial
                                    TimeValue
                                    ChDir
                                    ChDrive
                                    FileCopy
                                    MkDir
                                    RmDir
                                    Name
                                    CurDir
                                    FileDateTime
                                    Open
                                    Close
                                    Reset
                                    Print
                                    FreeFile
                                    Loc
                                    LOF
                                    Dir
                                    Kill
                                    Lock
                                    Unlock
                                    Get
                                    Input
                                    Input #
                                    Line Input #
                                    FileLen
                                    FileAttr
                                    GetAttr
                                    SetAttr
                                    Seek
                                    Print #
                                    Put
                                    Write #
                                    EOF
                                    Atn
                                    Cos
                                    Sin
                                    Tan
                                    Exp
                                    Log
                                    Sqr
                                    Randomize
                                    Rnd
                                    Abs
                                    Sgn
                                    Fix
                                    AppActivate
                                    Shell
                                    SendKeys
                                    Beep
                                    Environ
                                    Command
                                    CreateObject
                                    GetObject
                                    QBColor
                                    RGB
                                     Mod
                                    Like
                                     Is
                                    Not
                                    And
                                    Or
                                    Xor
                                    Eqv
                                    Imp
                                    StrComp
                                    StrConv
                                    Space
                                    Len
                                    LSet
                                    Rset
                                    InStr
                                    Left
                                    LTrim
                                    Mid
                                    Right
                                    RTrim
                                    Trim
                                    TypeName
                                    VarType
                                    Me
                                    DefBool
                                    DefByte
                                    DefInt
                                    DefLng
                                    DefLngLng
                                    DefLngPtr
                                    DefCur
                                    DefSng
                                    DefDbl
                                    DefDec
                                    DefDate
                                    DefStr
                                    DefObj
                                    DefVar