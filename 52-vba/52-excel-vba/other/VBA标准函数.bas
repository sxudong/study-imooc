'字符串函数
Trim(String) '去掉string左右两端空白
LTrim(String) '去掉string左端空白
RTrim(String) '去掉string右端空白
Len(String) '计算string长度
Left(String, x) '取string左段x个字符组成的字符串
Right(String, x) '取string右段x个字符组成的字符串
Mid(String, start, x) '取string从start位开始的x个字符组成的字符串
UCase(String) '转换为大写
LCase(String) '转换为小写
Space(x) '返回x个空白的字符串
Asc(String) '返回一个 integer，代表字符串中首字母的字符代码


'---------------------------------------------------------------------------------------------------------
'转换函数
CBool(expression) '转换为Boolean型
CByte(expression) '转换为Byte型
CCur(expression) '转换为Currency型
CDate(expression) '转换为Date型
CDbl(expression) '转换为Double型
CDec(expression) '转换为Decemal型
CInt(expression) '转换为Integer型
CLng(expression) '转换为Long型
CSng(expression) '转换为Single型
CStr(expression) '转换为String型
CVar(expression) '转换为Variant型
Val(String) '转换为数据型
Str(number) '转换为String


'---------------------------------------------------------------------------------------------------------
'时间函数
Now '返回一个 Variant (Date)，根据计算机系统设置的日期和时间来指定日期和时间。
Date '返回包含系统日期的 Variant (Date)。
Time '返回一个指明当前系统时间的 Variant (Date)。
Timer '返回一个 Single，代表从午夜开始到现在经过的秒数。
Second(Time) '返回一个 Variant (Integer)，其值为 0 到 59 之间的整数，表示一分钟之中的某个秒
Minute(Time) '返回一个 Variant (Integer)，其值为 0 到 59 之间的整数，表示一小时中的某分钟
Hour(Time) '返回一个 Variant (Integer)，其值为 0 到 23 之间的整数，表示一天之中的某一钟点
Day(Date) '返回一个 Variant (Integer)，其值为 1 到 31 之间的整数，表示一个月中的某一日
Month(Date) '返回一个 Variant (Integer)，其值为 1 到 12 之间的整数，表示一年中的某月
Year(Date) '返回 Variant (Integer)，包含表示年份的整数。
Weekday(Date, [firstdayofweek]) '返回一个 Variant (Integer)，包含一个整数，代表某个日期是星期几
TimeSerial(Hour, Minute, Second) '返回一个 Variant (Date)，包含具有具体时、分、秒的时间。
DateDiff(interval, date1, date2[, firstdayofweek[, firstweekofyear]]) '返回 Variant (Long) 的值，表示两个指定日期间的时间间隔数目















