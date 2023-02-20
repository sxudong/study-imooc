/**
 * thisAmount 变得多余
 * 尽量去除一些临时变量，临时变量往往会引发问题，方然这么做也需付出性能上的代价，例如本例的费用就被计算了两次，但是
 * 这很容易在 Rental 类中被优化
 *
 * 提炼 Customer statement() 中的常客积分点数
 */
package chapter1.ver04;