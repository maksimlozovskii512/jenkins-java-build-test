package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String home() {
        return "Spring Boot Demo is running";
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Jenkins build pipeline";
    }
}