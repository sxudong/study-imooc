package design.pattern.behavioral.interpreter.example;

import java.util.Map;

public interface Expression {
    boolean interpret(Map<String, Long> stats);
}