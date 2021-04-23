package chap14.HashTable.example1.HashTableBasics;

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
class Solution {
    public static int firstUniqChar(String s) {

        // 包含26个元素的数组
        // 对于这个数组中的每一位，就表示某一个字符对应它的频率
        // 索引为 0 的位置表是 小a 所对应的字符出现的频率，索引为 1 的位置是 小b 所对应的字符再现频率...
        int[] freq = new int[26];
        for(int i = 0 ; i < s.length(); i ++)
            // 对于字符来说，不管java还是C++语言，都可以把它看作整型
            // ASCII码 l = 108，a = 97, 108 - 97 = 11， ++ 之后数组中值加1，
            freq[s.charAt(i) - 'a'] ++;

        for(int i = 0 ; i < s.length() ; i ++)
            if(freq[s.charAt(i) - 'a'] == 1) // 数组等于1
                return i;

        return -1;
    }

    public static void main(String[] args) {
        String s = "leetcode"; //  freq[11] = 1, freq[4] = 3, freq[14] = 1, freq[19] = 1, freq[2] = 1, freq[3] = 1,
        String a = "loveleetcode";
        int i = 12345678 % 1000000;
        System.out.println(String.valueOf(i));
        System.out.println(firstUniqChar(s));
        System.out.println(firstUniqChar(a));
    }
}
/* Output:
0
2
*///~