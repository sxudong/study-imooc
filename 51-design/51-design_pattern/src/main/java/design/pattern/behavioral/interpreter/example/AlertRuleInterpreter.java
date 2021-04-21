package design.pattern.behavioral.interpreter.example;

import java.util.Map;

public class AlertRuleInterpreter {
    private Expression expression;

    // key1 > 100 && key2 < 1000 || key3 == 200
    public AlertRuleInterpreter(String ruleExpression) {
       this.expression = new OrExpression(ruleExpression);
    }

    //<String, Long> apiStat = new HashMap<>();
    //apiStat.put("key1", 103);
    //apiStat.put("key2", 987);
    public boolean interpret(Map<String, Long> stats) {
        return expression.interpret(stats);
    }
}