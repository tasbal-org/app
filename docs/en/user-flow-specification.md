# Tasbal User Flow Specification

> This document defines the complete user flow from onboarding to authentication.

---

## 1. Onboarding

### 1.1 Purpose

Tasbal's onboarding is **not about teaching how to use the app.**

- Affirm small steps
- Separate from evaluation, competition, and numbers
- Naturally transition from comfort → quiet excitement → daily use

### 1.2 Application Conditions

- Always shown on first launch
- Skippable
- Can be re-shown from settings
- Applies to both new users and guest users

### 1.3 Overall Structure

| Screen | Role | Emotion |
|----|----|----|
| 1 | Share values | Comfort |
| 2 | Write a step | Comfort → Action |
| 3 | Experience | Surprise |
| 4 | Give meaning | Excitement |
| 5 | To daily use | Afterglow |

### 1.4 Screen Specifications

#### Screen 1: Share Values

**Main**
```
Your step today
can be left here
```

**Sub**
```
It will
quietly
spread
without you noticing
```

**Note**
```
Stopping to take
a deep breath
is also a step
```

#### Screen 2: Write a Step

**Title**
```
First,
let's write
today's step
```

**Input Placeholder**
```
・Sit at the desk
・Think for just 5 minutes
・Rest today

Anything is okay
```

**Button**
- Write it

#### Screen 3: Completion & Experience

(After task completion)

**Main**
```
One thing
is left
here
```

**Sub**
```
A step
is quietly
moving
```

#### Screen 4: Give Meaning

**Main**
```
Here,
everyone's steps
overlap
```

**Sub**
```
Who did how much
is not shown

What you see
is only that
things are moving forward
```

**Note**
```
Let's move forward
```

#### Screen 5: To Daily Use

**Main**
```
Preparation
is complete
```

**Sub**
```
Now,
just keep
adding today's steps
```

**Button**
- Continue

### 1.5 Animation Specification

#### Basic Policy

- Use balloons
- No flashy effects
- Don't emphasize achievement
- Create the feeling of "it moved before I noticed"

#### Target Screen

- Screen 3: Completion & Experience

#### Balloon Animation

**Display Timing**
- Right after task completion
- Delay 0.2-0.4 seconds from text display

**Movement Content**
- Existing balloon or single balloon
  - Floats up slightly
  - Or shakes very slightly

**Movement Characteristics**

| Element | Guideline |
|----|----|
| Speed | Slow |
| Amplitude | Minimal |
| Count | Once only |
| Easing | ease-in-out |
| Sound | None |

#### NG Examples (Prohibited)

- Popup display
- Number increase animation
- Sparkles or flashy effects
- Sound effects
- Words like "Success" or "Achievement"

---

## 2. Authentication Flow (After Onboarding)

### 2.1 Position

Authentication guidance shown after completing onboarding (Screens 1-5).

- No forced authentication
- Can skip (defer)
- Purpose is not "management" but **continuation, transfer, protection**

Top priority: Don't destroy the "comfort, afterglow, quiet excitement" formed in onboarding.

### 2.2 Overall Flow Structure

```text
Onboarding Complete
  ↓
A1. Account Guidance (Selection)
  ├─ A2. Sign Up
  │    └─ A4. Email Verification
  │         └─ A5. Auth Complete
  ├─ A3. Login
  │    └─ A5. Auth Complete
  └─ Skip (Guest) → Home
```

### 2.3 A1: Account Guidance (Selection Screen)

#### Purpose
- Guarantee "you don't have to decide now"
- Quietly convey only the **meaning** of authentication

#### Display Content

**Title**
```
You can use it as is
```

**Description**
```
To transfer your records
or use on another device,
you'll need an account
```

**Benefits (Bullet points)**
- Continue from where you left off on a different device
- Less likely to lose data
- Join public balloons (optional)

#### Buttons
- Primary: Create account
- Secondary: Login
- Tertiary: Later (stay as is for now)

#### Notes
- "Why do I need an account?" link optional
- No rankings, evaluations, or obligatory expressions

### 2.4 A2: Sign Up (Email)

#### Input Items
- Email address (required)
- Password (required) 8+ characters

**Title**
```
Create account
```

**Sub**
```
Used for transfer purposes
```

#### Buttons
- Primary: Next
- Secondary: Switch to login
- Back: Back

### 2.5 A3: Login

#### Input Items
- Email address
- Password

#### Buttons
- Primary: Login
- Secondary: Create account
- Text: Forgot password

### 2.6 A4: Email Verification

#### Method
- 6-digit confirmation code recommended

**Title**
```
Enter confirmation code
```

**Description**
```
Enter the code
sent to your email
```

#### Buttons
- Primary: Verify
- Text: Resend code
- Text: Change email address

### 2.7 A5: Auth Complete

**Title**
```
You're ready
```

**Sub**
```
Today's steps
will be carried over as is
```

#### Buttons
- Primary: Continue (to Home)

---

## 3. Guest Operation

### 3.1 Guest Continuation
- If "Later" selected in A1, continue as guest

### 3.2 When to Suggest Authentication
- Device change/backup
- Joining/creating public balloons
- Session expiration

### 3.3 Guest → Auth Data Migration

#### Migration Targets
- Created tasks
- Selected balloon state
- Achievement history (internal)

#### Principles
- Don't increase user operations
- Auto-integrate on auth success

---

## 4. Error Message Policy

- Don't scold
- Don't rush
- Keep it short

### Examples
- Email format: Please check your email address
- Password: The input doesn't seem to match
- Code expiration: The code has expired. You can resend
- Communication: Connection is unstable. Please try again

---

## 5. State Management

- `hasCompletedOnboarding`: boolean
- `authState`: guest | authenticated
- `onboardingVersion`: number
- `pendingEmail`: string?
- `guestId` / `deviceId`
- `migrationStatus`: none | pending | done | failed

---

## 6. UI / Navigation Rules

- Always provide "Later" option in A1
- Prioritize actions over explanations
- No pushy language after auth completion

---

## 7. Summary

Copy and effects, quietly.
**Something is definitely happening.**

- Onboarding: Entrust everything to the experience of "balloon moves slightly"
- Authentication: Not an obligation but "procedure to continue"
- Present naturally when needed
