// Auto-generated. Do not edit.
// Japanese: 風船タイプ
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * バルーンのタイプを表す区分値。
 *
 * <p>Tasbalアプリケーション内で使用されるバルーンの種類を分類する列挙型です。
 * グローバル共有バルーンから個人用バルーン、特殊なイベントバルーンまで、
 * さまざまなバルーンタイプを表現します。
 * </p>
 */
public enum BalloonType {
    /** 全ユーザーで共有されるグローバルバルーン */
    Global(1, "グローバル風船", true, 0d, 10),

    /** 特定の地理的位置に紐づくバルーン */
    Location(2, "ロケーション風船", false, 0d, 20),

    /** 深呼吸機能に関連するバルーン */
    Breath(3, "深呼吸風船", false, 0d, 30),

    /** ユーザーが作成したカスタムバルーン */
    User(4, "ユーザー作成風船", false, 0d, 40),

    /** 期間限定のゲリラ的に出現するイベントバルーン */
    Guerrilla(5, "ゲリラ風船", false, 0d, 50);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    BalloonType(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, BalloonType> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(BalloonType::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<BalloonType> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<BalloonType> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(BalloonType::getDisplayOrder)
                .thenComparingInt(BalloonType::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static BalloonType[] arraySorted() {
        List<BalloonType> list = listSorted();
        return list.toArray(new BalloonType[0]);
    }
}
