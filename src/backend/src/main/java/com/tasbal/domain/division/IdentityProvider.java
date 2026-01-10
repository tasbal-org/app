// Auto-generated. Do not edit.
// Japanese: 認証プロバイダ
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * 認証プロバイダの種別を表す区分値。
 *
 * <p>ユーザー認証に使用される外部IDプロバイダを識別する列挙型です。
 * Apple、Google、匿名ログインなど、各認証方式を区別します。
 * </p>
 */
public enum IdentityProvider {
    /** Apple ID による認証 */
    Apple(1, "APPLE", true, 0d, 10),

    /** Googleアカウントによる認証 */
    Google(2, "GOOGLE", false, 0d, 20),

    /** 匿名（ゲスト）認証 */
    Anon(3, "ANON", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    IdentityProvider(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, IdentityProvider> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(IdentityProvider::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<IdentityProvider> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<IdentityProvider> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(IdentityProvider::getDisplayOrder)
                .thenComparingInt(IdentityProvider::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static IdentityProvider[] arraySorted() {
        List<IdentityProvider> list = listSorted();
        return list.toArray(new IdentityProvider[0]);
    }
}
