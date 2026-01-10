// Auto-generated. Do not edit.
// Japanese: ユーザープラン
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * ユーザーの課金プランを表す区分値。
 *
 * <p>ユーザーが利用している料金プランの種類を管理する列挙型です。
 * 無料プランと有料プロプランを区別し、機能制限やアクセス制御に使用されます。
 * </p>
 */
public enum UserPlan {
    /** 無料プラン */
    Free(1, "FREE", true, 0d, 10),

    /** 有料のプロプラン */
    Pro(2, "PRO", false, 0d, 20);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    UserPlan(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, UserPlan> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(UserPlan::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<UserPlan> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<UserPlan> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(UserPlan::getDisplayOrder)
                .thenComparingInt(UserPlan::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static UserPlan[] arraySorted() {
        List<UserPlan> list = listSorted();
        return list.toArray(new UserPlan[0]);
    }
}
