# MoodType Journal

MoodType Journal is a futuristic AI-powered journaling + typography wallpaper studio built with Flutter.

It turns emotional writing into:
- animated typography scenes
- AI-crafted wallpaper concepts
- mood memory timeline cards
- reflective quote artifacts

The product feeling is designed as:
**minimalist Japanese calm + modern glassmorphism + Spotify Wrapped emotion storytelling + Apple-level motion polish**.

---

## Experience Pillars

### 1) AI Journal Input
- Distraction-free writing surface
- Quick mood tags
- Emoji emotion selection
- Voice-to-text integration point
- Ambient animated gradient reacting to mood palette

### 2) Typography Transformation Engine
- Lowercase / UPPERCASE / Title Case
- Aesthetic spacing
- Poetic mode
- Handwritten style mode
- Kinetic mode
- Ripple + wave motion foundations (CustomPainter + animated transforms)

### 3) AI Mood Wallpaper Generator
- Journal text is analyzed for mood, sentiment, energy, and emotional keywords
- A reflective quote is generated
- Wallpaper preview includes:
  - quote placement
  - blur gradients
  - noise/grain texture
  - mood color palette

### 4) Interactive Wallpaper Studio
- Real-time preview
- Grain slider
- Blur slider
- Font selection
- Export integration hooks (gallery/reel/video wallpaper)

### 5) Mood Timeline
- Saved journal + wallpaper memories
- Mood and energy chips
- Emotional history in a cinematic feed format

---

## Architecture (Clean Architecture + BLoC)

```txt
lib/
  core/
    theme/
    widgets/
  features/journal/
    data/
      models/
      datasources/
      repositories/
    domain/
      entities/
      repositories/
      usecases/
    presentation/
      bloc/
      pages/
      widgets/
```

Flow:
`UI -> BLoC Event -> UseCase -> Repository -> Datasource(s)`

This keeps:
- widgets dumb and focused on rendering
- business logic in use cases/data layer
- clear separation for future AI API replacements

---

## Implemented Technical Stack

- `flutter_bloc` for state orchestration
- `CustomPainter` for ripple/grain visual effects
- `flutter_animate` for cinematic entry transitions
- `shared_preferences` for offline-first timeline persistence
- `google_fonts` and Material 3 dark theme customization
- fake AI datasource for deterministic mood analysis scaffolding

---

## Key Files

- `lib/features/journal/presentation/pages/moodtype_home_page.dart`
- `lib/features/journal/presentation/bloc/moodtype_bloc.dart`
- `lib/features/journal/data/datasources/fake_ai_mood_datasource.dart`
- `lib/features/journal/data/datasources/local_journal_datasource.dart`
- `lib/features/journal/presentation/widgets/typography_transformer_panel.dart`
- `lib/features/journal/presentation/widgets/wallpaper_preview_card.dart`

---

## Next Integrations (Production Roadmap)

1. Replace `FakeAiMoodDatasource` with real AI APIs:
   - mood classification
   - sentiment + intensity scoring
   - poetic quote generation
2. Add shader pipeline for liquid typography deformation and neon flicker.
3. Add isolate-based render/export service for HD + ultra wallpaper outputs.
4. Add live wallpaper and animated video export pipeline.
5. Add lockscreen widgets and emotional heatmap calendar.

---

## Run

```bash
flutter pub get
flutter run
```

> Note: This cloud environment did not include Flutter/Dart binaries, so the project was scaffolded directly in source form.
