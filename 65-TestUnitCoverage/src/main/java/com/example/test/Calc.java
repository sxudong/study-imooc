package com.example.test;

public class Calc {
    public int add(int a, int b) {
        if (a == 20) {
            return 20;
        }
        return a + b;
    }

    public int sub(int a, int b) {
        if (a >= b) {
            int i = a - b;
            return i;
        } else {
            return 0;
        }
    }
}