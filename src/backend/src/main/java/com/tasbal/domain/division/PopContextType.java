// Auto-generated. Do not edit.
// Japanese: 割れ要因
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * バルーンが割れる（達成する）要因を表す区分値。
 *
 * <p>バルーンが満タンになって割れる際の、その達成のきっかけとなった
 * 行動の種類を分類する列挙型です。タスク完了、深呼吸、その他の行動を区別します。
 * </p>
 */
public enum PopContextType {
    /** タスク完了によってバルーンが割れた */
    Task(1, "タスク", true, 0d, 10),

    /** 深呼吸の実施によってバルーンが割れた */
    Breath(2, "深呼吸", false, 0d, 20),

    /** その他の要因によってバルーンが割れた */
    Other(3, "その他", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    PopContextType(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, PopContextType> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(PopContextType::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<PopContextType> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<PopContextType> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(PopContextType::getDisplayOrder)
                .thenComparingInt(PopContextType::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static PopContextType[] arraySorted() {
        List<PopContextType> list = listSorted();
        return list.toArray(new PopContextType[0]);
    }
}
