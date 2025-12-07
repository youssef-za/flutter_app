# Pre-Capture Questionnaire Feature

## Overview
Added a new questionnaire screen that appears before the camera screen when patients want to capture their emotion. This collects contextual information about the patient's current state.

## Files Created

### 1. Model
- **`lib/models/pre_capture_form.dart`**
  - Model class `PreCaptureForm` with fields:
    - `mood` (String) - Required
    - `sleepQuality` (double) - 1-5 scale
    - `stressed` (bool) - Yes/No
    - `painDescription` (String?) - Optional
    - `timestamp` (DateTime)
  - Includes validation, JSON serialization, and copyWith method

### 2. Provider
- **`lib/providers/pre_capture_provider.dart`**
  - `PreCaptureProvider` extends `ChangeNotifier`
  - Manages form state temporarily
  - Methods: `setForm()`, `updateForm()`, `clearForm()`, `reset()`
  - Properties: `form`, `hasForm`, `isFormValid`

### 3. Screen
- **`lib/screens/questionnaire/pre_capture_questionnaire_screen.dart`**
  - Beautiful Material 3 UI with clean design
  - Four questions:
    1. **Mood** - Dropdown (Happy, Sad, Angry, Neutral, Anxious) - Required
    2. **Sleep Quality** - Slider 1-5 with visual feedback
    3. **Stress Level** - Yes/No toggle switch
    4. **Physical Pain** - Optional text field
  - "Continue to Camera" button
  - Validates required fields before proceeding
  - Saves form to provider before navigation

## Files Modified

### 1. Routes
- **`lib/config/app_routes.dart`**
  - Added: `preCaptureQuestionnaire = '/questionnaire/pre-capture'`

### 2. Navigation Service
- **`lib/services/navigation_service.dart`**
  - Added: `toPreCaptureQuestionnaire()` method

### 3. Main App
- **`lib/main.dart`**
  - Added `PreCaptureProvider` to MultiProvider
  - Added route for `PreCaptureQuestionnaireScreen`

### 4. Patient Dashboard
- **`lib/screens/home/tabs/patient_dashboard_tab.dart`**
  - Modified `_captureEmotionFromCamera()` to open questionnaire first
  - Questionnaire navigates to camera after completion
  - Camera result is passed back to dashboard

## User Flow

1. Patient clicks "Capture New Emotion" button on dashboard
2. **PreCaptureQuestionnaireScreen** opens
3. Patient fills out questionnaire:
   - Selects mood (required)
   - Adjusts sleep quality slider
   - Toggles stress level
   - Optionally describes physical pain
4. Patient clicks "Continue to Camera"
5. Form is validated and saved to `PreCaptureProvider`
6. **CameraScreen** opens
7. Patient captures emotion
8. On success, returns to dashboard and reloads emotions

## Design Features

- **Material 3 Design**: Clean, modern UI
- **Soft Colors**: Uses AppTheme color palette
- **Rounded Containers**: 20px border radius
- **Consistent Padding**: 20px horizontal, proper vertical spacing
- **Visual Feedback**: 
  - Sleep quality shows numeric value in badge
  - Mood dropdown with clear options
  - Toggle switch for stress
  - Multi-line text field for pain description
- **Professional Layout**: 
  - Friendly title with icon
  - Clear question labels
  - Helpful descriptions
  - Prominent action button

## Validation

- **Required**: Mood selection
- **Optional**: Sleep quality (defaults to 3.0), Stress (defaults to false), Pain description
- Shows error message if mood is not selected
- Form validation before allowing navigation to camera

## Data Storage

- Form data is stored temporarily in `PreCaptureProvider`
- Can be accessed by other parts of the app if needed
- Form is cleared when appropriate (can be extended for persistence)

## Future Enhancements

- Save questionnaire data to backend along with emotion
- Add analytics to track questionnaire responses
- Allow editing questionnaire before camera
- Add more questions (energy level, medication, etc.)
- Persist form data locally for draft saving

## Testing Checklist

- [ ] Questionnaire opens when clicking "Capture New Emotion"
- [ ] Mood selection is required
- [ ] Sleep quality slider works correctly
- [ ] Stress toggle works correctly
- [ ] Pain description is optional
- [ ] Form validation prevents navigation without mood
- [ ] Form data is saved to provider
- [ ] Navigation to camera works correctly
- [ ] Camera result is passed back to dashboard
- [ ] Dashboard reloads emotions after successful capture


