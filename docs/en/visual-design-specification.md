# Tasbal Visual Design Specification

> Created: 2026-01-11
> Purpose: Define visual specifications for balloons, backgrounds, and UI

---

## 0. Design Philosophy: Liquid Glass

Tasbal's visual design follows **Liquid Glass** as its core philosophy.

### 0.1 What is Liquid Glass?

A design approach inspired by Apple's design language introduced in iOS/macOS, emphasizing transparency, depth, and movement.

| Element | Description |
|---|---|
| Transparency | Glass-like semi-transparent layers, background blur |
| Depth | Multiple overlapping layers, subtle shadows and light |
| Fluidity | Liquid-like smooth animations |
| Light Refraction | Highlights, gradients, reflections |

### 0.2 Application in Tasbal

#### Balloons

* **Transparency**: Glass-like gloss on balloon surface, subtle see-through effect
* **Light Refraction**: Highlight from top-left, shadow on bottom-right
* **Fluidity**: Gentle floating, soft collision repulsion

#### Background

* **Gradient**: Purple/lavender vertical gradient
* **Grid**: Diamond grid with transparency, darker toward bottom
* **Light/Dark Mode**: Maintain Liquid Glass beauty in both modes

#### UI Elements

* **Buttons & Cards**: Semi-transparent background, subtle blur
* **Tab Bar**: Glass-like texture, blending with background
* **Transitions**: Flowing page transitions, fade effects

### 0.3 Implementation Guidelines

```dart
// Liquid Glass Color Palette (Light Mode)
const liquidGlassLight = {
  'background': Color(0xFFF0F0FF),      // Pale lavender white
  'backgroundEnd': Color(0xFFE8E0F8),   // Slight purple tint
  'grid': Color(0xFFD0D0E8),            // Lavender gray
  'glass': Color(0x40FFFFFF),           // Semi-transparent white
  'highlight': Color(0x80FFFFFF),       // Highlight
};

// Liquid Glass Color Palette (Dark Mode)
const liquidGlassDark = {
  'background': Color(0xFF1E1E3C),      // Deep navy/blue-purple
  'backgroundEnd': Color(0xFF141428),   // Darker purple
  'grid': Color(0xFF4A4A7C),            // Deep blue-purple
  'glass': Color(0x20FFFFFF),           // Semi-transparent white (subtle)
  'highlight': Color(0x40FFFFFF),       // Highlight (subtle)
};
```

### 0.4 References

* Apple Human Interface Guidelines - Materials
* iOS 26 / macOS 16 Liquid Glass Design
* Glassmorphism

---

## 1. Grid Background Specification

### 1.1 Core Philosophy

- Don't convey a sense of space
- Don't impose progress, evaluation, or direction
- Quietly provide a "place" for UI and balloons

> **The background doesn't assert itself, but doesn't disappear either.**

### 1.2 Grid Shape

#### Shape
- **Diamond grid** with squares rotated 45°
- **All diamonds are the same size**
- Grid line thickness and spacing are consistent

#### Viewpoint
- **Front view (flat)**
- No bird's eye view, perspective, or vanishing point
- Looking down from above is prohibited

#### Depth Expression
- Shape-based depth expression is prohibited
- **Express depth through color gradient only**

### 1.3 Light Mode Grid

#### Background
- Base: `#F0F0FF` Pale lavender white
- End: `#E8E0F8` Slight purple tint

#### Grid Lines
- Color: `#D0D0E8` Lavender gray
- Opacity: 25-45% (vertical gradient)

#### Impression
- Breathable
- Not too white, not cold

### 1.4 Dark Mode Grid

#### Background
- Base: `#1E1E3C` Deep navy/blue-purple
- End: `#141428` Darker purple

#### Grid Lines
- Color: `#4A4A7C` Deep blue-purple
- Opacity: 20-30% (vertical gradient)

#### Impression
- Quiet
- Doesn't disturb concentration
- Supports introspection and depth

### 1.5 Prohibited Items

- Perspective
- Grid size variation
- Shadows or 3D representation
- Imposing floor, space, or world view

---

## 2. Balloon Body Drawing Specification

### 2.1 Shape

| Element | Observation |
|---|---|
| Shape | Near-circle ellipse (vertically elongated) |
| Gloss | Highlight at top-left |
| Shadow | Dark at bottom-right |
| Texture | Smooth and translucent |
| Feel | Realistic rubber balloon |

```dart
class BalloonShape {
  double baseRadius = 26.0; // Base radius
  double verticalRatio = 1.15; // Aspect ratio (tall)

  double width = baseRadius * 2;
  double height = baseRadius * 2 * verticalRatio;

  Vector2 knotPosition = Vector2(0, height / 2 + 4);
}
```

### 2.2 Gloss & Highlight

```dart
class BalloonHighlight {
  Vector2 highlightOffset = Vector2(-8, -12);
  double highlightRadius = 12.0;

  RadialGradient createHighlight(Color balloonColor) {
    return RadialGradient(
      center: Alignment.topLeft,
      radius: 0.4,
      colors: [
        Colors.white.withOpacity(0.8), // Center: Strong white
        balloonColor.withOpacity(0.3), // Outer: Faint balloon color
        balloonColor,                   // Outermost: Balloon color
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }
}
```

### 2.3 Shadow & Shading

```dart
class BalloonShading {
  RadialGradient createShading(Color balloonColor) {
    return RadialGradient(
      center: Alignment.bottomRight,
      radius: 0.8,
      colors: [
        balloonColor.darken(0.3), // Bottom-right: Dark
        balloonColor,              // Center: Normal
      ],
      stops: [0.0, 1.0],
    );
  }
}
```

### 2.4 Knot

```dart
class BalloonKnot {
  Vector2 position;
  double size = 4.0;

  void draw(Canvas canvas, Color balloonColor) {
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

## 3. String Drawing Specification

### 3.1 Basic Shape

| Element | Observation |
|---|---|
| Color | Same color family as balloon (slightly darker) |
| Thickness | Thin (1-2px) |
| Length | 2-3x balloon height |
| Shape | Hangs straight down |
| Knot | Small knot at balloon bottom |

### 3.2 Swing Animation

```dart
class StringSwing {
  double swingAngle = 0.0;
  double maxAngle = 0.08;  // ±5 degrees
  double frequency = 2.0;  // Period (seconds)

  void update(double dt) {
    swingAngle = sin(dt * frequency * 2 * pi) * maxAngle;
  }
}
```

---

## 4. Tag (Weight) Drawing Specification

### 4.1 Basic Shape

| Element | Observation |
|---|---|
| Shape | Small cube |
| Color | Same color family as balloon (pastel) |
| Size | 1/8 to 1/10 of balloon |
| Shadow | Elliptical shadow on ground |
| Feel | Matte texture |

### 4.2 Isometric Cube

- Angle: 30 degrees
- Top face (bright), Left face (medium), Right face (dark)
- Icon drawn on top face

---

## 5. Color Palette

### 5.1 Balloon Colors (12-Color Palette)

```dart
class BalloonColorPalette {
  static const colors = [
    Color(0xFFFF7B7B), // Red
    Color(0xFFFFD966), // Yellow
    Color(0xFFB794FF), // Purple
    Color(0xFFFFB366), // Orange
    Color(0xFFE8E8E8), // Gray
    Color(0xFF7BEB7B), // Green
    Color(0xFFFF94B8), // Pink
    Color(0xFFFFB3E6), // Light pink
    Color(0xFF7BD4FF), // Blue
    Color(0xFFC794FF), // Light purple
    Color(0xFFFFE699), // Light yellow
    Color(0xFFB3FFE6), // Mint
  ];

  static Color getTagColor(Color balloonColor) {
    final hsl = HSLColor.fromColor(balloonColor);
    return hsl.withSaturation(hsl.saturation * 0.6).toColor();
  }
}
```

---

## 6. Performance Optimization

### 6.1 Quality Settings

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

### 6.2 Drawing Order

1. Background gradient
2. Grid
3. Shadows (back to front)
4. Balloons (back to front, Z-coordinate sorted)

---

## 7. Implementation Checklist

### Balloon Body
- [ ] Ellipse shape (tall)
- [ ] Top-left highlight
- [ ] Bottom-right shadow
- [ ] Knot drawing
- [ ] Size change based on progress

### String and Tag
- [ ] String drawing
- [ ] String swing animation
- [ ] Cube tag drawing
- [ ] Tag icon drawing

### Background
- [ ] Vertical gradient
- [ ] Diamond grid
- [ ] Light/Dark mode support

### Performance
- [ ] Z-coordinate sort
- [ ] Quality switching
- [ ] FPS measurement (maintain 60fps)

---

End
