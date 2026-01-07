package com.tasbal.backend.infrastructure.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI tasbalOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Tasbal API")
                        .description("タスク管理アプリ「Tasbal」のバックエンド REST API")
                        .version("v1.0.0")
                        .license(new License()
                                .name("Private")
                                .url("https://tasbal.com")));
    }
}
