/// Tag Icon Enum
///
/// 風船のタグアイコン（12種類の抽象シンボル）
/// 視覚デザイン仕様書に基づく
library;

import 'package:equatable/equatable.dart';

/// タグアイコン
///
/// USER風船のmembership有効時に表示される
/// 意味を持たない抽象的なシンボル
class TagIcon extends Equatable {
  /// 区分値
  final int value;

  /// 表示名
  final String displayName;

  /// アイコンシンボル
  final String symbol;

  /// ソート順
  final int sortOrder;

  const TagIcon(
    this.value,
    this.displayName,
    this.symbol,
    this.sortOrder,
  );

  /// 円
  static const TagIcon circle = TagIcon(1, '円', '○', 10);

  /// 四角
  static const TagIcon square = TagIcon(2, '四角', '□', 20);

  /// 三角
  static const TagIcon triangle = TagIcon(3, '三角', '△', 30);

  /// 星
  static const TagIcon star = TagIcon(4, '星', '☆', 40);

  /// ハート
  static const TagIcon heart = TagIcon(5, 'ハート', '♡', 50);

  /// ダイヤ
  static const TagIcon diamond = TagIcon(6, 'ダイヤ', '◇', 60);

  /// 六角形
  static const TagIcon hexagon = TagIcon(7, '六角形', '⬡', 70);

  /// クロス
  static const TagIcon cross = TagIcon(8, 'クロス', '+', 80);

  /// 波
  static const TagIcon wave = TagIcon(9, '波', '〜', 90);

  /// ドット
  static const TagIcon dot = TagIcon(10, 'ドット', '・', 100);

  /// リング
  static const TagIcon ring = TagIcon(11, 'リング', '◎', 110);

  /// 花
  static const TagIcon flower = TagIcon(12, '花', '✿', 120);

  /// 全アイコンリスト
  static const List<TagIcon> values = [
    circle,
    square,
    triangle,
    star,
    heart,
    diamond,
    hexagon,
    cross,
    wave,
    dot,
    ring,
    flower,
  ];

  /// 区分値から取得
  static TagIcon fromValue(int value) {
    return values.firstWhere(
      (icon) => icon.value == value,
      orElse: () => circle,
    );
  }

  /// ソート順でリスト取得
  static List<TagIcon> get listSorted {
    final sorted = List<TagIcon>.from(values);
    sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted;
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => displayName;
}
