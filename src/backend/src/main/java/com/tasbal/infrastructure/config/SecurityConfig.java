package com.tasbal.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Spring Securityセキュリティ設定クラス。
 *
 * <p>このクラスはアプリケーションのセキュリティポリシーを定義します。
 * 認証、認可、セッション管理、CSRF保護の設定を提供します。</p>
 *
 * <h3>現在の設定（MVP版）:</h3>
 * <ul>
 *   <li>CSRF保護: 無効（REST API用）</li>
 *   <li>セッション管理: ステートレス</li>
 *   <li>認証: すべてのAPIエンドポイントを許可（MVP版）</li>
 *   <li>Swagger UI: アクセス許可</li>
 *   <li>Actuator: アクセス許可</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * セキュリティフィルターチェーンを構成します。
     *
     * <p>HTTP セキュリティの詳細設定を行います。
     * MVP版では全APIエンドポイントへのアクセスを許可していますが、
     * 本番環境では適切な認証・認可を実装する必要があります。</p>
     *
     * @param http HttpSecurity設定ビルダー
     * @return 構成されたSecurityFilterChain
     * @throws Exception セキュリティ設定のビルド時の例外
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/**").permitAll()
                .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/api-docs/**", "/v3/api-docs/**").permitAll()
                .requestMatchers("/api/v1/**").permitAll() // MVP: すべてのAPIを許可
                .anyRequest().authenticated()
            );

        return http.build();
    }
}
