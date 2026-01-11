# Focus App - Enhanced MVP

An iOS app that improves focus and learning outcomes through outcome-driven sessions, mandatory reflection, and a transparent "Depth Score" system.

## Features

### Core Features
- **Focus Session Creation**: Define task type, micro-goal, pre-commitment, energy level, and difficulty
- **Pre-Session Warm-Up**: 30-second priming screen to set intentions
- **Focus Timer**: Full-screen countdown with pause/resume and optional break prompts
- **Mandatory Reflection**: Post-session reflection with completion status, effort rating, distraction tracking, and iteration notes
- **Depth Score**: Transparent scoring system based on difficulty, effort, energy, completion, time efficiency, and distractions

### Dashboard
- Today's summary (minutes, depth score, sessions, completion rate)
- Weekly depth chart (last 7 days)
- Streak tracking (high-depth and completion streaks)
- Dynamic insights (best time of day, energy impact, distraction patterns, task type performance)

### History
- Session list grouped by date
- Detailed session view with full breakdown
- Weekly review access

### Weekly Reviews
- Automatic prompts on Sundays at 8 PM (if ≥3 sessions)
- Reflect on top 3 sessions
- Identify success patterns
- Set optimization goals for next week

### Settings
- Notification preferences
- CSV data export
- Reset all data option

## Technical Stack

- **Platform**: iOS 17+
- **Language**: Swift 5+
- **UI Framework**: SwiftUI
- **Persistence**: SwiftData
- **Charts**: Swift Charts
- **Architecture**: MVVM

## Project Structure

```
FocusApp/
├── App/                    # App entry point
├── Models/                 # Data models (SwiftData)
├── Persistence/            # Repositories and model container
├── Services/               # Business logic (calculators, insights, export)
├── ViewModels/             # MVVM view models
├── Views/                  # SwiftUI views
│   ├── Onboarding/
│   ├── Session/
│   ├── Dashboard/
│   ├── History/
│   └── Settings/
└── Components/             # Reusable UI components
```

## Depth Score Formula

```
DepthScore = 10 × D × E × (EN / 5) × C × T × P

Where:
- D = difficulty (1-5)
- E = effort (1-5)
- EN = energy level (1-5)
- C = completion multiplier (Yes=1.0, Partial=0.6, No=0.2)
- T = time efficiency (actual/planned, with special handling for <15min sessions)
- P = distraction penalty (1 - min(distractions × 0.05, 0.4))

Final score clamped to 0-300
```

## Getting Started

1. Open the project in Xcode 15+
2. Ensure deployment target is iOS 17.0+
3. Build and run on iPhone simulator or device

## Key Design Principles

- **Transparency**: Every score is explainable
- **Reflection**: Every session improves the next
- **Respect**: No dark patterns or manipulation
- **Outcomes**: Time is a proxy; learning is the goal

## Notes

- Fully offline (no network requests)
- No backend or cloud sync
- No social features
- No AI or ML recommendations
- No gamification beyond transparent metrics
