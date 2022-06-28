package com.myimooc.boot.simple.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ConcurrentController {
    @GetMapping("/test")
    @ResponseBody
    public String testPostmanConcurrent(){
        return "test";
    }
}
