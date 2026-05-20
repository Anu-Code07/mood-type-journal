# MoodType Journal (PWA)

MoodType Journal is now a **full mobile-first PWA web app**: installable to phone home screen, offline-capable, and designed as an emotional art machine where journal moments become cinematic typography + wallpapers.

## Product Feel

- minimalist Japanese calm
- glassmorphism cards and dreamy gradients
- Spotify Wrapped-style emotional storytelling
- Apple-smooth micro interactions

## Built Features

### 1) AI Journal Input
- clean distraction-free writing area
- quick mood tags
- emoji emotion selector
- voice-to-text (Web Speech API fallback)
- ambient gradient background that shifts with mood palette

### 2) Typography Transformation Engine
- lowercase / UPPERCASE / Title Case
- aesthetic spacing
- poetic mode
- handwritten mode
- kinetic mode
- animated per-letter motion

### 3) AI Mood Wallpaper Studio
- mood/tone/energy sentiment heuristic engine (replaceable with real AI API)
- extracted reflective quote
- wallpaper canvas rendering:
  - mood gradient palette
  - grain/noise
  - blur depth
  - glow intensity

### 4) Interactive Export
- HD wallpaper download from canvas
- story-share flow via Web Share API when available
- cinematic export progress modal

### 5) Mood Timeline
- local saved memory feed
- mood + energy metadata
- simple emotional streak estimate

### 6) PWA Install + Offline
- `manifest.webmanifest` for installability
- `service-worker.js` for app-shell caching and offline fallback
- `offline.html` fallback page

---

## File Structure

```txt
/
  index.html
  styles.css
  app.js
  manifest.webmanifest
  service-worker.js
  offline.html
  assets/icons/
```

---

## Run Locally

No build step is required.

```bash
python3 -m http.server 4173
```

Then open:
`http://localhost:4173`

> For service worker testing, use `localhost` (secure context rules).

---

## PWA Install (Phone Shortcut)

1. Open the site in Chrome/Safari mobile.
2. Use **Add to Home Screen** (or install prompt button if available).
3. Launch it from the new home screen icon in standalone mode.

---

## Next Production Upgrades

1. Replace heuristic mood parser with LLM sentiment/mood API.
2. Add shader/WebGL typography deformation for liquid/elastic effects.
3. Add worker-based ultra export pipeline and short video rendering.
4. Add lockscreen widgets and emotional heatmap calendar.
