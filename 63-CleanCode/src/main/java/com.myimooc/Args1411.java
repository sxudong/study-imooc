package com.myimooc;

import java.text.ParseException;
import java.util.*;

public class Args1411 {
    private String schema;
    private List<String> argsList;
    private boolean valid = true;
    private Set<Character> unexpectArguments = new TreeSet<>();
    private Map<Character, ArgumentMarshaler> argumentMarshaler = new HashMap<>();
    private Set<Character> argsFound = new HashSet<>();
    private Iterator<String> currentArgument;
    private ArgsException.ErrorCode errorCode = ArgsException.ErrorCode.OK;


    public Args1411(String schema, String[] args) throws ParseException {
        this.schema = schema;
        this.argsList = Arrays.asList(args);
        valid = parse();
    }

    private boolean parse() throws ParseException {
        if (schema.length() == 0 && argsList.size() == 0) return true;
        parseSchema();
        parseArguments();
        return valid;
    }

    private boolean parseSchema() throws ParseException {
        for (String element : schema.split(",")) {
            if (element.length() > 0) {
                String trimElement = element.trim();
                parseSchemaElement(trimElement);
            }
        }
        return true;
    }

    private void parseSchemaElement(String element) throws ParseException {
        char elementId = element.charAt(0);
        String elementTail = element.substring(1);
        validateSchemaElementId(elementId);
        if (elementTail.length() == 0)
            argumentMarshaler.put(elementId, new BooleanArgumentMarshaler());
        else if ("*".equals(elementTail))
            argumentMarshaler.put(elementId, new StringArgumentMarshaler());
        else if ("#".equals(elementTail))
            argumentMarshaler.put(elementId, new IntegerArgumentMarshaler());

    }

    private void validateSchemaElementId(char elementId) throws ParseException {
        if (!Character.isLetter(elementId)) {
            throw new ParseException("Bad character:" + elementId + "in Args format: " + schema, 0);
        }
    }

    private boolean parseArguments() {
        for (currentArgument = argsList.iterator(); currentArgument.hasNext(); ) {
            String arg = currentArgument.next();
            parseArgument(arg);
        }
        return true;
    }

    private void parseArgument(String arg) {
        if (arg.startsWith("-")) {
            parseElements(arg);
        }
    }

    private void parseElements(String arg) {
        for (int i = 1; i < arg.length(); i++) {
            parseElement(arg.charAt(i));
        }
    }

    private void parseElement(char argChar) {
        if (setArgument(argChar)) {
            argsFound.add(argChar);
        } else {
            unexpectArguments.add(argChar);
            valid = false;
        }
    }

    private boolean setArgument(char argChar) {
        boolean set = true;
        ArgumentMarshaler marshaler = this.argumentMarshaler.get(argChar);
        if (marshaler == null) return false;
        try {
            marshaler.set(currentArgument);
        } catch (ArgsException e) {
            errorCode = e.getErrorCode();
            valid = false;
        }
        return set;
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
        if (unexpectArguments.size() > 0)
            return unexpectArgumentsMessage();
        else
            switch (errorCode) {
                case MISSING_STRING:
                    return "Could not find string paramenter for -%c.";
                //其他的省略
                case OK:
                    throw new Exception("TILT: should not get here.");
            }
        return "";

    }

    private String unexpectArgumentsMessage() {
        StringBuffer message = new StringBuffer("Argument(s) -");
        for (Character c : unexpectArguments) {
            message.append(c);
        }
        message.append("  unexpected.");
        return message.toString();
    }

    public boolean getBoolean(char arg) {
        ArgumentMarshaler am = argumentMarshaler.get(arg);
        boolean b;
        try {
            b = am != null && (boolean) am.get();
        } catch (ClassCastException e) {
            b = false;
        }
        return b;
    }


    public String getString(char arg) {
        ArgumentMarshaler am = argumentMarshaler.get(arg);
        return am == null ? "" : (String) am.get();
    }

    public String blankIfNull(String s) {
        return s == null ? "" : s;
    }

    public Integer getInteger(char arg) {
        ArgumentMarshaler am = argumentMarshaler.get(arg);
        return am == null ? 0 : (Integer) am.get();
    }

    public boolean has(char arg) {
        return argsFound.contains(arg);
    }

    public boolean isValid() {
        return valid;
    }
}

