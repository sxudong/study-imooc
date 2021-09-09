import dao.UserDao;
import dao.impl.UserDaoImpl;
import domain.User;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class test {
    @Test
    public void tese1() {
        List<User> list = new ArrayList<User>();
        UserDao us = new UserDaoImpl();
        list = us.findAll();
        System.out.println(list);
    }
}
