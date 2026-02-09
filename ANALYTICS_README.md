# Analytics Tracking System

## Installation

Add Firebase Analytics via Swift Package Manager in Xcode:

1. Open `voiceout.xcodeproj`
2. Select Project → voiceout target → Package Dependencies
3. Click "+" and add: `https://github.com/firebase/firebase-ios-sdk`
4. Select version 10.20.0 or higher
5. Choose **FirebaseAnalytics** only

## Usage

Track user interactions by calling `AnalyticsManager.shared.logClick()` directly inside button actions:

```swift
Button {
    AnalyticsManager.shared.logClick(
        elementName: "option_button",
        screenName: "SadQuestionStyleSinglechoice",
        additionalParams: [
            "question_id": question.id,
            "option_key": option.key
        ]
    )
    
    // Business logic
    handleSelection()
}
```

## Event Dictionary

### Standard Event

**Event Name**: `ui_interaction`

### Required Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `interaction_type` | String | Type of interaction | `"click"` |
| `element_name` | String | UI element identifier | `"option_button"`, `"continue_button"` |
| `screen_name` | String | View class name | `"SadQuestionStyleSinglechoice"` |
| `timestamp` | Double | Auto-generated timestamp | `1707235200.0` |

### Optional Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `question_id` | Int | Question identifier | `1` |
| `option_key` | String | Selected option key | `"A"` |
| `option_text` | String | Selected option text | `"I feel slightly sad"` |
| `selected_count` | Int | Number of selections | `3` |
| `input_length` | Int | User input character count | `50` |

## Tracking Guidelines

### What to Track

✅ **Track**: User actions that trigger navigation to the next step
- Option selection in single-choice questions
- "Continue" or "Done" button clicks in multi-choice questions
- Submit buttons that advance the flow

### What NOT to Track

❌ **Don't Track**: Intermediate states
- Selecting/deselecting items before confirmation
- Typing in text fields (track only on submit)
- UI state changes that don't advance the flow

## Example Implementations

### Single Choice

```swift
Button {
    AnalyticsManager.shared.logClick(
        elementName: "option_button",
        screenName: "SadQuestionStyleSinglechoice",
        additionalParams: [
            "question_id": question.id,
            "option_key": option.key
        ]
    )
    onSelect(option)
}
```

### Multi Choice (Confirm Button)

```swift
Button("Done") {
    AnalyticsManager.shared.logClick(
        elementName: "confirm_button",
        screenName: "SadQuestionStyleMultichoice2",
        additionalParams: [
            "question_id": question.id,
            "selected_count": selectedOptions.count
        ]
    )
    onContinue()
}
```

### Fill-in-Blank (Submit Button)

```swift
Button("Submit") {
    AnalyticsManager.shared.logClick(
        elementName: "submit_button",
        screenName: "SadQuestionStyleFillInBlank",
        additionalParams: [
            "question_id": question.id,
            "input_length": userInput.count
        ]
    )
    onContinue()
}
```

## Debugging

In DEBUG mode, all events are logged to console:

```
📊 [Analytics] Click Event:
   Element: option_button
   Screen: SadQuestionStyleSinglechoice
   Additional: ["option_key": "A", "question_id": 1]
```

## Firebase Console

View events in Firebase Console:
1. Navigate to Analytics → Events
2. Look for event name: `ui_interaction`
3. Use DebugView for real-time event monitoring

## Privacy

- No PII (Personally Identifiable Information) is collected
- Only anonymous usage data is tracked
- User interactions and navigation patterns only

---

**Branch**: analytics-tracking  
**Date**: 2026-02-09  
**Status**: Active

