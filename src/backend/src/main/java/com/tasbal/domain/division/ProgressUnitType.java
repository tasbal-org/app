// Auto-generated. Do not edit.
// Japanese: 進捗集計単位
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * 進捗の集計単位を表す区分値。
 *
 * <p>バルーンの進捗状況を集計・表示する際の粒度を定義する列挙型です。
 * 個人単位、国単位、全体、日次、イベント単位など、
 * さまざまな集計軸を提供します。
 * </p>
 */
public enum ProgressUnitType {
    /** 個別ユーザー単位の進捗 */
    User(1, "ユーザー", true, 0d, 10),

    /** 国単位での集計進捗 */
    Country(2, "国", false, 0d, 20),

    /** 全ユーザーのグローバル進捗 */
    Global(3, "全体", false, 0d, 30),

    /** UTC基準の日次集計進捗 */
    UtcDay(4, "UTC日", false, 0d, 40),

    /** 特定イベント単位の進捗 */
    Event(5, "イベント", false, 0d, 50);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    ProgressUnitType(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, ProgressUnitType> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(ProgressUnitType::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<ProgressUnitType> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<ProgressUnitType> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(ProgressUnitType::getDisplayOrder)
                .thenComparingInt(ProgressUnitType::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static ProgressUnitType[] arraySorted() {
        List<ProgressUnitType> list = listSorted();
        return list.toArray(new ProgressUnitType[0]);
    }
}
