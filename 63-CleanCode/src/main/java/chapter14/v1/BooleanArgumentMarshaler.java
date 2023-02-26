package chapter14.v1;

import java.util.Iterator;

/**
 * 代码清单 14-4 BooleanArgumentMarshaler.java
 */
public class BooleanArgumentMarshaler implements ArgumentMarshaler {
  private boolean booleanValue = false;
  
  public void set(Iterator<String> currentArgument) throws ArgsException {
    // 不获取 -l 参数后的值，数组下标不有移动，下次遍历时不是下一个带“-”的参数，会跳出程序。
    booleanValue = true;
  }

  public static boolean getValue(ArgumentMarshaler am) {
    if (am != null && am instanceof BooleanArgumentMarshaler)
      return ((BooleanArgumentMarshaler) am).booleanValue;
    else
      return false;
  }
}