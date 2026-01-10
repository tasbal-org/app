// Auto-generated. Do not edit.
// Japanese: 表示グループ
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * バルーンの表示グループを表す区分値。
 *
 * <p>画面上でのバルーンの配置や表示方法を分類するための列挙型です。
 * ピン留めされた固定位置のバルーンと、画面上を漂うバルーンを区別します。
 * </p>
 */
public enum BalloonDisplayGroup {
    /** ピン留めされた固定位置のバルーン */
    Pinned(1, "ピン留め", true, 0d, 10),

    /** 画面上を漂う動的なバルーン */
    Drifting(2, "漂う", false, 0d, 20);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    BalloonDisplayGroup(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, BalloonDisplayGroup> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(BalloonDisplayGroup::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<BalloonDisplayGroup> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<BalloonDisplayGroup> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(BalloonDisplayGroup::getDisplayOrder)
                .thenComparingInt(BalloonDisplayGroup::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static BalloonDisplayGroup[] arraySorted() {
        List<BalloonDisplayGroup> list = listSorted();
        return list.toArray(new BalloonDisplayGroup[0]);
    }
}
