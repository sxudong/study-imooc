package chapter14.v1;

import java.util.Iterator;

public class DoubleArgumentMarshaler implements ArgumentMarshaler{

    public static double getValue(ArgumentMarshaler argumentMarshaler) {
        return 1.00;
    }

    @Override
    public void set(Iterator<String> currentArgument) throws ArgsException {

    }
}
