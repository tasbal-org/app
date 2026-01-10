// Auto-generated. Do not edit.
// Japanese: 認証状態
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * 認証状態を表す区分値。
 *
 * <p>ユーザーの認証ステータスを管理するための列挙型です。
 * ゲスト状態から認証プロバイダとの連携状態、無効化された状態までを表現します。
 * </p>
 */
public enum AuthState {
    /** ゲスト状態（未認証） */
    Guest(1, "ゲスト", true, 0d, 10),

    /** 認証プロバイダと連携済み */
    Linked(2, "連携済み", false, 0d, 20),

    /** アカウント無効化状態 */
    Disabled(3, "無効", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    AuthState(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
        this.value = value;
        this.displayName = displayName;
        this.isDefault = isDefault;
        this.numericValue = numericValue;
        this.displayOrder = displayOrder;
    }

    /**
     * 区分値コード（整数値）を取得します。
     *
     * @return 区分値コード
     */
    public int getValue() { return value; }

    /**
     * 表示名を取得します。
     *
     * @return 表示名
     */
    public String getDisplayName() { return displayName; }

    /**
     * デフォルト値かどうかを取得します。
     *
     * @return デフォルト値の場合true
     */
    public boolean isDefault() { return isDefault; }

    /**
     * 数値値を取得します。
     *
     * @return 数値値
     */
    public double getNumericValue() { return numericValue; }

    /**
     * 表示順序を取得します。
     *
     * @return 表示順序
     */
    public int getDisplayOrder() { return displayOrder; }

    private static final Map<Integer, AuthState> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(AuthState::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<AuthState> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<AuthState> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(AuthState::getDisplayOrder)
                .thenComparingInt(AuthState::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static AuthState[] arraySorted() {
        List<AuthState> list = listSorted();
        return list.toArray(new AuthState[0]);
    }
}
