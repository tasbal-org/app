package com.tasbal.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

/**
 * データベース接続設定クラス。
 *
 * <p>このクラスはSpring JDBCとトランザクション管理の設定を提供します。
 * PostgreSQLデータベースへの接続とトランザクション境界の管理を担当します。</p>
 *
 * <h3>提供される機能:</h3>
 * <ul>
 *   <li>JdbcTemplateの構成（ストアドプロシージャ/ファンクション実行用）</li>
 *   <li>トランザクションマネージャーの構成</li>
 *   <li>宣言的トランザクション管理の有効化</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Configuration
@EnableTransactionManagement
public class DatabaseConfig {

    /**
     * JdbcTemplateを構成します。
     *
     * <p>ストアドプロシージャやストアドファンクションの実行に使用される
     * JdbcTemplateインスタンスを生成します。</p>
     *
     * @param dataSource データソース（自動注入）
     * @return 構成されたJdbcTemplate
     */
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    /**
     * トランザクションマネージャーを構成します。
     *
     * <p>宣言的トランザクション管理（@Transactional）で使用される
     * トランザクションマネージャーを生成します。</p>
     *
     * @param dataSource データソース（自動注入）
     * @return 構成されたPlatformTransactionManager
     */
    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}
