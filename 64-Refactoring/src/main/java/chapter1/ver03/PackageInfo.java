/**
 * amountFor 方法内的变量重命名，将 amountFor 方法移动到 Rental 类中
 * 绝大多数情况下，函数应该放在它所使用的数据的所属对象内
 * 对旧函数 amountFor 修改，测试通过话，如果需要的话去掉旧函数，本例中，变成了直接调用 rental.getCharge()
 */
package chapter1.ver03;