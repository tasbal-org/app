// Auto-generated. Do not edit.
// Japanese: 端末種別
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * デバイスのプラットフォーム種別を表す区分値。
 *
 * <p>ユーザーがアクセスしているデバイスの種類を識別するための列挙型です。
 * iOS、Android、Webブラウザの各プラットフォームを区別し、
 * プラットフォーム固有の処理や統計情報の収集に使用されます。
 * </p>
 */
public enum DevicePlatform {
    /** Apple iOSデバイス（iPhone、iPad等） */
    IOS(1, "iOS", true, 0d, 10),

    /** Androidデバイス */
    Android(2, "Android", false, 0d, 20),

    /** Webブラウザからのアクセス */
    Web(3, "Web", false, 0d, 30);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    DevicePlatform(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, DevicePlatform> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(DevicePlatform::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<DevicePlatform> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<DevicePlatform> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(DevicePlatform::getDisplayOrder)
                .thenComparingInt(DevicePlatform::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static DevicePlatform[] arraySorted() {
        List<DevicePlatform> list = listSorted();
        return list.toArray(new DevicePlatform[0]);
    }
}
