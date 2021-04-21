package design.pattern.behavioral.interpreter;

import java.util.regex.Pattern;

public class RegexpTest {
    public static void main(String[] args) {
        String str = "boo:and:foo";
        // 如果你需要不止一次利用正则表达式去匹配一个文本的时候，
        // 你需要用Pattern.compile()去创建一个Pattern的实例
        //Pattern pattern = Pattern.compile(":");
        String[] sp = Pattern.compile(":").split(str, 3);
        for (int i = 0; i < sp.length; i++) {
            System.out.print("\"" + sp[i] + "\"" + ", ");
            // "boo", "and", "foo",
        }

        String text = "This is the text to be searched for occurrences of the pattern.";
        String pattern = ".*is.*";
        // 是否匹配某一个文本
        boolean matches = Pattern.matches(pattern, text);
        System.out.println("matches = " + matches); //matches = true

        pattern();
    }

    public static void pattern() {
        String text = "A sep Text sep With sep Many sep Separators";
        String patternString = "sep";
        Pattern pattern = Pattern.compile(patternString);
        String[] split = pattern.split(text);
        System.out.println("split.length = " + split.length);

        for(String element : split){
            System.out.println("element = " + element);
        }
    }
}
