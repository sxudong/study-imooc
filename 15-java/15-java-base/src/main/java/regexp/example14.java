package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— flags 的简写
 *
 * static int CANON_EQ
 *           启用规范等价。
 * static int CASE_INSENSITIVE
 *           启用不区分大小写的匹配。
 * static int COMMENTS
 *           模式中允许空白和注释。
 * static int DOTALL
 *           启用 dotall 模式。
 * static int LITERAL
 *           启用模式的字面值解析。
 * static int MULTILINE
 *           启用多行模式。
 * static int UNICODE_CASE
 *           启用 Unicode 感知的大小写折叠。
 * static int UNIX_LINES
 *           启用 Unix 行模式。
 */
public class example14 {
	public static void main(String[] args) {
		// flags 的简写
		Pattern p = Pattern.compile("java", Pattern.CASE_INSENSITIVE); //大小写忽略
		Matcher m = p.matcher("java Java JAVa JaVa IloveJAVA you hateJava afasdfasdf");
		p(m.replaceAll("JAVA")); //JAVA JAVA JAVA JAVA IloveJAVA you hateJAVA afasdfasdf

		//(?i)非捕获，与上面的 忽略大小写 一样，是上面表达式的简写
		p("Java".matches("(?i)(java)")); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
