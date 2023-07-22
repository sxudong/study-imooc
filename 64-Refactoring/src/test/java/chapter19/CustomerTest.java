package chapter19;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class CustomerTest {

    @Test
    public void statement() throws Exception {
        Customer customer1 = new Customer("顾客1");
        Movie movie1 = new Movie("第一部电影", Movie.CHILDRENS);
        Rental rental1 = new Rental(movie1, 2);
        customer1.addRental(rental1);

        System.out.println(customer1.getName());
        String stmt = customer1.statement();
        System.out.println("------------------");
        System.out.println(stmt);

        String result = "Rental Record for 顾客1\n" +
                "\t第一部电影\t1.5\n" +
                "Amount owed is 1.5\n" +
                "You earned 1 frequent renter points";

        assertEquals("测试时间", result, stmt);
    }

    @Test
    public void testStatement() {
        Customer customer = new Customer("小明");

        Movie movie = new Movie("新片", Movie.NEW_RELEASE);
        Rental rental = new Rental(movie, 5);

        Rental rental1 = new Rental(new Movie("儿童片", Movie.CHILDRENS), 3);
        Rental rental2 = new Rental(new Movie("普通片", Movie.REGULAR), 10);
        customer.addRental(rental);
        customer.addRental(rental1);
        customer.addRental(rental2);
        String statement = customer.statement();

        String consult = "Rental Record For 小明\n" +
                "\t新片\t15.0\n" +
                "\t儿童片\t1.5\n" +
                "\t普通片\t14.0\n" +
                "Amount owed is 30.5\n" +
                "You earned 4 frequent renter points";
        if(consult.equals(statement)) {
            System.out.println("ok");
        }else {
            System.out.println(statement);
        }
    }
}
