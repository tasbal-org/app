/// Balloon Domain: Balloon Entity
///
/// 風船エンティティ
/// 背景に表示される風船の状態を表現
library;

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/enums/balloon_display_group.dart';
import 'package:tasbal/src/enums/balloon_type.dart';

/// 風船エンティティ
///
/// 背景風船の完全な状態を保持
class Balloon extends Equatable {
  /// 風船ID
  final String id;

  /// 風船タイプ
  final BalloonType type;

  /// 表示グループ（Pinned / Drifting）
  final BalloonDisplayGroup displayGroup;

  /// タイトル（ユーザー作成風船のみ）
  final String? title;

  /// 色（RGB）
  final Color color;

  /// 現在の進捗値
  final int currentValue;

  /// 次の閾値（この値に達すると割れる）
  final int nextThreshold;

  /// 割れた回数
  final int breakCount;

  /// 国コード（ロケーション風船のみ）
  final String? countryCode;

  /// タグアイコンID（ユーザー作成風船のみ）
  final int? tagIconId;

  /// 選択中フラグ
  final bool isSelected;

  /// 作成日時
  final DateTime createdAt;

  const Balloon({
    required this.id,
    required this.type,
    required this.displayGroup,
    this.title,
    required this.color,
    required this.currentValue,
    required this.nextThreshold,
    this.breakCount = 0,
    this.countryCode,
    this.tagIconId,
    this.isSelected = false,
    required this.createdAt,
  });

  /// 進捗率（0.0 ～ 1.0）
  double get progressRatio {
    if (nextThreshold == 0) return 0.0;
    return (currentValue / nextThreshold).clamp(0.0, 1.0);
  }

  /// 基本半径（px）
  double get baseRadius {
    // 設計書: 基本半径 22 ～ 28px
    return 22.0 + (6.0 * (id.hashCode % 100) / 100);
  }

  /// 現在の半径（進捗に応じて膨らむ）
  double get currentRadius {
    // 設計書: 膨らみ最大 +10 ～ +14px
    final maxExpansion = 10.0 + (4.0 * (id.hashCode % 100) / 100);
    return baseRadius + (maxExpansion * progressRatio);
  }

  /// 割れ判定
  bool get shouldBreak => currentValue >= nextThreshold;

  /// ピン留めグループか
  bool get isPinned => displayGroup == BalloonDisplayGroup.Pinned;

  /// 流動グループか
  bool get isDrifting => displayGroup == BalloonDisplayGroup.Drifting;

  @override
  List<Object?> get props => [
        id,
        type,
        displayGroup,
        title,
        color,
        currentValue,
        nextThreshold,
        breakCount,
        countryCode,
        tagIconId,
        isSelected,
        createdAt,
      ];

  /// コピーwith
  Balloon copyWith({
    String? id,
    BalloonType? type,
    BalloonDisplayGroup? displayGroup,
    String? title,
    Color? color,
    int? currentValue,
    int? nextThreshold,
    int? breakCount,
    String? countryCode,
    int? tagIconId,
    bool? isSelected,
    DateTime? createdAt,
  }) {
    return Balloon(
      id: id ?? this.id,
      type: type ?? this.type,
      displayGroup: displayGroup ?? this.displayGroup,
      title: title ?? this.title,
      color: color ?? this.color,
      currentValue: currentValue ?? this.currentValue,
      nextThreshold: nextThreshold ?? this.nextThreshold,
      breakCount: breakCount ?? this.breakCount,
      countryCode: countryCode ?? this.countryCode,
      tagIconId: tagIconId ?? this.tagIconId,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
