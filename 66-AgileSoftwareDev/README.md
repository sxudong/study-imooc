# 敏捷软件开发--薪水支付案例

## 用户需求

https://github.com/longfeiyunyue/payrollsalary

+ 有些雇员是钟点工。会按照他们雇员记录中每小时报酬字段的值对他们进行支付。他们每天会提交工作时间卡，其中记录了日期以及工作小时数。如果他们每天工作超过8小时，那么超过的部分会按照正常报酬的1.5倍进行支付。每周五对他们进行支付。
+ 有些雇员完全以月薪进行支付。每个月的最后一个工作日对他们进行支付。在他们的雇员记录中有一个月薪字段。
+ 同时，对于一些带薪（salaried）雇员，会根据他们的销售情况，支付给他们一定数量的酬金（commission）。他们会提交销售凭条，其中记录了销售的日期和数量。在他们的雇员记录中有一个酬金字段。每隔一周的周五对他们进行支付。
+ 雇员可以选择支付方式。可以选择把支付支票邮寄到他们指定的邮政地址；也可以把支票保存在出纳人员那里随时支取；或者要求直接存入他们指定的银行账户。
+ 一些雇员会加入协会。在他们的雇员记录中有一个每周应付款项字段。这些应付款必须要从他们的薪水中扣除。协会有时会针对单个协会成员征收服务费用。协会每周会提交这些服务费用，服务费用必须要从相应雇员的下个月的薪水总额中扣除。
+ 薪水支付程序每个工作日运行一次，并在当天为相应的雇员进行支付。系统会被告知雇员的支付日期，这样他会计算从雇员上次支付日期到规定的本次支付日期间应支付的数额。

## UML 图大致如下：

在整个不断优化的过程中，作者将他的抽象能力展现的淋漓尽致，作为程序员，拼到最后拼的就是抽象能力。

![salary-payment](https://raw.githubusercontent.com/coderlmm/salary-payment/master/uml/salary-payment.jpg)

![](https://raw.githubusercontent.com/coderlmm/salary-payment/master/uml/salary-payment-transaction-1.jpg)

![](https://raw.githubusercontent.com/coderlmm/salary-payment/master/uml/salary-payment-transaction-2.jpg)
