package com.myimooc.java.security;

public class Assert {
    public static void main(String[] args) {
        assert 1 + 1 == 2;
        System.out.println("assert1 ok");
        assert 1 + 1 == 3 : "assert faild,exit";
        System.out.println("assert2 ok");
    }
} /* Output:
assert1 ok
Exception in thread "main" java.lang.AssertionError: assert faild,exit
	at com.myimooc.java.security.Assert.main(Assert.java:7)
*/
