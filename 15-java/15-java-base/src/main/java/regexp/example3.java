package regexp;

/**
 * 范围
 *
 * [xyz]  字符集。匹配包含的任一字符。
 *        例如，"[abc]"匹配"plain"中的"a"。
 *
 * [^xyz] 反向字符集。匹配未包含的任何字符。
 *        例如，"[^abc]"匹配"plain"中"p"，"l"，"i"，"n"。
 *
 * [a-z]  字符范围。匹配指定范围内的任何字符。
 *        例如，"[a-z]"匹配"a"到"z"范围内的任何小写字母。
 *
 * [^a-z] 反向范围字符。匹配不在指定的范围内的任何字符。
 *        例如，"[^a-z]"匹配任何不在"a"到"z"范围内的任何字符。
 *
 * “[a-z] | [A-Z]”  或者 取交集
 * "[a-z] && [A-Z]" 并且 取并集
 */
public class example3 {
	public static void main(String[] args) {
		p("a".matches("[abc]"));        //true
		p("a".matches("[^abc]"));       //false
		p("A".matches("[a-zA-Z]"));     //true
		p("A".matches("[a-z]|[A-Z]"));  //true
		p("A".matches("[a-z[A-Z]]"));   //true
		p("R".matches("[A-Z&&[RFG]]")); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
