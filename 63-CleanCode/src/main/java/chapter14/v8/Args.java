package chapter14.v8;

import java.text.ParseException;
import java.util.*;

/**
 * 14.3 添加 int 类型参数  p201-p205
 * 1、当所有的编组操作都放到了 ArgumentMarshaler 中，我开始向派生类移值功能。第一步是把 setBoolean 函数
 * 放到 BooleanArgumentMarshaler 中，确保它能被正确调用。所以我创建了一个抽象的 set 方法。
 * 2、对于 String 类型也照此处理，即修改 set 和 get 的部署方式，删除无用的函数，并移动变量。
 */
public class Args {
    private String schema;
    private String[] args;
    private boolean valid = true;
    private Set<Character> unexpectedArguments = new TreeSet<Character>();
    private Map<Character, ArgumentMarshaler> booleanArgs = new HashMap<>();
    private Map<Character, ArgumentMarshaler> stringArgs = new HashMap<>();
    private Map<Character, ArgumentMarshaler> intArgs = new HashMap<>();
    private char errorArgumentId;
    private String errorParameter;
    private Set<Character> argsFound = new HashSet<Character>();
    private int currentArgument;
    private char errorArgument = '\0';
    private ErrorCode errorCode = ErrorCode.OK;

    enum ErrorCode {
        OK, MISSING_STRING,
        MISSING_INTEGER, INVALID_INTEGER ;
    }

    //public Args(String schema, String[] args) throws ParseException {
    public Args(String schema, String[] args) throws ParseException, ArgsException {
        this.schema = schema;
        this.args = args;
        valid = parse();
    }

    //private boolean parse() throws ParseException {
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
        booleanArgs.put(elementId, new BooleanArgumentMarshaler());
    }

    private void parseStringSchemaElement(char elementId) {
        stringArgs.put(elementId, new StringArgumentMarshaler());
    }

    private void parseIntegerSchemaElement(char elementId) {
        intArgs.put(elementId, new IntegerArgumentMarshaler());
    }

    //private boolean parseArguments() {
    private boolean parseArguments() throws ArgsException {
        for (currentArgument = 0; currentArgument < args.length; currentArgument++) {
            String arg = args[currentArgument];
            parseArgument(arg);
        }
        return true;
    }

    //private void parseArgument(String arg) {
    private void parseArgument(String arg) throws ArgsException {
        if (arg.startsWith("-"))
            parseElements(arg);
    }

    //private void parseElements(String arg)  {
    private void parseElements(String arg) throws ArgsException {
        for (int i = 1; i < arg.length(); i++)
            parseElement(arg.charAt(i));
    }

    //private void parseElement(char argChar) {
    private void parseElement(char argChar) throws ArgsException {
        if (setArgument(argChar))
            argsFound.add(argChar);
        else {
            unexpectedArguments.add(argChar);
            valid = false;
        }
    }

    //private boolean setArgument(char argChar) {
    private boolean setArgument(char argChar) throws ArgsException {
        boolean set = true;
        if (isBoolean(argChar))
            setBooleanArg(argChar);
        else if (isString(argChar))
            //setStringArg(argChar, "");
            setStringArg(argChar);
        else
            set = false;

        return set;
    }


    private boolean isBoolean(char argChar) {
        return booleanArgs.containsKey(argChar);
    }

    //private void setBooleanArg(char argChar, boolean value) {
    private void setBooleanArg(char argChar) {
        //booleanArgs.get(argChar).setBoolean(value);
        try {
            booleanArgs.get(argChar).set("true");
        } catch (ArgsException e) {
        }
    }

    private boolean isString(char argChar) {
        return stringArgs.containsKey(argChar);
    }

    //private void setStringArg(char argChar, String s) {
    private void setStringArg(char argChar) throws ArgsException {
        currentArgument++;
        try {
            stringArgs.get(argChar).set(args[currentArgument]);
        } catch (ArrayIndexOutOfBoundsException e) {
            valid = false;
            errorArgument = argChar;
            errorCode = ErrorCode.MISSING_STRING;
        }
    }

    // ########### update ###########
    private boolean isIntArg(char argChar) {
        return intArgs.containsKey(argChar);
    }
    // ##############################

    private void setIntArg(char argChar) throws ArgsException {
        currentArgument++;
        String parameter = null;
        try {
            parameter = args[currentArgument];
            //intArgs.get(argChar).setInteger(Integer.parseInt(parameter));
            intArgs.get(argChar).set(parameter);
        } catch (ArrayIndexOutOfBoundsException e) {
            valid = false;
            errorArgumentId = argChar;
            errorCode = ErrorCode.MISSING_INTEGER;
            throw new ArgsException();
        //} catch (NumberFormatException e) {
        } catch (ArgsException e) {
            valid = false;
            errorArgumentId = argChar;
            errorParameter = parameter;
            errorCode = ErrorCode.INVALID_INTEGER;
            //throw new ArgsException();
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
                case MISSING_STRING:
                    return String.format("Could not find string parameter for - %c.", errorArgument);
                case OK:
                    throw new Exception("TILT:Should not get here.");
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
        //return am != null && am.getBoolean();
        return am != null && (Boolean) am.get();
    }

    public String getString(char arg) {
        ArgumentMarshaler am = stringArgs.get(arg);
        //return am == null ? "" : am.getString();
        return am == null ? "" : (String) am.get();
    }

    public int getInt(char arg) {
        ArgumentMarshaler am = intArgs.get(arg);
        //return am == null ? 0 : am.getInteger();
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
        // ########### update ###########
        public abstract void set(String s) throws ArgsException;
        public abstract Object get();
        // ##############################
    }

    private class BooleanArgumentMarshaler extends ArgumentMarshaler {
        // ########### update ###########
        private boolean booleanValue = false;

        @Override
        public void set(String s) throws ArgsException{
            booleanValue = true;
        }

        @Override
        public Object get() {
            return booleanValue;
        }
        // ##############################
    }

    private class StringArgumentMarshaler extends ArgumentMarshaler {
        // ########### update ###########
        private String stringValue = "";

        @Override
        public void set(String s) throws ArgsException{
            stringValue = s;
        }

        @Override
        public Object get() {
            return stringValue;
        }
        // ##############################
    }

    private class IntegerArgumentMarshaler extends ArgumentMarshaler {
        // ########### update ###########
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
        // ##############################
    }

}