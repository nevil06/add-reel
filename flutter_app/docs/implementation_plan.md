# Survey Questions Feature - Implementation Plan

Add an Instagram-themed survey section where users can answer questions after watching ads to earn bonus points.

## Proposed Changes

### Models

#### [NEW] [survey_model.dart](file:///c:/Users/nevil/OneDrive/Desktop/addreel/flutter_app/lib/models/survey_model.dart)

Survey question and response models:
- **SurveyQuestion** - id, question text, type (multiple choice/rating), options, points reward
- **SurveyResponse** - user answers, timestamp, points earned
- Question types: Multiple choice, 5-star rating, yes/no

---

### Screens

#### [NEW] [survey_screen.dart](file:///c:/Users/nevil/OneDrive/Desktop/addreel/flutter_app/lib/screens/survey_screen.dart)

Instagram-themed survey interface:
- Full-screen card-based design
- Instagram gradient accents
- Swipe between questions
- Progress indicator
- Points reward display
- Completion animation

---

### Services

#### [NEW] [survey_service.dart](file:///c:/Users/nevil/OneDrive/Desktop/addreel/flutter_app/lib/services/survey_service.dart)

Survey management:
- Load available surveys
- Track completion status
- Save responses
- Award points via PointsService
- Analytics integration

---

### Integration

#### [MODIFY] [main.dart](file:///c:/Users/nevil/OneDrive/Desktop/addreel/flutter_app/lib/main.dart)

Add survey tab to bottom navigation:
- New "Surveys" tab with form icon
- Route to SurveyScreen

#### [MODIFY] [ads_feed_screen.dart](file:///c:/Users/nevil/OneDrive/Desktop/addreel/flutter_app/lib/screens/ads_feed_screen.dart)

Show survey prompt after watching ads:
- Optional survey popup after ad completion
- "Earn +10 points" incentive
- Skip or complete options

---

## Survey Features

### Question Types
1. **Multiple Choice** - Select one answer from 3-4 options
2. **Rating Scale** - 1-5 stars with Instagram styling
3. **Yes/No** - Simple binary choice

### Sample Questions
- "How relevant was this ad to you?"
- "Would you consider this product/service?"
- "Rate your ad viewing experience"
- "What type of ads do you prefer?"

### Points System
- **Quick Survey** (1-2 questions): +5 points
- **Standard Survey** (3-5 questions): +10 points
- **Detailed Survey** (6+ questions): +20 points

### Instagram Styling
- Gradient progress bar
- Instagram blue submit buttons
- Card-based question layout
- Smooth animations
- Celebration on completion

## Verification Plan

### Testing
- Complete survey flow from start to finish
- Verify points are awarded correctly
- Test all question types
- Check Instagram theme consistency
- Build APK and test on device
