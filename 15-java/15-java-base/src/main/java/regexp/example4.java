package regexp;


/**
 * Regular Expressions —— 认识\s \w \d \
 * 		.   任意字符（与行结束符可能匹配也可能不匹配）
 * 		\n  换行符匹配。等效于 \x0a 和 \cJ。
 * 		\r  匹配一个回车符。等效于 \x0d 和 \cM。
 * 		\t  制表符匹配。与 \x09 和 \cI 等效。
 * 		\d  数字字符匹配。等效于 [0-9]。
 * 		\D  非数字字符匹配。等效于 [^0-9]。
 * 		\s  匹配任何空白字符，包括空格、制表符、换页符等。与 [ \f\n\r\t\v] 等效。
 * 		\S  匹配任何非空白字符。与 [^ \f\n\r\t\v] 等效。
 * 		\w  匹配任何字类字符，包括下划线。与"[A-Za-z0-9_]"等效。
 * 		\W  与任何非单词字符匹配。与"[^A-Za-z0-9_]"等效。
 */
public class example4 {
	public static void main(String[] args) {
		p(" \n\r\t".matches("\\s{4}"));  //true
		p(" ".matches("\\S"));           //false
		p("a_8".matches("\\w{3}"));      //true
		p("abc888&^%".matches("[a-z]{1,3}\\d+[&^#%]+")); //true
		//java里的一个“\”要用两个“\\”表示（这个跟MySQL一样）
		p("\\".matches("\\\\")); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
