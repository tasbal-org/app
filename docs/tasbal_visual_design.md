# タスバル 風船レンダリング仕様書（ビジュアルリファレンス版）

> 生成日: 2026-01-11
> 参考画像: ChatGPT生成の風船イメージ
> 目的: 実際のビジュアルに基づいた詳細な描画仕様の確定

---

## 0. デザイン思想：Liquid Glass

タスバルのビジュアルデザインは **Liquid Glass（リキッドグラス）** を基本思想とする。

### 0.1 Liquid Glass とは

Apple が iOS/macOS で導入したデザイン言語に着想を得た、透明感・奥行き・動きを重視したデザインアプローチ。

| 要素 | 説明 |
|---|---|
| 透明感 | ガラスのような半透明レイヤー、背景のぼかし |
| 奥行き | 複数レイヤーの重なり、微妙な影と光 |
| 流動性 | 液体のような滑らかなアニメーション |
| 光の屈折 | ハイライト、グラデーション、反射 |

### 0.2 タスバルでの適用

#### 風船

* **透明感**: 風船表面にガラス質の光沢、微かな透け感
* **光の屈折**: 左上からのハイライト、右下の陰影
* **流動性**: ゆったりとした浮遊、ふわっとした衝突反発

#### 背景

* **グラデーション**: 紫/ラベンダー系の垂直グラデーション
* **グリッド**: 透明度を持つ菱形グリッド、下方に向かって濃くなる
* **ライト/ダークモード**: 両モードでLiquid Glassの美しさを保持

#### UI要素

* **ボタン・カード**: 半透明の背景、微妙なブラー
* **タブバー**: ガラス質の質感、背景との融合
* **遷移**: 流れるようなページ遷移、フェード効果

### 0.3 実装ガイドライン

```dart
// Liquid Glass カラーパレット（ライトモード）
const liquidGlassLight = {
  'background': Color(0xFFF0F0FF),      // 薄いラベンダー白
  'backgroundEnd': Color(0xFFE8E0F8),   // わずかに紫味
  'grid': Color(0xFFD0D0E8),            // ラベンダーグレー
  'glass': Color(0x40FFFFFF),           // 半透明白
  'highlight': Color(0x80FFFFFF),       // ハイライト
};

// Liquid Glass カラーパレット（ダークモード）
const liquidGlassDark = {
  'background': Color(0xFF1E1E3C),      // 濃紺/青紫
  'backgroundEnd': Color(0xFF141428),   // より暗い紫
  'grid': Color(0xFF4A4A7C),            // 濃いめの青紫
  'glass': Color(0x20FFFFFF),           // 半透明白（控えめ）
  'highlight': Color(0x40FFFFFF),       // ハイライト（控えめ）
};
```

### 0.4 参考

* Apple Human Interface Guidelines - Materials
* iOS 26 / macOS 16 の Liquid Glass デザイン
* ガラスモーフィズム（Glassmorphism）

---

## 1. 参考画像から読み取れる要素

### 1.1 風船本体

| 要素 | 観察内容 |
|---|---|
| 形状 | 正円に近い楕円（縦長） |
| 光沢 | 左上にハイライト |
| 影 | 右下が暗い |
| テクスチャ | 滑らかで透明感 |
| 質感 | ゴム風船のリアルな表現 |

### 1.2 紐

| 要素 | 観察内容 |
|---|---|
| 色 | 風船色と同系色（やや暗め） |
| 太さ | 細い（1〜2px程度） |
| 長さ | 風船の高さの 2〜3倍 |
| 形状 | 真っ直ぐ下に垂れる |
| 結び目 | 風船下部に小さな結び目 |

### 1.3 タグ（おもり）

| 要素 | 観察内容 |
|---|---|
| 形状 | 小さな立方体 |
| 色 | 風船色と同系色（パステル調） |
| サイズ | 風船の 1/8〜1/10 程度 |
| 影 | 地面に楕円の影 |
| 質感 | マットな質感 |

### 1.4 空間・背景

| 要素 | 観察内容 |
|---|---|
| 背景色 | 薄い紫〜青のグラデーション |
| 雲 | ぼんやりとした白い雲 |
| 光源 | 左上から斜め |
| 影 | 各風船の下に楕円の影 |
| 奥行き | 手前と奥で風船のサイズが異なる |

---

## 2. 風船本体の描画仕様

### 2.1 形状

```dart
class BalloonShape {
  // 基本サイズ
  double baseRadius = 26.0; // 基本半径
  double verticalRatio = 1.15; // 縦横比（縦長）
  
  // 楕円の定義
  double width = baseRadius * 2;
  double height = baseRadius * 2 * verticalRatio;
  
  // 結び目の位置
  Vector2 knotPosition = Vector2(0, height / 2 + 4);
}
```

### 2.2 光沢・ハイライト

```dart
class BalloonHighlight {
  // ハイライトの位置（左上）
  Vector2 highlightOffset = Vector2(-8, -12);
  
  // ハイライトのサイズ
  double highlightRadius = 12.0;
  
  // グラデーション
  RadialGradient createHighlight(Color balloonColor) {
    return RadialGradient(
      center: Alignment.topLeft,
      radius: 0.4,
      colors: [
        Colors.white.withOpacity(0.8), // 中心: 強い白
        balloonColor.withOpacity(0.3), // 外側: 薄い風船色
        balloonColor,                   // 最外: 風船色
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }
}
```

### 2.3 影・陰影

```dart
class BalloonShading {
  // 右下の暗い部分
  RadialGradient createShading(Color balloonColor) {
    return RadialGradient(
      center: Alignment.bottomRight,
      radius: 0.8,
      colors: [
        balloonColor.darken(0.3), // 右下: 暗い
        balloonColor,              // 中央: 通常
      ],
      stops: [0.0, 1.0],
    );
  }
}

// 色を暗くするヘルパー
extension ColorExtension on Color {
  Color darken(double amount) {
    return Color.fromARGB(
      alpha,
      (red * (1 - amount)).toInt(),
      (green * (1 - amount)).toInt(),
      (blue * (1 - amount)).toInt(),
    );
  }
}
```

### 2.4 結び目

```dart
class BalloonKnot {
  Vector2 position; // 風船下部
  double size = 4.0;
  
  void draw(Canvas canvas, Color balloonColor) {
    // 小さな楕円
    canvas.drawOval(
      Rect.fromCenter(
        center: position.toOffset(),
        width: size,
        height: size * 1.5,
      ),
      Paint()
        ..color = balloonColor.darken(0.2)
        ..style = PaintingStyle.fill,
    );
  }
}
```

---

## 3. 紐の描画仕様

### 3.1 基本形状

```dart
class BalloonString {
  Vector2 startPoint; // 結び目の位置
  Vector2 endPoint;   // タグの位置
  Color stringColor;
  
  double strokeWidth = 1.5;
  
  void draw(Canvas canvas) {
    // シンプルな直線
    canvas.drawLine(
      startPoint.toOffset(),
      endPoint.toOffset(),
      Paint()
        ..color = stringColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }
}
```

### 3.2 揺れのアニメーション

```dart
class StringSwing {
  double swingAngle = 0.0; // ラジアン
  double maxAngle = 0.08;  // ±5度程度
  double frequency = 2.0;   // 周期（秒）
  
  void update(double dt) {
    swingAngle = sin(dt * frequency * 2 * pi) * maxAngle;
  }
  
  Vector2 calculateEndPoint(Vector2 start, double length) {
    return Vector2(
      start.x + sin(swingAngle) * length,
      start.y + cos(swingAngle) * length,
    );
  }
}
```

---

## 4. タグ（おもり）の描画仕様

### 4.1 立方体の描画

```dart
class BalloonTag {
  Vector2 position;
  double size = 8.0;
  Color tagColor;
  TagIcon icon;
  
  void draw(Canvas canvas) {
    // 立方体の疑似3D表現
    final isometric = _calculateIsometric(position, size);
    
    // 上面（明るい）
    canvas.drawPath(
      isometric.topFace,
      Paint()..color = tagColor.brighten(0.2),
    );
    
    // 左面（中間）
    canvas.drawPath(
      isometric.leftFace,
      Paint()..color = tagColor,
    );
    
    // 右面（暗い）
    canvas.drawPath(
      isometric.rightFace,
      Paint()..color = tagColor.darken(0.2),
    );
    
    // アイコン（上面に描画）
    _drawIcon(canvas, isometric.topFaceCenter, icon);
  }
  
  IsometricCube _calculateIsometric(Vector2 pos, double size) {
    // 疑似3D計算（アイソメトリック）
    // 詳細は後述
  }
}

extension ColorBrightness on Color {
  Color brighten(double amount) {
    return Color.fromARGB(
      alpha,
      min(255, (red * (1 + amount)).toInt()),
      min(255, (green * (1 + amount)).toInt()),
      min(255, (blue * (1 + amount)).toInt()),
    );
  }
}
```

### 4.2 アイソメトリック立方体の計算

```dart
class IsometricCube {
  Path topFace;
  Path leftFace;
  Path rightFace;
  Vector2 topFaceCenter;
  
  factory IsometricCube.create(Vector2 center, double size) {
    // アイソメトリック角度（30度）
    final angle = pi / 6;
    final halfSize = size / 2;
    
    // 頂点の計算
    final top = center;
    final topLeft = Vector2(
      center.x - cos(angle) * halfSize,
      center.y - sin(angle) * halfSize,
    );
    final topRight = Vector2(
      center.x + cos(angle) * halfSize,
      center.y - sin(angle) * halfSize,
    );
    final bottomLeft = Vector2(
      topLeft.x,
      topLeft.y + size,
    );
    final bottomRight = Vector2(
      topRight.x,
      topRight.y + size,
    );
    final bottom = Vector2(
      center.x,
      center.y + halfSize * 2,
    );
    
    // 面の作成
    final topFace = Path()
      ..moveTo(top.x, top.y)
      ..lineTo(topLeft.x, topLeft.y)
      ..lineTo(center.x - halfSize, center.y)
      ..lineTo(topRight.x, topRight.y)
      ..close();
    
    final leftFace = Path()
      ..moveTo(topLeft.x, topLeft.y)
      ..lineTo(bottomLeft.x, bottomLeft.y)
      ..lineTo(bottom.x - halfSize, bottom.y)
      ..lineTo(center.x - halfSize, center.y)
      ..close();
    
    final rightFace = Path()
      ..moveTo(topRight.x, topRight.y)
      ..lineTo(bottomRight.x, bottomRight.y)
      ..lineTo(bottom.x + halfSize, bottom.y)
      ..lineTo(center.x + halfSize, center.y)
      ..close();
    
    return IsometricCube(
      topFace: topFace,
      leftFace: leftFace,
      rightFace: rightFace,
      topFaceCenter: center,
    );
  }
}
```

### 4.3 タグアイコンの描画

```dart
class TagIconRenderer {
  void drawIcon(Canvas canvas, Vector2 center, TagIcon icon, double size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    switch (icon) {
      case TagIcon.circle:
        canvas.drawCircle(center.toOffset(), size / 3, paint);
        break;
      
      case TagIcon.square:
        canvas.drawRect(
          Rect.fromCenter(
            center: center.toOffset(),
            width: size / 2,
            height: size / 2,
          ),
          paint,
        );
        break;
      
      case TagIcon.triangle:
        final path = Path()
          ..moveTo(center.x, center.y - size / 3)
          ..lineTo(center.x - size / 3, center.y + size / 4)
          ..lineTo(center.x + size / 3, center.y + size / 4)
          ..close();
        canvas.drawPath(path, paint);
        break;
      
      case TagIcon.star:
        _drawStar(canvas, center, size / 3, paint);
        break;
      
      // 他のアイコンも同様に実装
    }
  }
  
  void _drawStar(Canvas canvas, Vector2 center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - pi / 2;
      final outerPoint = Vector2(
        center.x + cos(angle) * radius,
        center.y + sin(angle) * radius,
      );
      final innerAngle = angle + pi / 5;
      final innerPoint = Vector2(
        center.x + cos(innerAngle) * radius * 0.4,
        center.y + sin(innerAngle) * radius * 0.4,
      );
      
      if (i == 0) {
        path.moveTo(outerPoint.x, outerPoint.y);
      } else {
        path.lineTo(outerPoint.x, outerPoint.y);
      }
      path.lineTo(innerPoint.x, innerPoint.y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
```

---

## 5. 影の描画

### 5.1 地面への投影

```dart
class GroundShadow {
  void draw(Canvas canvas, Vector2 balloonPosition, double z) {
    // 風船の位置から影の位置を計算
    final shadowCenter = Vector2(
      balloonPosition.x + z * 0.1, // Zによるオフセット
      groundY, // 地面のY座標（固定）
    );
    
    // 楕円の影
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter.toOffset(),
        width: 30,
        height: 15,
      ),
      shadowPaint,
    );
  }
}
```

---

## 6. 背景の描画

### 6.1 空のグラデーション

```dart
class SkyGradient {
  void draw(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFE8DCFF), // 上: 薄い紫
        Color(0xFFEEF3FF), // 中: 薄い青
        Color(0xFFF5F8FF), // 下: ほぼ白
      ],
      stops: [0.0, 0.5, 1.0],
    );
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      ),
    );
  }
}
```

### 6.2 雲の描画

```dart
class Cloud {
  Vector2 position;
  double size;
  double opacity;
  
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20.0);
    
    // ぼんやりとした円をいくつか重ねる
    canvas.drawCircle(
      position.toOffset(),
      size,
      paint,
    );
    canvas.drawCircle(
      (position + Vector2(size * 0.6, 0)).toOffset(),
      size * 0.8,
      paint,
    );
    canvas.drawCircle(
      (position + Vector2(-size * 0.5, 0)).toOffset(),
      size * 0.7,
      paint,
    );
  }
}
```

---

## 7. 配色パレット（画像参考）

### 7.1 風船の色

```dart
class BalloonColorPalette {
  static const colors = [
    Color(0xFFFF7B7B), // 赤（画像左上）
    Color(0xFFFFD966), // 黄色
    Color(0xFFB794FF), // 紫
    Color(0xFFFFB366), // オレンジ
    Color(0xFFE8E8E8), // グレー
    Color(0xFF7BEB7B), // 緑
    Color(0xFFFF94B8), // ピンク
    Color(0xFFFFB3E6), // 薄ピンク
    Color(0xFF7BD4FF), // 青
    Color(0xFFC794FF), // 薄紫
    Color(0xFFFFE699), // 薄黄
    Color(0xFFB3FFE6), // ミント
  ];
  
  // タグの色は風船色の彩度を下げたもの
  static Color getTagColor(Color balloonColor) {
    final hsl = HSLColor.fromColor(balloonColor);
    return hsl.withSaturation(hsl.saturation * 0.6).toColor();
  }
}
```

---

## 8. 完全な風船オブジェクト

### 8.1 統合クラス

```dart
class Balloon {
  // 基本情報
  String id;
  BalloonType type;
  Color color;
  TagIcon? tagIcon;
  
  // 位置・物理
  Vector3 position; // X, Y, Z
  Vector2 velocity;
  double rotation = 0.0;
  
  // サイズ・進捗
  double baseRadius = 26.0;
  double currentRadius = 26.0;
  double progressRatio = 0.0; // 0.0 - 1.0
  
  // 描画コンポーネント
  late BalloonShape shape;
  late BalloonHighlight highlight;
  late BalloonShading shading;
  late BalloonKnot knot;
  late BalloonString string;
  late BalloonTag? tag;
  
  void update(double dt) {
    // 物理更新
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
    
    // サイズ更新（進捗に応じて膨らむ）
    currentRadius = baseRadius + (progressRatio * 12.0);
    
    // 紐の揺れ
    string.update(dt);
  }
  
  void draw(Canvas canvas) {
    // 遠近法による変換
    final screenPos = worldToScreen(position);
    final scale = getDepthScale(position.z);
    
    // 影
    if (position.z > 0) {
      GroundShadow().draw(canvas, screenPos, position.z);
    }
    
    // 紐
    string.draw(canvas);
    
    // タグ
    tag?.draw(canvas);
    
    // 風船本体
    _drawBalloonBody(canvas, screenPos, scale);
  }
  
  void _drawBalloonBody(Canvas canvas, Vector2 pos, double scale) {
    final scaledRadius = currentRadius * scale;
    
    // 影・陰影のグラデーション
    canvas.drawOval(
      Rect.fromCenter(
        center: pos.toOffset(),
        width: scaledRadius * 2,
        height: scaledRadius * 2 * 1.15,
      ),
      Paint()..shader = shading.createShading(color).createShader(
        Rect.fromCenter(
          center: pos.toOffset(),
          width: scaledRadius * 2,
          height: scaledRadius * 2 * 1.15,
        ),
      ),
    );
    
    // ハイライト
    canvas.drawCircle(
      (pos + Vector2(-8, -12) * scale).toOffset(),
      12.0 * scale,
      Paint()..shader = highlight.createHighlight(color).createShader(
        Rect.fromCircle(
          center: (pos + Vector2(-8, -12) * scale).toOffset(),
          radius: 12.0 * scale,
        ),
      ),
    );
    
    // 結び目
    knot.draw(canvas, color);
  }
}
```

---

## 9. パフォーマンス最適化

### 9.1 描画順序

```dart
class BalloonRenderer {
  void render(Canvas canvas, List<Balloon> balloons) {
    // Z座標でソート（奥から手前）
    balloons.sort((a, b) => b.position.z.compareTo(a.position.z));
    
    // 影を先に描画
    for (final balloon in balloons) {
      if (balloon.position.z > 0) {
        GroundShadow().draw(canvas, balloon.position, balloon.position.z);
      }
    }
    
    // 風船を描画
    for (final balloon in balloons) {
      balloon.draw(canvas);
    }
  }
}
```

### 9.2 描画品質による切り替え

```dart
enum RenderQuality { Low, Normal, High }

class QualitySettings {
  static Map<RenderQuality, Settings> presets = {
    RenderQuality.Low: Settings(
      balloonCount: 10,
      showStrings: false,
      showTags: false,
      showShadows: false,
      showHighlights: false,
    ),
    RenderQuality.Normal: Settings(
      balloonCount: 14,
      showStrings: true,
      showTags: true,
      showShadows: true,
      showHighlights: true,
    ),
    RenderQuality.High: Settings(
      balloonCount: 20,
      showStrings: true,
      showTags: true,
      showShadows: true,
      showHighlights: true,
      enableBlur: true,
    ),
  };
}
```

---

## 10. 実装チェックリスト

### 10.1 風船本体
- [ ] 楕円形状（縦長）
- [ ] 左上のハイライト
- [ ] 右下の陰影
- [ ] 結び目の描画
- [ ] 進捗に応じたサイズ変化

### 10.2 紐とタグ
- [ ] 紐の描画
- [ ] 紐の揺れアニメーション
- [ ] 立方体タグの描画
- [ ] タグアイコンの描画
- [ ] タグの色（風船色の彩度を下げたもの）

### 10.3 影と背景
- [ ] 地面への影
- [ ] 空のグラデーション
- [ ] 雲の描画
- [ ] 遠近フォグ

### 10.4 パフォーマンス
- [ ] Z座標ソート
- [ ] 描画品質の切り替え
- [ ] FPS計測（60fps維持）

---

## 11. 参考コード：完全な描画ループ

```dart
class TasbalBalloonCanvas extends CustomPainter {
  final List<Balloon> balloons;
  final RenderQuality quality;
  
  TasbalBalloonCanvas({
    required this.balloons,
    this.quality = RenderQuality.Normal,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // 背景
    SkyGradient().draw(canvas, size);
    
    // 雲（オプション）
    if (quality == RenderQuality.High) {
      _drawClouds(canvas);
    }
    
    // 風船
    BalloonRenderer().render(canvas, balloons);
  }
  
  void _drawClouds(Canvas canvas) {
    // 静的な雲を数個配置
    Cloud(
      position: Vector2(100, 80),
      size: 60,
      opacity: 0.3,
    ).draw(canvas);
    
    Cloud(
      position: Vector2(300, 120),
      size: 80,
      opacity: 0.25,
    ).draw(canvas);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

---

以上
