package chap14.HashTable.example1.HashTableBasics;

import java.util.HashMap;


/**
 * 387. 字符串中的第一个唯一字符
 *
 * 给定一个字符串，找到它的第一个不重复的字符，并返回它的索引。如果不存在，则返回 -1。
 *
 *  
 * 示例：
 *
 * s = "leetcode"  l是这个字符串中第一个不重复的字符，所以返回 0
 * 返回 0
 *
 * s = "loveleetcode"  v是这个字符串中第一个不重复的字符，所以返回 2
 * 返回 2
 *  
 *
 * 提示：你可以假定该字符串只包含小写字母。
 * 链接：https://leetcode-cn.com/problems/first-unique-character-in-a-string
 */
class Solution2 {
    public static int firstUniqChar(String s) {

        HashMap<Character, Integer> count = new HashMap<Character, Integer>();
        // build hash map : character and how often it appears
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            count.put(c, count.getOrDefault(c, 0) + 1);
        }

        // find the index
        for (int i = 0; i < s.length(); i++) {
            if (count.get(s.charAt(i)) == 1)
                return i;
        }
        return -1;
    }

    public static void main(String[] args) {
        String s = "leetcode";
        String a = "loveleetcode";

        System.out.println(firstUniqChar(s));
        System.out.println(firstUniqChar(a));
    }
}
/* Output:
0
2
*///~