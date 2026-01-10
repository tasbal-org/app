package com.tasbal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Tasbalバックエンドアプリケーションのメインクラス。
 *
 * <p>Tasbalは「個人のタスク達成が、みんなの達成感につながる」をコンセプトとした
 * 共有バルーン型タスク管理アプリケーションです。</p>
 *
 * <h3>アーキテクチャ:</h3>
 * <ul>
 *   <li>Backend: Java 21 / Spring Boot</li>
 *   <li>Database: PostgreSQL（ストアドプロシージャ経由でアクセス）</li>
 *   <li>Frontend: Flutter</li>
 *   <li>設計パターン: ドメイン駆動設計（DDD）</li>
 * </ul>
 *
 * <h3>主要機能:</h3>
 * <ul>
 *   <li>タスク管理（作成、更新、完了、アーカイブ）</li>
 *   <li>風船システム（タスク達成による貢献と共有体験）</li>
 *   <li>ユーザー認証・設定管理</li>
 *   <li>タグによるタスク分類</li>
 * </ul>
 *
 * <p>このクラスはSpring Bootアプリケーションのエントリーポイントとして、
 * コンポーネントスキャンと自動設定を有効化します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see SpringBootApplication
 */
@SpringBootApplication
public class TasbalBackendApplication {

    /**
     * アプリケーションのメインメソッド。
     *
     * <p>Spring Bootアプリケーションを起動し、組み込みサーバーを開始します。
     * 起動時に自動的に以下が実行されます:</p>
     * <ul>
     *   <li>コンポーネントスキャンによるBeanの登録</li>
     *   <li>データベース接続の確立</li>
     *   <li>REST APIエンドポイントの公開</li>
     *   <li>設定ファイル（application.yml）の読み込み</li>
     * </ul>
     *
     * @param args コマンドライン引数
     */
    public static void main(String[] args) {
        SpringApplication.run(TasbalBackendApplication.class, args);
    }

}
