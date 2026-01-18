# Tasbal Design Specification (MVP Final Version)

## 1. Overview

Tasbal transforms task management from "achievement visualization" into an experience of **feeling the world's atmosphere**.
It eliminates numbers, rankings, and comparisons, quietly conveying "progress," "rest," and "being in the same world with others" through balloons floating in the background.

---

## 2. Core Philosophy & Principles

* No display of numbers, rankings, or contribution amounts
* No text on background balloons
* Balloons exist as "air," not as objects to manipulate
* Deep breathing is not given special treatment (exists in the same world)
* Avoid comparison, ownership, and evaluation

---

## 3. Screen Structure (3 Tabs)

```
[ Tasks ] | [ Balloons ] | [ Settings ]
```

* Always show "Tasks" tab on first launch and return
* Background balloons are shared across all screens
* Deep breathing does not have its own screen

---

## 4. Task List UI Specification

### 4.1 Screen Structure

```
┌──────────────────────┐
│ Header                 │
│  Today's date          │
├──────────────────────┤
│ Display toggles        │
│ [ Hidden ] [ Archive ] │
├──────────────────────┤
│ Pinned                 │
│  📌 Task A             │
│  📌 Task B             │
├──────────────────────┤
│ With Due Date          │
│  📅 Task C (1/20)       │
│  📅 Task D (1/25)       │
├──────────────────────┤
│ Tasks                  │
│  □ Task E              │
│  □ Task F              │
├──────────────────────┤
│ Completed              │
│  ✓ Task G              │
│  ✓ Task H              │
├──────────────────────┤
│ ＋ (FAB)               │
└──────────────────────┘
```

### 4.2 Display Toggles

| Toggle | Default | Description |
| ----- | --- | ---------- |
| Hidden | OFF | Show hidden tasks |
| Archive | OFF | Show expired tasks |

※ Toggles are implemented as **Liquid Glass FilterChip** (semi-transparent glass chips)

### 4.3 Task States

| State | Display | Progress |
| ---- | ----------- | -- |
| Active | Normal list | × |
| Completed | Completed section | ○ |
| Hidden | Only when toggle ON | × |
| Expired | Only when archive toggle ON | × |

#### 4.3.1 Pinned Tasks

* Pinning is display priority (independent of state)
* Pinned tasks are shown in "Pinned" section
* Hidden/Expired tasks are not shown in pinned section

※ Pinning is not "evaluation", just "keeping in sight".

### 4.4 Section Structure

Task list consists of 4 sections (shown only when applicable):

| Section | Condition | Sort Order |
| --------- | -------- | -------- |
| Pinned | Pinned tasks | Created date |
| With Due Date | Has due date, not completed, not pinned | Due date (ascending) |
| Tasks | No due date, not completed, not pinned | Created date |
| Completed | Completed state (excluding pinned) | Completed date |

### 4.5 Task Items

#### 4.5.1 Task Card Specification

Each task is displayed as **Liquid Glass TaskCard**:

| Element | Description |
| ---- | ---- |
| Checkbox | Toggle completion |
| Title | Task name (required) |
| Memo | Detail memo (optional, 1 line) |
| Tags | Displayed as color chips (multiple) |
| Due Date | Due datetime (when set) |
| Pin Icon | Pin status indicator |

#### 4.5.2 Tags

* Tags are managed as string list
* Multiple tags per task supported
* Tags displayed as small chips on card
* Autocomplete from existing tags
* Tags have no meaning or evaluation (classification only)

### 4.6 Operations (Gestures)

Task rows should be operable without screen transitions.

#### 4.6.1 Swipe Operations

* Left swipe: Show action buttons
  * [Hide]
  * [Delete] (with confirmation dialog)

* Right swipe: Pin toggle
  * Pinned tasks move to "Pinned" section

#### 4.6.2 Tap Operations

* Checkbox tap: Toggle completion
  * No screen transition
  * Background balloon reacts (inflation/pop check)

* Card body tap: Show edit sheet
  * Edit title
  * Edit memo
  * Set due date
  * Edit tags

#### 4.6.3 Long Press

* Long press: Show edit sheet (same as tap)

### 4.7 Task Creation & Editing

#### 4.7.1 Task Creation Sheet

**Liquid Glass BottomSheet** shown by tapping FAB (+):

| Field | Required | Description |
| ---- | ---- | ---- |
| Title | ○ | Task name (cannot create if empty) |
| Memo | × | Detail memo (multiline) |
| Due Date | × | Set via DateTimePicker |
| Tags | × | Text input with autocomplete |

#### 4.7.2 Task Edit Sheet

Edit sheet shown by tapping existing task:

* Same fields as creation sheet
* Delete button added
* Pin toggle added

---

## 5. Background Balloon Specification

### 5.1 Display Groups

#### Always Visible (never leaves screen)

* Global balloon
* Location balloon
* Deep breathing balloon
* User's selected balloon

#### Drifting (can leave screen)

* Other users' public balloons
* Guerrilla balloons

### 5.2 Common Behavior

* Float slowly
* All balloons collide (soft repulsion)
* Inflate based on progress (with limit)
* Subtle pop animation

### 5.3 Tap Reaction (Minimal)

* No information display
* No screen transition
* Slight shake, momentary highlight

---

## 6. Balloon Specification (Detailed)

### 6.1 Basic Definition

* Balloons are **not objects to manipulate** (tappable but meaningless)
* No text, numbers, or names on background
* Balloons always exist in background layer
* Only visible: color, size, movement, pop

### 6.2 Balloon Types

| Type | Description | Always Visible | Can Leave Screen | Notes |
| --------- | ------ | ---- | ------ | ----------- |
| global | World-wide | ○ | × | Always show at least 1 |
| location | By country | ○ | × | Hidden if country not set |
| breathing | Deep breath | ○ | × | Pops on UTC daily aggregation |
| user | User-created | △ | △ | Always visible only when selected |
| guerrilla | Time-limited | × | ○ | Limited period |

### 6.3 Display Groups

#### Pinned Group (Always Visible)

* global
* location
* breathing
* **Selected user balloon**

Behavior:
* Repels at screen edge
* Never leaves screen

#### Drifting Group

* Unselected user balloons
* guerrilla balloons

Behavior:
* Enter and exit from outside screen
* Destroyed and regenerated when leaving screen

### 6.4 Physics (Common)

#### Movement

* Rise speed: -8 to -18 px/s
* Horizontal sway: -6 to +6 px/s
* Sway period: 4 to 7 seconds

#### Collision

* All balloons collide: ON
* Simple circular collision detection
* Restitution coefficient: 0.7
* Damping: 0.99 / frame
* Spatial partitioning (grid) required

### 6.5 Size & Progress (Inflation)

* Base radius: 22 to 28px
* Max inflation: +10 to +14px
* progress_ratio = current_value / next_threshold
* Linear size reflection

### 6.6 Colors & Flags

#### Colors

* User balloon: Single color from 12-color palette
* global / breathing: White-ish
* guerrilla: Slightly emphasized color

#### Flags (location)

* Displayed as **print** on balloon surface
* alpha 0.12 to 0.22
* Always visible (may emphasize momentarily on pop)

### 6.7 Tags & Bundling

#### Tags

* Balloons with valid balloon_membership
* Choose from 12 tag icons
* No text, no meaning

#### Bundling

* When 2 or more selected balloons
* Max 3 drawn
* Colors from original balloons

### 6.8 Pop (Break)

* Occurs when current_value >= next_threshold
* Subtle animation
  * Fragments: 10-30
  * Light ripple: 1 time
  * Sound: none or minimal
* Same for all balloon types

### 6.9 Performance Control

#### Normal

* Balloon count: 14
* Collision: ON
* Blur: ON

#### Low

* Balloon count: 10
* Collision: ON
* Blur: OFF

Switch conditions:
* Power saving mode
* FPS drop

---

## 7. Authentication & Account Linking

### 7.1 Authentication States

* Guest (Anonymous)
  * Start as guest on first launch (zero input)
  * Continue with device-local data
* Authenticated (Persistent)
  * Login with Apple / Google
  * Sync when logging in on different device

### 7.2 Guest Start and "Promotion"

* Guest uses Firebase Auth anonymous user
* When adding Apple / Google later, **link credentials** to anonymous account instead of new sign-in
  * This allows carrying over tasks and balloon data from guest period

### 7.3 Multi-Provider Login

* Link both Apple and Google to one user
* After linking, treated as same user ID

---

## 8. Privacy & Permissions

### 8.1 Location (GPS)

* Purpose: Country setting suggestion only
* Storage: Country code only (no lat/long)
* Acquisition: Only when user taps "Suggest from current location" (Foreground)
* Manual country setting available without permission

### 8.2 Data Minimization

* No personal identification info on balloon background
* No user-to-user comparison of task completion stats

---

## 9. Subscription (Free / Pro)

### 9.1 Free

* Balloon creation: Limited
* Public: Limited
* Selection: 1
* Colors: Single color from 12-color palette
* Tags: 12 presets

### 9.2 Pro (Future)

* Selection: Multiple (bundling + tags)
* Colors: Multiple colors, custom
* Tags: Additional sets unlocked

---

## 10. Guerrilla Balloon Specification

### 10.1 Auto Generation

* 3-5 times per day
* 1-3 hours each
* Generated by UTC date (Tasbal Day)
* Avoid overlap (minimum 30-60 min interval recommended)

### 10.2 Admin Creation

* Admin can create events with arbitrary start/end
* Can prioritize over auto-generated

### 10.3 Display

* Enter and exit as drifting group
* Expressed only in background (minimal numbers/notifications)
* May slightly increase presence during event (color, sway, etc.)

---

## 11. Offline & Sync (MVP Policy)

### 11.1 Offline Basics

* Tasks can be created/updated locally
* Sync on network recovery

### 11.2 Conflict Policy (Simple)

* Same task edit conflict: "Most recent update timestamp wins"
* Task completion is idempotent (prevent double counting)

---

## 12. Error & Loading

* Minimal loading (quiet skeleton)
* Background keeps moving on communication failure
* Errors shown as 1-line toast (suppress continuous display)

---

## 13. Accessibility & Device Considerations

* Support Reduce Motion
  * Reduce balloon count / sway amplitude / pop animation
* Low quality on power saving mode (10 balloons, blur OFF)
* Color diversity: Design where meaning is not determined by color alone

---

## 14. Confirmed Items Summary

* 3-tab structure (Tasks / Balloons / Settings)
* Task states (Normal/Completed/Hidden/Expired)
* Background balloons: Pinned (always) / Drifting groups
* Always visible: global / location / breathing / selected user
* Deep breathing balloon: No special treatment
* Colors: 12 fixed for Free, Tags: 12 presets
* Selection: 1 for Free, multiple for Pro
* Location info: Country suggestion only (country code only stored)
* Tasbal Day: UTC date
* Guerrilla: Both auto-generated and admin-created supported

---

End
