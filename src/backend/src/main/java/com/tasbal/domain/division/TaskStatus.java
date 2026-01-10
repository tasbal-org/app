// Auto-generated. Do not edit.
// Japanese: タスク状態
// Generated: 2026-01-09 21:34:29

package com.tasbal.domain.division;

import java.util.*;
import java.util.stream.*;

/**
 * タスクの進行状態を表す区分値。
 *
 * <p>ユーザーのタスクが現在どの段階にあるかを管理する列挙型です。
 * 未着手、進行中、完了、アーカイブのライフサイクルを表現します。
 * </p>
 */
public enum TaskStatus {
    /** まだ開始していないタスク */
    Todo(1, "未着手", true, 0d, 10),

    /** 作業中のタスク */
    InProgress(2, "進行中", false, 0d, 20),

    /** 完了したタスク */
    Done(3, "完了", false, 0d, 30),

    /** アーカイブされたタスク（非表示） */
    Archived(4, "アーカイブ", false, 0d, 40);

    private final int value;
    private final String displayName;
    private final boolean isDefault;
    private final double numericValue;
    private final int displayOrder;

    TaskStatus(int value, String displayName, boolean isDefault, double numericValue, int displayOrder) {
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

    private static final Map<Integer, TaskStatus> BY_VALUE = Arrays.stream(values())
        .collect(Collectors.toUnmodifiableMap(TaskStatus::getValue, e -> e));

    /**
     * 区分値コードから対応する列挙値を取得します。
     *
     * @param value 区分値コード
     * @return 対応する列挙値（存在しない場合は空のOptional）
     */
    public static Optional<TaskStatus> fromValue(int value) {
        return Optional.ofNullable(BY_VALUE.get(value));
    }

    /**
     * すべての列挙値を表示順序でソートしたリストを取得します。
     *
     * @return 表示順序でソートされた列挙値のリスト
     */
    public static List<TaskStatus> listSorted() {
        return Arrays.stream(values())
            .sorted(Comparator.comparingInt(TaskStatus::getDisplayOrder)
                .thenComparingInt(TaskStatus::getValue))
            .collect(Collectors.toUnmodifiableList());
    }

    /**
     * すべての列挙値を表示順序でソートした配列を取得します。
     *
     * @return 表示順序でソートされた列挙値の配列
     */
    public static TaskStatus[] arraySorted() {
        List<TaskStatus> list = listSorted();
        return list.toArray(new TaskStatus[0]);
    }
}
