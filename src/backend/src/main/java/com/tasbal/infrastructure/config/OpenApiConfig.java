package com.tasbal.infrastructure.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI（Swagger）設定クラス。
 *
 * <p>このクラスはSwagger UIのAPIドキュメント生成設定を提供します。
 * 開発者がREST APIの仕様を確認・テストできるようにします。</p>
 *
 * <h3>提供される機能:</h3>
 * <ul>
 *   <li>APIメタデータの定義（タイトル、説明、バージョン）</li>
 *   <li>Swagger UI用のOpenAPI仕様の生成</li>
 *   <li>APIドキュメントのカスタマイズ</li>
 * </ul>
 *
 * <p>Swagger UIは {@code /swagger-ui.html} でアクセス可能です。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Configuration
public class OpenApiConfig {

    /**
     * OpenAPI設定を構成します。
     *
     * <p>Swagger UIで表示されるAPI仕様のメタデータを定義します。
     * タイトル、説明、バージョン、ライセンス情報を含みます。</p>
     *
     * @return 構成されたOpenAPIオブジェクト
     */
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
