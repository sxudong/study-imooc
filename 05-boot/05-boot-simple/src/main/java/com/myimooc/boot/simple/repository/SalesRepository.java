package com.myimooc.boot.simple.repository;

import com.myimooc.boot.simple.model.entity.Sales;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SalesRepository extends JpaRepository<Sales, Integer> {
}
