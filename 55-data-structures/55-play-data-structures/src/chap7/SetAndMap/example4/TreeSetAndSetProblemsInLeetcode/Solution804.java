package chap7.SetAndMap.example4.TreeSetAndSetProblemsInLeetcode;
// Leetcode 804. Unique Morse Code Words
// https://leetcode.com/problems/unique-morse-code-words/description/

import java.util.TreeSet;

/**
 * 804. 唯一摩尔斯密码词
 *
 * 国际摩尔斯密码定义一种标准编码方式，将每个字母对应于一个由一系列点和短线组成的字符串， 比如: "a" 对应 ".-", "b" 对应 "-...", "c" 对应 "-.-.", 等等。
 *
 * 为了方便，所有26个英文字母对应摩尔斯密码表如下：
 *
 * [".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."]
 * 给定一个单词列表，每个单词可以写成每个字母对应摩尔斯密码的组合。例如，"cab" 可以写成 "-.-..--..."，(即 "-.-." + "-..." + ".-"字符串的结合)。我们将这样一个连接过程称作单词翻译。
 *
 * 返回我们可以获得所有词不同单词翻译的数量。
 *
 * 例如:
 * 输入: words = ["gin", "zen", "gig", "msg"]
 * 输出: 2
 * 解释:
 * 各单词翻译如下:
 *   "gin" -> "--...-."
 *   "zen" -> "--...-."
 *   "gig" -> "--...--."
 *   "msg" -> "--...--."
 *
 * 共有 2 种不同翻译, "--...-." 和 "--...--.".
 *
 */
public class Solution804 {

    public int uniqueMorseRepresentations(String[] words) {

        String[] codes = {".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."};

        /**
         * 使用 Java 提供的 TreeSet
         * 底层是基于红黑树实现的
         */
        TreeSet<String> set = new TreeSet<>();

        for(String word: words){
            StringBuilder res = new StringBuilder();
            // 遍历单词
            for(int i = 0 ; i < word.length() ; i ++) {
                // "word.charAt(i) - 'a'", 相当于初始偏移计算。ASCII码 a=97,b=98,c=99 ...
                // word.charAt(i)获得当前的字符，对应codes中的位置
                // 最后 res 当中就存了对于word这个单词摩尔斯密码是谁
                res.append(codes[word.charAt(i) - 'a']);
            }
            set.add(res.toString()); // 对于相同的摩尔斯密码不会进行添加
        }

        return set.size(); // 最后不同的摩尔斯密码数量
    }
}
