// Auto-generated. Do not edit.
// Japanese: 描画品質
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * アプリケーションの描画品質設定を表す区分値。
 *
 * <p>バルーンやアニメーションの描画品質レベルを管理する列挙型です。
 * 端末のスペックや設定に応じて、自動選択、通常品質、低品質を切り替えます。
 * </p>
 */
public enum RenderQuality {
    /** 端末のスペックに応じて自動的に品質を選択 */
    Auto(1, "自動", true, 0d, 10),

    /** 標準的な描画品質 */
    Normal(2, "通常", false, 0d, 20),

    /** パフォーマンス重視の低品質描画 */
    Low(3, "低品質", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    RenderQuality(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, RenderQuality> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(RenderQuality::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<RenderQuality> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<RenderQuality> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(RenderQuality::getDisplayOrder)
                .thenComparingInt(RenderQuality::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static RenderQuality[] arraySorted() {
        List<RenderQuality> list = listSorted();
        return list.toArray(new RenderQuality[0]);
    }
}
