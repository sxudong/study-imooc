package com;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;

public class Test {
    public static void main(String[] args) {
        ArrayList<Integer> a = new ArrayList<>(10);
        System.out.println(a.size());
        a.set(5,2);
    }
	/* 输出：
	  Exception in thread "main" java.lang.NullPointerException
	  	at java.util.Hashtable.put(Hashtable.java:465)
	    at com.Test.main(Test.java:11)
	 */

}








