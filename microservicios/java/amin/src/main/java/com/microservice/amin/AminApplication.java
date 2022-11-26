package com.microservice.amin;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;


@SpringBootApplication
@RestController
public class AminApplication {

	@GetMapping("/message")
	public String getMessage() {
		return "Mi primer microservicio";
	}

	public static void main(String[] args) {
		SpringApplication.run(AminApplication.class, args);
	}

}
