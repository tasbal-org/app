// Auto-generated. Do not edit.
// Japanese: 公開区分
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * バルーンの公開範囲を表す区分値。
 *
 * <p>バルーンの可視性とアクセス制御を管理するための列挙型です。
 * システム提供のバルーン、個人用の非公開バルーン、他ユーザーに公開するバルーンを区別します。
 * </p>
 */
public enum BalloonVisibility {
    /** システムが提供する標準バルーン */
    System(1, "システム", true, 0d, 10),

    /** 個人専用の非公開バルーン */
    Private_(2, "非公開", false, 0d, 20),

    /** 他ユーザーにも公開されるバルーン */
    Public_(3, "公開", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    BalloonVisibility(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, BalloonVisibility> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(BalloonVisibility::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<BalloonVisibility> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<BalloonVisibility> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(BalloonVisibility::getDisplayOrder)
                .thenComparingInt(BalloonVisibility::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static BalloonVisibility[] arraySorted() {
        List<BalloonVisibility> list = listSorted();
        return list.toArray(new BalloonVisibility[0]);
    }
}
