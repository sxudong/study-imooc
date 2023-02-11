package com.objectmentor.utilities.args.v1;

import java.util.Iterator;

/**
 * 代码清单 14-4 BooleanArgumentMarshaler.java
 */
public class BooleanArgumentMarshaler implements ArgumentMarshaler {
  private boolean booleanValue = false;
  
  public void set(Iterator<String> currentArgument) throws ArgsException {
    booleanValue = true;
  }

  public static boolean getValue(ArgumentMarshaler am) {
    if (am != null && am instanceof BooleanArgumentMarshaler)
      return ((BooleanArgumentMarshaler) am).booleanValue;
    else
      return false;
  }
}