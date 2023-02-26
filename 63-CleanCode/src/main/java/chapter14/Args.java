package chapter14;

import java.util.*;


/**
 * 代码清单 14-16 Args.java 最终代码 p228
 * https://github.com/glen9527/Clean-Code-zh
 *
 *    对 Args 类所做的主要的修改是在监测部分。从 Args 里面取出了大量代码，放到
 * ArgsException 中。很好。我们还把全部 ArgumentMarshaler 转移到了它们自己
 * 的文件中。更好！
 *    优秀的软件设计，大都关乎分隔 —— 创建合适的空间放置不同种类的代码。对关注面的
 * 分隔让代码更易于理解和维护。
 *    特别有意思的是 ArgsException 中的 errorMessage 方法。显然，把错误信息格式
 * 化操作放在 Args 里面，违反了 SRP。 Args 应该只处理参数，而不该去管错误信息的格式。
 * 然而，把错误信息格式化代码放到 ArgsException 中是否有道理呢？
 *    显然，现在我们完成的工作已经非常接近本章开始处所展示的最终解决方案了。最后的工作
 * 留给你来练习完成。
 */
public class Args {
     private String schema;
     private Map<Character, ArgumentMarshaler> marshalers = new HashMap<Character, ArgumentMarshaler>();
     private Set<Character> argsFound = new HashSet<Character>();
     private Iterator<String> currentArgument;
     private List<String> argsList;
 
     public Args(String schema, String[] args) throws ArgsException {
       this.schema = schema;
       argsList = Arrays.asList(args);
       parse();
     }
 
     private void parse() throws ArgsException {
       parseSchema();
       parseArguments();
     }
 
     private boolean parseSchema() throws ArgsException {
       for (String element : schema.split(",")) {
         if (element.length() > 0) {
           parseSchemaElement(element.trim());
         }
       }
       return true;
     }
 
     private void parseSchemaElement(String element) throws ArgsException {
       char elementId = element.charAt(0);
       String elementTail = element.substring(1);
       validateSchemaElementId(elementId);
       if (elementTail.length() == 0)
         marshalers.put(elementId, new BooleanArgumentMarshaler());
       else if (elementTail.equals("*"))
         marshalers.put(elementId, new StringArgumentMarshaler());
       else if (elementTail.equals("#"))
         marshalers.put(elementId, new IntegerArgumentMarshaler());
       else if (elementTail.equals("##"))
         marshalers.put(elementId, new DoubleArgumentMarshaler());
       else
         throw new ArgsException(ArgsException.ErrorCode.INVALID_FORMAT, elementId, elementTail);
     }
 
     private void validateSchemaElementId(char elementId) throws ArgsException {
       if (!Character.isLetter(elementId)) {
         throw new ArgsException(ArgsException.ErrorCode.INVALID_ARGUMENT_NAME, elementId, null);
       }
     }
 
     private void parseArguments() throws ArgsException {
       for (currentArgument = argsList.iterator(); currentArgument.hasNext();) {
         String arg = currentArgument.next();
         parseArgument(arg);
       }
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
         throw new ArgsException(ArgsException.ErrorCode.UNEXPECTED_ARGUMENT, argChar, null);
       }
     }
 
     private boolean setArgument(char argChar) throws ArgsException {
       ArgumentMarshaler m = marshalers.get(argChar);
       if (m == null)
         return false;
       try {
         m.set(currentArgument);
         return true;
       } catch (ArgsException e) {
         e.setErrorArgumentId(argChar);
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
 
     public boolean getBoolean(char arg) {
       ArgumentMarshaler am = marshalers.get(arg);
       boolean b = false;
       try {
         b = am != null && (Boolean) am.get();
       } catch (ClassCastException e) {
         b = false;
       }
       return b;
     }
 
     public String getString(char arg) {
       ArgumentMarshaler am = marshalers.get(arg);
       try {
         return am == null ? "" : (String) am.get();
       } catch (ClassCastException e) {
         return "";
       }
     }
 
     public int getInt(char arg) {
       ArgumentMarshaler am = marshalers.get(arg);
       try {
         return am == null ? 0 : (Integer) am.get();
       } catch (Exception e) {
         return 0;
       }
     }
 

     public double getDouble(char arg) {
       ArgumentMarshaler am = marshalers.get(arg);
       try {
         return am == null ? 0 : (Double) am.get();
       } catch (Exception e) {
         return 0.0;
       }
     }
 
     public boolean has(char arg) {
       return argsFound.contains(arg);
     }
   }