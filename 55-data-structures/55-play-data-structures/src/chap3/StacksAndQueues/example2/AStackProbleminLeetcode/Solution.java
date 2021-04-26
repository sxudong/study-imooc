package chap3.StacksAndQueues.example2.AStackProbleminLeetcode;

import java.util.Stack;

/**
 * 20. 有效的括号
 *   给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
 *
 * 有效字符串需满足：
 *   1.左括号必须用相同类型的右括号闭合。
 *   2.左括号必须以正确的顺序闭合。
 * 注意空字符串可被认为是有效字符串。
 *
 * 链接：https://leetcode-cn.com/problems/valid-parentheses
 */
class Solution {
    public boolean isValid(String s) {
        Stack<Character> stack = new Stack<>();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '(' || c == '[' || c == '{') // 如果匹配上“左边括号”就压入栈中
                stack.push(c);
            else {
                if (stack.isEmpty()) // 如果没有压入任何东西返回false
                    return false;

                char topChar = stack.pop(); // 从栈顶弹出与后面的进来的括号匹配
                if (c == ')' && topChar != '(')
                    return false;
                if (c == ']' && topChar != '[')
                    return false;
                if (c == '}' && topChar != '{')
                    return false;
            }
        }
        return stack.isEmpty(); // 栈中是空才成功
    }

    public static void main(String[] args) {
        System.out.println((new Solution()).isValid("()[]{}")); // true
        System.out.println((new Solution()).isValid("([)]"));   // false
    }
}
