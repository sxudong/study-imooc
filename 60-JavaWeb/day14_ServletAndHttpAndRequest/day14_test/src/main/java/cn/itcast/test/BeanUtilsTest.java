package cn.itcast.test;

import cn.itcast.domain.User;
import org.apache.commons.beanutils.BeanUtils;
import org.junit.Test;

import java.lang.reflect.InvocationTargetException;

public class BeanUtilsTest {

    @Test
    public void test(){
        User user = new User();
        try {
            BeanUtils.setProperty(user,"gender","male");
            System.out.println(user);

            String gender = BeanUtils.getProperty(user, "gender");
            System.out.println(gender);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
/* Output:
User{id=0, username='null', password='null', gender='male'}
male
 */