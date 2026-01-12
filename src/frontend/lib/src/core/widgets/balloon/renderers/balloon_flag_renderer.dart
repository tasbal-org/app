/// Balloon Flag Renderer
///
/// 風船の本体に国旗パターンを描画
/// ロケーション風船用
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 国旗コード
enum FlagCode {
  jp, // 日本
  us, // アメリカ
  gb, // イギリス
  fr, // フランス
  de, // ドイツ
  it, // イタリア
  ca, // カナダ
  br, // ブラジル
  kr, // 韓国
  cn, // 中国
  au, // オーストラリア
  es, // スペイン
  mx, // メキシコ
  in_, // インド
  ru, // ロシア
}

/// 国旗レンダラー
class BalloonFlagRenderer {
  const BalloonFlagRenderer();

  /// 風船形状にクリップした国旗を描画
  void render({
    required Canvas canvas,
    required Path balloonPath,
    required Rect bounds,
    required FlagCode flagCode,
  }) {
    canvas.save();
    canvas.clipPath(balloonPath);

    _drawFlagPattern(canvas, bounds, flagCode);

    // オーバーレイ（立体感を出すためのシェーディング）
    _drawOverlay(canvas, bounds);

    canvas.restore();
  }

  /// 国旗パターンを描画
  void _drawFlagPattern(Canvas canvas, Rect bounds, FlagCode flagCode) {
    final x = bounds.left;
    final y = bounds.top;
    final w = bounds.width;
    final h = bounds.height;

    // 背景を白で塗る
    canvas.drawRect(bounds, Paint()..color = Colors.white);

    switch (flagCode) {
      case FlagCode.jp:
        _drawJapanFlag(canvas, x, y, w, h);
      case FlagCode.us:
        _drawUsaFlag(canvas, x, y, w, h);
      case FlagCode.gb:
        _drawUkFlag(canvas, x, y, w, h);
      case FlagCode.fr:
        _drawFranceFlag(canvas, x, y, w, h);
      case FlagCode.de:
        _drawGermanyFlag(canvas, x, y, w, h);
      case FlagCode.it:
        _drawItalyFlag(canvas, x, y, w, h);
      case FlagCode.ca:
        _drawCanadaFlag(canvas, x, y, w, h);
      case FlagCode.br:
        _drawBrazilFlag(canvas, x, y, w, h);
      case FlagCode.kr:
        _drawKoreaFlag(canvas, x, y, w, h);
      case FlagCode.cn:
        _drawChinaFlag(canvas, x, y, w, h);
      case FlagCode.au:
        _drawAustraliaFlag(canvas, x, y, w, h);
      case FlagCode.es:
        _drawSpainFlag(canvas, x, y, w, h);
      case FlagCode.mx:
        _drawMexicoFlag(canvas, x, y, w, h);
      case FlagCode.in_:
        _drawIndiaFlag(canvas, x, y, w, h);
      case FlagCode.ru:
        _drawRussiaFlag(canvas, x, y, w, h);
    }
  }

  /// オーバーレイ（シェーディング）
  void _drawOverlay(Canvas canvas, Rect bounds) {
    final gradient = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 1.0,
      colors: [
        Colors.white.withValues(alpha: 0.4),
        Colors.white.withValues(alpha: 0.0),
        Colors.black.withValues(alpha: 0.1),
        Colors.black.withValues(alpha: 0.3),
      ],
      stops: const [0.0, 0.3, 0.8, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(bounds);
    canvas.drawRect(bounds, paint);
  }

  // ====== 各国旗の描画メソッド ======

  /// 日本国旗
  void _drawJapanFlag(Canvas canvas, double x, double y, double w, double h) {
    // 白背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = Colors.white,
    );

    // 赤い円
    final center = Offset(x + w / 2, y + h / 2 - h * 0.1);
    final radius = min(w, h) * 0.3;
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFFBC002D),
    );
  }

  /// アメリカ国旗
  void _drawUsaFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeH = h / 13;

    // ストライプ
    for (int i = 0; i < 13; i++) {
      final color = i % 2 == 0 ? const Color(0xFFB22234) : Colors.white;
      canvas.drawRect(
        Rect.fromLTWH(x, y + i * stripeH, w, stripeH),
        Paint()..color = color,
      );
    }

    // カントン（青い部分）
    final cantonW = w * 0.45;
    final cantonH = stripeH * 7;
    canvas.drawRect(
      Rect.fromLTWH(x, y, cantonW, cantonH),
      Paint()..color = const Color(0xFF3C3B6E),
    );

    // 星（簡略化）
    final starPaint = Paint()..color = Colors.white;
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 6; col++) {
        canvas.drawCircle(
          Offset(x + 8 + col * 12, y + 8 + row * 10),
          2,
          starPaint,
        );
      }
    }
  }

  /// イギリス国旗（ユニオンジャック）
  void _drawUkFlag(Canvas canvas, double x, double y, double w, double h) {
    // 青背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF012169),
    );

    // 白い対角線
    final whiteDiag = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.15;

    canvas.drawLine(Offset(x, y), Offset(x + w, y + h), whiteDiag);
    canvas.drawLine(Offset(x + w, y), Offset(x, y + h), whiteDiag);

    // 赤い対角線
    final redDiag = Paint()
      ..color = const Color(0xFFC8102E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05;

    canvas.drawLine(Offset(x, y), Offset(x + w, y + h), redDiag);
    canvas.drawLine(Offset(x + w, y), Offset(x, y + h), redDiag);

    // 白い十字
    final crossW = w * 0.2;
    canvas.drawRect(
      Rect.fromLTWH(x + w / 2 - crossW / 2, y, crossW, h),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + h / 2 - crossW / 2, w, crossW),
      Paint()..color = Colors.white,
    );

    // 赤い十字
    final redCrossW = w * 0.12;
    canvas.drawRect(
      Rect.fromLTWH(x + w / 2 - redCrossW / 2, y, redCrossW, h),
      Paint()..color = const Color(0xFFC8102E),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + h / 2 - redCrossW / 2, w, redCrossW),
      Paint()..color = const Color(0xFFC8102E),
    );
  }

  /// フランス国旗
  void _drawFranceFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeW = w / 3;

    canvas.drawRect(
      Rect.fromLTWH(x, y, stripeW, h),
      Paint()..color = const Color(0xFF0055A4),
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW, y, stripeW, h),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW * 2, y, stripeW, h),
      Paint()..color = const Color(0xFFEF4135),
    );
  }

  /// ドイツ国旗
  void _drawGermanyFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeH = h / 3;

    canvas.drawRect(
      Rect.fromLTWH(x, y, w, stripeH),
      Paint()..color = Colors.black,
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH, w, stripeH),
      Paint()..color = const Color(0xFFDD0000),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH * 2, w, stripeH),
      Paint()..color = const Color(0xFFFFCE00),
    );
  }

  /// イタリア国旗
  void _drawItalyFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeW = w / 3;

    canvas.drawRect(
      Rect.fromLTWH(x, y, stripeW, h),
      Paint()..color = const Color(0xFF009246),
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW, y, stripeW, h),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW * 2, y, stripeW, h),
      Paint()..color = const Color(0xFFCE2B37),
    );
  }

  /// カナダ国旗
  void _drawCanadaFlag(Canvas canvas, double x, double y, double w, double h) {
    final redColor = const Color(0xFFFF0000);

    // 左右の赤いバー
    final barW = w * 0.25;
    canvas.drawRect(Rect.fromLTWH(x, y, barW, h), Paint()..color = redColor);
    canvas.drawRect(
      Rect.fromLTWH(x + w - barW, y, barW, h),
      Paint()..color = redColor,
    );

    // 中央の白
    canvas.drawRect(
      Rect.fromLTWH(x + barW, y, w - barW * 2, h),
      Paint()..color = Colors.white,
    );

    // メープルリーフ（簡略化）
    final leafPaint = Paint()..color = redColor;
    final cx = x + w / 2;
    final cy = y + h / 2;
    final leafSize = min(w, h) * 0.25;

    final path = Path()
      ..moveTo(cx, cy - leafSize)
      ..lineTo(cx + leafSize * 0.3, cy)
      ..lineTo(cx + leafSize, cy - leafSize * 0.2)
      ..lineTo(cx + leafSize * 0.5, cy + leafSize * 0.3)
      ..lineTo(cx + leafSize * 0.3, cy + leafSize)
      ..lineTo(cx, cy + leafSize * 0.6)
      ..lineTo(cx - leafSize * 0.3, cy + leafSize)
      ..lineTo(cx - leafSize * 0.5, cy + leafSize * 0.3)
      ..lineTo(cx - leafSize, cy - leafSize * 0.2)
      ..lineTo(cx - leafSize * 0.3, cy)
      ..close();
    canvas.drawPath(path, leafPaint);
  }

  /// ブラジル国旗
  void _drawBrazilFlag(Canvas canvas, double x, double y, double w, double h) {
    // 緑背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF009C3B),
    );

    // 黄色い菱形
    final diamondPaint = Paint()..color = const Color(0xFFFFDF00);
    final diamondPath = Path()
      ..moveTo(x + w / 2, y + h * 0.15)
      ..lineTo(x + w * 0.9, y + h / 2)
      ..lineTo(x + w / 2, y + h * 0.85)
      ..lineTo(x + w * 0.1, y + h / 2)
      ..close();
    canvas.drawPath(diamondPath, diamondPaint);

    // 青い円
    canvas.drawCircle(
      Offset(x + w / 2, y + h / 2),
      w * 0.2,
      Paint()..color = const Color(0xFF002776),
    );

    // 白い帯
    final bandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(x + w / 2, y + h / 2), radius: w * 0.2),
      -0.5,
      1.0,
      false,
      bandPaint,
    );
  }

  /// 韓国国旗
  void _drawKoreaFlag(Canvas canvas, double x, double y, double w, double h) {
    // 白背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = Colors.white,
    );

    // 太極（簡略化 - 赤と青の円）
    final cx = x + w / 2;
    final cy = y + h / 2;
    final radius = min(w, h) * 0.25;

    // 赤い半円（上）
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      pi,
      pi,
      true,
      Paint()..color = const Color(0xFFCD2E3A),
    );

    // 青い半円（下）
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      0,
      pi,
      true,
      Paint()..color = const Color(0xFF0047A0),
    );
  }

  /// 中国国旗
  void _drawChinaFlag(Canvas canvas, double x, double y, double w, double h) {
    // 赤背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFFDE2910),
    );

    // 黄色い星
    final starPaint = Paint()..color = const Color(0xFFFFDE00);

    // 大きな星
    _drawStarAt(canvas, x + w * 0.2, y + h * 0.3, w * 0.1, starPaint);

    // 小さな星
    _drawStarAt(canvas, x + w * 0.35, y + h * 0.2, w * 0.03, starPaint);
    _drawStarAt(canvas, x + w * 0.4, y + h * 0.3, w * 0.03, starPaint);
    _drawStarAt(canvas, x + w * 0.4, y + h * 0.4, w * 0.03, starPaint);
    _drawStarAt(canvas, x + w * 0.35, y + h * 0.5, w * 0.03, starPaint);
  }

  /// オーストラリア国旗
  void _drawAustraliaFlag(Canvas canvas, double x, double y, double w, double h) {
    // 青背景
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF00008B),
    );

    // ユニオンジャック（左上、簡略化）
    final ujW = w * 0.4;
    final ujH = h * 0.5;
    _drawUkFlag(canvas, x, y, ujW, ujH);

    // 星
    final starPaint = Paint()..color = Colors.white;
    _drawStarAt(canvas, x + w * 0.25, y + h * 0.7, w * 0.08, starPaint);
    _drawStarAt(canvas, x + w * 0.7, y + h * 0.3, w * 0.04, starPaint);
    _drawStarAt(canvas, x + w * 0.8, y + h * 0.5, w * 0.04, starPaint);
    _drawStarAt(canvas, x + w * 0.7, y + h * 0.7, w * 0.04, starPaint);
    _drawStarAt(canvas, x + w * 0.6, y + h * 0.5, w * 0.04, starPaint);
  }

  /// スペイン国旗
  void _drawSpainFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeH = h / 4;

    canvas.drawRect(
      Rect.fromLTWH(x, y, w, stripeH),
      Paint()..color = const Color(0xFFC60B1E),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH, w, stripeH * 2),
      Paint()..color = const Color(0xFFFFC400),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH * 3, w, stripeH),
      Paint()..color = const Color(0xFFC60B1E),
    );
  }

  /// メキシコ国旗
  void _drawMexicoFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeW = w / 3;

    canvas.drawRect(
      Rect.fromLTWH(x, y, stripeW, h),
      Paint()..color = const Color(0xFF006847),
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW, y, stripeW, h),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(x + stripeW * 2, y, stripeW, h),
      Paint()..color = const Color(0xFFCE1126),
    );

    // 中央の紋章（簡略化）
    canvas.drawCircle(
      Offset(x + w / 2, y + h / 2),
      min(w, h) * 0.1,
      Paint()..color = const Color(0xFF8B4513),
    );
  }

  /// インド国旗
  void _drawIndiaFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeH = h / 3;

    // サフラン
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, stripeH),
      Paint()..color = const Color(0xFFFF9933),
    );
    // 白
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH, w, stripeH),
      Paint()..color = Colors.white,
    );
    // 緑
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH * 2, w, stripeH),
      Paint()..color = const Color(0xFF138808),
    );

    // アショーカ・チャクラ（簡略化）
    final chakraPaint = Paint()
      ..color = const Color(0xFF000080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(x + w / 2, y + h / 2),
      min(w, h) * 0.1,
      chakraPaint,
    );
  }

  /// ロシア国旗
  void _drawRussiaFlag(Canvas canvas, double x, double y, double w, double h) {
    final stripeH = h / 3;

    canvas.drawRect(
      Rect.fromLTWH(x, y, w, stripeH),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH, w, stripeH),
      Paint()..color = const Color(0xFF0039A6),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y + stripeH * 2, w, stripeH),
      Paint()..color = const Color(0xFFD52B1E),
    );
  }

  /// 星を描画
  void _drawStarAt(Canvas canvas, double cx, double cy, double size, Paint paint) {
    final path = Path();
    const points = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;
    double rot = -pi / 2;
    final step = pi / points;

    path.moveTo(cx, cy - outerRadius);
    for (int i = 0; i < points; i++) {
      final outerX = cx + cos(rot) * outerRadius;
      final outerY = cy + sin(rot) * outerRadius;
      path.lineTo(outerX, outerY);
      rot += step;

      final innerX = cx + cos(rot) * innerRadius;
      final innerY = cy + sin(rot) * innerRadius;
      path.lineTo(innerX, innerY);
      rot += step;
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
