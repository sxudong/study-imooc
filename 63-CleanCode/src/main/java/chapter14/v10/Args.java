package chapter14.v10;

import java.text.ParseException;
import java.util.*;

/**
 * 14.3 p207-p208
 * 下一步，我开始在 set 函数中使用 marshalers 映射，停止使用另 3 个映射。
 * 从 boolean 开始,然后 String 类型和 Integer。
 */
public class Args {
    private String schema;
    private String[] args;
    private boolean valid = true;
    private Set<Character> unexpectedArguments = new TreeSet<Character>();
    private Map<Character, ArgumentMarshaler> booleanArgs = new HashMap<>();
    private Map<Character, ArgumentMarshaler> stringArgs = new HashMap<>();
    private Map<Character, ArgumentMarshaler> intArgs = new HashMap<>();
    private Map<Character, ArgumentMarshaler> marshalers = new HashMap<>();
    private char errorArgumentId = '\0';
    private String errorParameter;
    private Set<Character> argsFound = new HashSet<Character>();
    private int currentArgument;
    //private char errorArgument = '\0';
    private ErrorCode errorCode = ErrorCode.OK;

    enum ErrorCode {
        OK, MISSING_STRING,
        MISSING_INTEGER, INVALID_INTEGER ;
    }



    public Args(String schema, String[] args) throws ParseException, ArgsException {
        this.schema = schema;
        this.args = args;
        valid = parse();
    }

    private boolean parse() throws ParseException, ArgsException {
        if (schema.length() == 0 && args.length == 0)
            return true;
        parseSchema();
        parseArguments();
        return valid;
    }

    private boolean parseSchema() throws ParseException {
        for (String element : schema.split(",")) {
            if (element.length() > 0) {
                String trimmedElement = element.trim();
                parseSchemaElement(trimmedElement);
            }
        }
        return true;
    }

    private void parseSchemaElement(String element) throws ParseException {
        char elementId = element.charAt(0);
        String elementTail = element.substring(1);
        validateSchemaElementId(elementId);
        if (isBooleanSchemaElement(elementTail))
            parseBooleanSchemaElement(elementId);
        else if (isStringSchemaElement(elementTail))
            parseStringSchemaElement(elementId);
        else if (isIntegerSchemaElement(elementTail))
            parseIntegerSchemaElement(elementId);
    }

    private void validateSchemaElementId(char elementId) throws ParseException {
        if (!Character.isLetter(elementId)) {
            throw new ParseException(
                    "Bad character:" + elementId + "in Args format: " + schema, 0);
        }
    }

    private boolean isStringSchemaElement(String elementTail) {
        return elementTail.equals("*");
    }

    private boolean isBooleanSchemaElement(String elementTail) {
        return elementTail.length() == 0;
    }

    private boolean isIntegerSchemaElement(String elementTail) {
        return elementTail.equals("#");
    }

    private void parseBooleanSchemaElement(char elementId) {
        ArgumentMarshaler m = new BooleanArgumentMarshaler();
        booleanArgs.put(elementId, m);
        marshalers.put(elementId, m);
    }

    private void parseStringSchemaElement(char elementId) {
        ArgumentMarshaler m = new StringArgumentMarshaler();
        stringArgs.put(elementId, m);
        marshalers.put(elementId, m);
    }

    private void parseIntegerSchemaElement(char elementId) {
        ArgumentMarshaler m = new IntegerArgumentMarshaler();
        intArgs.put(elementId, m);
        marshalers.put(elementId, m);
    }

    private boolean parseArguments() throws ArgsException {
        for (currentArgument = 0; currentArgument < args.length; currentArgument++) {
            String arg = args[currentArgument];
            parseArgument(arg);
        }
        return true;
    }

    private void parseArgument(String arg) throws ArgsException {
        if (arg.startsWith("-"))
            parseElements(arg);
    }

    private void parseElements(String arg) throws ArgsException {
        for (int i = 1; i < arg.length(); i++)
            parseElement(arg.charAt(i));
    }

    private void parseElement(char argChar) throws ArgsException {
        if (setArgument(argChar))
            argsFound.add(argChar);
        else {
            unexpectedArguments.add(argChar);
            valid = false;
        }
    }

    private boolean setArgument(char argChar) throws ArgsException {
        ArgumentMarshaler m = marshalers.get(argChar);

        try {
            if (m instanceof BooleanArgumentMarshaler)
                //setBooleanArg(argChar);
                setBooleanArg(m);
            else if (m instanceof StringArgumentMarshaler)
                //setStringArg(argChar);
                setStringArg(m);
            else if (m instanceof IntegerArgumentMarshaler)
                //setIntArg(argChar);
                setIntArg(m);
            else
                return false;
        // ########### update ###########
        } catch (ArgsException e) {
            valid = false;
            errorArgumentId = argChar;
            throw e;
        }
        // ##############################

        return true;
    }

    //private void setBooleanArg(char argChar) {
    private void setBooleanArg(ArgumentMarshaler m) {
        try {
            //booleanArgs.get(argChar).set("true");
            m.set("true");
        } catch (ArgsException e) {
        }
    }

    //private void setStringArg(char argChar) throws ArgsException {
    private void setStringArg(ArgumentMarshaler m) throws ArgsException {
        currentArgument++;
        try {
            //stringArgs.get(argChar).set(args[currentArgument]);
            m.set(args[currentArgument]);
        } catch (ArrayIndexOutOfBoundsException e) {
            //valid = false;
            //errorArgument = argChar;
            errorCode = ErrorCode.MISSING_STRING;
            throw new ArgsException();
        }
    }

    //private void setIntArg(char argChar) throws ArgsException {
    private void setIntArg(ArgumentMarshaler m) throws ArgsException {
        currentArgument++;
        String parameter = null;
        try {
            parameter = args[currentArgument];
            //intArgs.get(argChar).set(parameter);
            m.set(parameter);
        } catch (ArrayIndexOutOfBoundsException e) {
            //valid = false;
            //errorArgumentId = argChar;
            errorCode = ErrorCode.MISSING_INTEGER;
            throw new ArgsException();
        } catch (ArgsException e) {
            //valid = false;
            //errorArgumentId = argChar;
            errorParameter = parameter;
            errorCode = ErrorCode.INVALID_INTEGER;
            throw e;
        }
    }

    public int cardinality() {
        return argsFound.size();
    }

    public String usage() {
        if (schema.length() > 0)
            return "-[" + schema + "]";
        else
            return "";
    }

    public String errorMessage() throws Exception {
        if (unexpectedArguments.size() > 0) {
            return unexpectedArgumentMessage();
        } else
            switch (errorCode) {
                case OK:
                    throw new Exception("TILT:Should not get here.");
                case MISSING_STRING:
                    //return String.format("Could not find string parameter for - %c.", errorArgument);
                    return String.format("Could not find string parameter for - %c.", errorArgumentId);
                // ########### add ###########
                case INVALID_INTEGER:
                    return String.format("Argument -%c expects an integer but was '%s'.", errorArgumentId, errorParameter);
                case MISSING_INTEGER:
                    return String.format("Could not find integer parameter for -%c.", errorArgumentId);
                // ###########################
            }
        return "";
    }

    private String unexpectedArgumentMessage() {
        StringBuffer message = new StringBuffer("Argument(s) -");
        for (char c : unexpectedArguments) {
            message.append(c);
        }
        message.append(" unexpected.");

        return message.toString();
    }

    public boolean getBoolean(char arg) {
        ArgumentMarshaler am = booleanArgs.get(arg);
        return am != null && (Boolean) am.get();
    }

    public String getString(char arg) {
        ArgumentMarshaler am = stringArgs.get(arg);
        return am == null ? "" : (String) am.get();
    }

    public int getInt(char arg) {
        ArgumentMarshaler am = intArgs.get(arg);
        return am == null ? 0 : (Integer) am.get();
    }

    public boolean has(char arg) {
        return argsFound.contains(arg);
    }

    public boolean isValid() {
        return valid;
    }

    class ArgsException extends Exception {
    }

    private abstract class ArgumentMarshaler {
        public abstract void set(String s) throws ArgsException;
        public abstract Object get();
    }

    private class BooleanArgumentMarshaler extends ArgumentMarshaler {
        private boolean booleanValue = false;

        @Override
        public void set(String s) throws ArgsException {
            booleanValue = true;
        }

        @Override
        public Object get() {
            return booleanValue;
        }
    }

    private class StringArgumentMarshaler extends ArgumentMarshaler {
        private String stringValue = "";

        @Override
        public void set(String s) throws ArgsException {
            stringValue = s;
        }

        @Override
        public Object get() {
            return stringValue;
        }
    }

    private class IntegerArgumentMarshaler extends ArgumentMarshaler {
        private int integerValue = 0;
        @Override
        public void set(String s) throws ArgsException {
            try {
                integerValue = Integer.parseInt(s);
            } catch (NumberFormatException e) {
                throw new ArgsException();
            }
        }

        @Override
        public Object get() {
            return integerValue;
        }
    }
}