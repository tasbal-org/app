// Auto-generated. Do not edit.
// Japanese: 加算元種別
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * バルーンへの貢献度加算元の種別を表す区分値。
 *
 * <p>バルーンの進捗や達成感に寄与する行動の起源を分類する列挙型です。
 * タスクの完了、深呼吸の実施、システム自動付与、管理者による手動付与など、
 * さまざまな加算元を識別します。
 * </p>
 */
public enum ContributionSourceType {
    /** ユーザーのタスク完了による貢献 */
    Task(1, "タスク", true, 0d, 10),

    /** 深呼吸機能の利用による貢献 */
    Breath(2, "深呼吸", false, 0d, 20),

    /** システムによる自動付与の貢献 */
    System(3, "システム", false, 0d, 30),

    /** 管理者による手動付与の貢献 */
    Admin(4, "管理者", false, 0d, 40);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    ContributionSourceType(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, ContributionSourceType> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(ContributionSourceType::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<ContributionSourceType> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<ContributionSourceType> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(ContributionSourceType::getDisplayOrder)
                .thenComparingInt(ContributionSourceType::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static ContributionSourceType[] arraySorted() {
        List<ContributionSourceType> list = listSorted();
        return list.toArray(new ContributionSourceType[0]);
    }
}
