package com.demo.service;

import com.demo.dao.StudentDao;
import com.demo.model.Student;
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;

public class StudentServiceTest {

    @Test
    public void testGetStudentTotal() {
        StudentDao studentDao = PowerMockito.mock(StudentDao.class);
        PowerMockito.when(studentDao.getTotal()).thenReturn(666);

        StudentService studentService = new StudentService(studentDao);
        int total = studentService.getStudentTotal(studentDao);
        Assert.assertEquals(total, 666);
    }

    @Test
    public void testAddStudentWithMock() {
        StudentDao studentDao = PowerMockito.mock(StudentDao.class);
        Student student = new Student();
        PowerMockito.doNothing().when(studentDao).createStudent(student);

        StudentService studentService = new StudentService(studentDao);
        studentService.addStudent(student);
        // Mockito.verify 主要用来校验被 mock 出来的对象中的某个方法是否被调用
        Mockito.verify(studentDao).createStudent(student);
    }

}