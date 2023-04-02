package com.demo.service;

import com.demo.dao.StudentDao;
import com.demo.model.Student;

public class StudentService {
    private StudentDao studentDao;
 
    public StudentService(StudentDao studentDao) {
        this.studentDao = studentDao;
    }

    public int getStudentTotal(StudentDao studentDao) {
        return studentDao.getTotal();
    }

    public void addStudent(Student student) {
        studentDao.createStudent(student);
    }

}