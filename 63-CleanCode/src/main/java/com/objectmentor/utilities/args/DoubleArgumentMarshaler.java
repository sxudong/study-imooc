package com.objectmentor.utilities.args;

import java.util.Iterator;

public class DoubleArgumentMarshaler implements ArgumentMarshaler {
    private double doubleValue = 0;

    public static double getValue(ArgumentMarshaler argumentMarshaler) {
        return 1.00;
    }

    @Override
    public void set(Iterator<String> currentArgument) throws ArgsException {
        String parameter = null;
        try {
            parameter = currentArgument.next();
            doubleValue = Double.parseDouble(parameter);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Object get() {
        return doubleValue;
    }
}
