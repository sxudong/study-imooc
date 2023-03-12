package com.example.test;
 
public class Calculator {
    public int add(int a, int b) {
        if (a< 10 || b < 10){
 
            int i = a + b;
            return i;
        } else {
            return 0;
        }
    }
 
    public int subtraction(int a, int b) {
        if (a>=b){
            int i = a - b;
            return i;
        } else {
            return 0;
        }
    }
 
}