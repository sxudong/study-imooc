package com.myimooc.java.security;

public class TestAssert{
     public static void main(String[] args){
         //String name = "abner chai";
         String name = null;
         assert (name != null):"变量name为空null";
         System.out.println(name);
     }
}
/* Output:
Exception in thread "main" java.lang.AssertionError: 变量name为空null
	at com.myimooc.java.security.TestAssert.main(TestAssert.java:7)
 */