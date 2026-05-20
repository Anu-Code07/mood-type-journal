const TAGS = ['peaceful', 'grateful', 'overwhelmed', 'healing', 'focused', 'late-night'];
const EMOJIS = ['😌', '🙂', '🥹', '😵‍💫', '🔥', '🌧️'];
const TYPE_MODES = [
  { key: 'lowercase', label: 'lowercase' },
  { key: 'uppercase', label: 'UPPERCASE' },
  { key: 'title', label: 'Title Case' },
  { key: 'spacing', label: 'aesthetic spacing' },
  { key: 'poetic', label: 'poetic' },
  { key: 'handwritten', label: 'handwritten' },
  { key: 'kinetic', label: 'kinetic' },
];
const STORAGE_KEY = 'moodtype.timeline.v1';

const appState = {
  text: '',
  emoji: '🙂',
  tags: new Set(),
  mode: 'lowercase',
  analysis: null,
  wallpaper: {
    quote: 'Healing takes time.',
    palette: ['#0e1325', '#173a8d', '#75b4ff'],
    grain: 40,
    blur: 26,
    glow: 34,
  },
  timeline: loadTimeline(),
  deferredInstallPrompt: null,
};

const refs = {
  journalInput: document.getElementById('journalInput'),
  quickTags: document.getElementById('quickTags'),
  emojiRow: document.getElementById('emojiRow'),
  typeModes: document.getElementById('typeModes'),
  typePreview: document.getElementById('typePreview'),
  moodChip: document.getElementById('moodChip'),
  streakChip: document.getElementById('streakChip'),
  grainRange: document.getElementById('grainRange'),
  blurRange: document.getElementById('blurRange'),
  glowRange: document.getElementById('glowRange'),
  canvas: document.getElementById('wallpaperCanvas'),
  timelineList: document.getElementById('timelineList'),
  installButton: document.getElementById('installButton'),
  voiceButton: document.getElementById('voiceButton'),
  analyzeButton: document.getElementById('analyzeButton'),
  saveButton: document.getElementById('saveButton'),
  downloadButton: document.getElementById('downloadButton'),
  shareButton: document.getElementById('shareButton'),
  toast: document.getElementById('toast'),
  progressModal: document.getElementById('progressModal'),
  progressBar: document.getElementById('progressBar'),
  progressLabel: document.getElementById('progressLabel'),
};

init();

function init() {
  renderTagButtons();
  renderEmojiButtons();
  renderModeButtons();
  bindEvents();
  renderTypographyPreview();
  renderTimeline();
  drawWallpaperCanvas();
  updateBackgroundPalette(appState.wallpaper.palette);
  registerServiceWorker();
}

function bindEvents() {
  refs.journalInput.addEventListener('input', (event) => {
    appState.text = event.target.value ?? '';
    renderTypographyPreview();
  });

  refs.grainRange.addEventListener('input', () => {
    appState.wallpaper.grain = Number(refs.grainRange.value);
    drawWallpaperCanvas();
  });

  refs.blurRange.addEventListener('input', () => {
    appState.wallpaper.blur = Number(refs.blurRange.value);
    drawWallpaperCanvas();
  });

  refs.glowRange.addEventListener('input', () => {
    appState.wallpaper.glow = Number(refs.glowRange.value);
    drawWallpaperCanvas();
  });

  refs.analyzeButton.addEventListener('click', handleAnalyzeMood);
  refs.saveButton.addEventListener('click', handleSaveMemory);
  refs.downloadButton.addEventListener('click', handleDownloadWallpaper);
  refs.shareButton.addEventListener('click', handleShareStory);
  refs.voiceButton.addEventListener('click', handleVoiceToText);
  refs.installButton.addEventListener('click', handleInstallPrompt);

  window.addEventListener('beforeinstallprompt', (event) => {
    event.preventDefault();
    appState.deferredInstallPrompt = event;
    refs.installButton.classList.remove('hidden');
  });
}

function renderTagButtons() {
  refs.quickTags.innerHTML = '';
  TAGS.forEach((tag) => {
    const button = document.createElement('button');
    button.className = `tag-btn${appState.tags.has(tag) ? ' active' : ''}`;
    button.type = 'button';
    button.textContent = tag;
    button.addEventListener('click', () => {
      if (appState.tags.has(tag)) {
        appState.tags.delete(tag);
      } else {
        appState.tags.add(tag);
      }
      renderTagButtons();
    });
    refs.quickTags.append(button);
  });
}

function renderEmojiButtons() {
  refs.emojiRow.innerHTML = '';
  EMOJIS.forEach((emoji) => {
    const button = document.createElement('button');
    button.className = `emoji-btn${appState.emoji === emoji ? ' active' : ''}`;
    button.type = 'button';
    button.textContent = emoji;
    button.addEventListener('click', () => {
      appState.emoji = emoji;
      renderEmojiButtons();
    });
    refs.emojiRow.append(button);
  });
}

function renderModeButtons() {
  refs.typeModes.innerHTML = '';
  TYPE_MODES.forEach((mode) => {
    const button = document.createElement('button');
    button.className = `tag-btn${appState.mode === mode.key ? ' active' : ''}`;
    button.type = 'button';
    button.textContent = mode.label;
    button.addEventListener('click', () => {
      appState.mode = mode.key;
      renderModeButtons();
      renderTypographyPreview();
    });
    refs.typeModes.append(button);
  });
}

async function handleAnalyzeMood() {
  const text = appState.text.trim();
  if (!text) {
    showToast('Write a journal moment first.');
    return;
  }

  refs.analyzeButton.disabled = true;
  refs.analyzeButton.textContent = 'Analyzing...';

  await sleep(500);
  appState.analysis = analyzeMoodText(text);

  refs.moodChip.textContent = appState.analysis.theme;
  appState.wallpaper.quote = appState.analysis.quote;
  appState.wallpaper.palette = appState.analysis.palette;
  updateBackgroundPalette(appState.analysis.palette);
  renderTypographyPreview();
  drawWallpaperCanvas();

  refs.analyzeButton.disabled = false;
  refs.analyzeButton.textContent = 'Transform Mood';
  showToast(`Mood detected: ${appState.analysis.mood} · ${appState.analysis.energy} energy`);
}

function handleSaveMemory() {
  if (!appState.analysis) {
    showToast('Transform your mood first.');
    return;
  }

  const entry = {
    id: `mood-${Date.now()}`,
    text: appState.text.trim(),
    emoji: appState.emoji,
    tags: [...appState.tags],
    createdAt: new Date().toISOString(),
    mood: appState.analysis.mood,
    energy: appState.analysis.energy,
    theme: appState.analysis.theme,
    quote: appState.analysis.quote,
    palette: appState.analysis.palette,
    sentiment: appState.analysis.sentiment,
  };

  appState.timeline.unshift(entry);
  appState.timeline = appState.timeline.slice(0, 120);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(appState.timeline));
  renderTimeline();
  showToast('Memory saved to mood timeline.');
}

async function handleDownloadWallpaper() {
  await runExportProgress('Rendering HD wallpaper…');
  const filename = `moodtype-${Date.now()}.png`;

  refs.canvas.toBlob((blob) => {
    if (!blob) {
      showToast('Could not export image.');
      return;
    }
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    URL.revokeObjectURL(url);
    showToast('Wallpaper downloaded.');
  }, 'image/png');
}

async function handleShareStory() {
  await runExportProgress('Building story card…');
  refs.canvas.toBlob(async (blob) => {
    if (!blob) {
      showToast('Share failed. Try downloading instead.');
      return;
    }
    const file = new File([blob], 'moodtype-story.png', { type: 'image/png' });
    if (navigator.share && navigator.canShare?.({ files: [file] })) {
      try {
        await navigator.share({
          title: 'MoodType Journal',
          text: appState.wallpaper.quote,
          files: [file],
        });
      } catch {
        showToast('Share cancelled.');
      }
      return;
    }
    showToast('Native share unavailable. Use download instead.');
  }, 'image/png');
}

async function handleVoiceToText() {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) {
    showToast('Voice input is not supported on this browser.');
    return;
  }

  const recognition = new SpeechRecognition();
  recognition.lang = 'en-US';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  refs.voiceButton.disabled = true;
  refs.voiceButton.textContent = 'Listening...';
  recognition.start();

  recognition.onresult = (event) => {
    const transcript = event.results?.[0]?.[0]?.transcript?.trim();
    if (!transcript) {
      return;
    }
    appState.text = `${appState.text} ${transcript}`.trim();
    refs.journalInput.value = appState.text;
    renderTypographyPreview();
  };

  recognition.onerror = () => {
    showToast('Voice capture failed. Try again.');
  };

  recognition.onend = () => {
    refs.voiceButton.disabled = false;
    refs.voiceButton.textContent = 'Voice to Text';
  };
}

async function handleInstallPrompt() {
  if (!appState.deferredInstallPrompt) {
    showToast('Install prompt is unavailable right now.');
    return;
  }
  appState.deferredInstallPrompt.prompt();
  const choice = await appState.deferredInstallPrompt.userChoice;
  if (choice.outcome === 'accepted') {
    showToast('MoodType added to your home screen.');
  }
  appState.deferredInstallPrompt = null;
  refs.installButton.classList.add('hidden');
}

function renderTypographyPreview() {
  const source = appState.text.trim() || 'i survived today.';
  const transformed = transformText(source, appState.mode);
  refs.typePreview.className = 'type-preview';
  if (appState.mode === 'poetic') {
    refs.typePreview.classList.add('type-poetic');
  }
  if (appState.mode === 'handwritten') {
    refs.typePreview.classList.add('type-handwritten');
  }
  if (appState.mode === 'kinetic') {
    refs.typePreview.classList.add('type-kinetic');
  }

  refs.typePreview.innerHTML = '';
  [...transformed].forEach((char, index) => {
    const span = document.createElement('span');
    span.className = 'type-char';
    span.style.animationDelay = `${index * 35}ms`;
    span.textContent = char;
    refs.typePreview.append(span);
  });
}

function renderTimeline() {
  refs.timelineList.innerHTML = '';

  if (appState.timeline.length === 0) {
    const empty = document.createElement('p');
    empty.className = 'muted';
    empty.textContent = 'Your emotional timeline will appear after the first saved memory.';
    refs.timelineList.append(empty);
    refs.streakChip.textContent = '0 day streak';
    return;
  }

  appState.timeline.slice(0, 20).forEach((item) => {
    const card = document.createElement('article');
    card.className = 'timeline-item';
    card.innerHTML = `
      <p class="timeline-quote">${escapeHtml(item.quote)}</p>
      <p class="timeline-text">${escapeHtml(item.text)}</p>
      <div class="timeline-meta">
        <span>${item.emoji}</span>
        <span>${item.mood}</span>
        <span>${item.energy} energy</span>
        <span>${new Date(item.createdAt).toLocaleDateString()}</span>
      </div>
    `;
    refs.timelineList.append(card);
  });

  refs.streakChip.textContent = `${estimateStreak(appState.timeline)} day streak`;
}

function drawWallpaperCanvas() {
  const canvas = refs.canvas;
  const context = canvas.getContext('2d');
  if (!context) {
    return;
  }
  const { width, height } = canvas;
  const palette = appState.wallpaper.palette;

  const gradient = context.createLinearGradient(0, 0, width, height);
  gradient.addColorStop(0, palette[0]);
  gradient.addColorStop(0.55, palette[1]);
  gradient.addColorStop(1, palette[2]);
  context.fillStyle = gradient;
  context.fillRect(0, 0, width, height);

  context.globalAlpha = 0.22;
  for (let i = 0; i < 8; i += 1) {
    const radius = 220 + Math.random() * 320;
    const x = Math.random() * width;
    const y = Math.random() * height;
    const glow = context.createRadialGradient(x, y, 0, x, y, radius);
    glow.addColorStop(0, 'rgba(255,255,255,0.28)');
    glow.addColorStop(1, 'rgba(255,255,255,0)');
    context.fillStyle = glow;
    context.beginPath();
    context.arc(x, y, radius, 0, Math.PI * 2);
    context.fill();
  }
  context.globalAlpha = 1;

  const grainCount = Math.floor((appState.wallpaper.grain / 100) * 8500);
  context.fillStyle = 'rgba(255,255,255,0.07)';
  for (let i = 0; i < grainCount; i += 1) {
    context.fillRect(Math.random() * width, Math.random() * height, 1, 1);
  }

  const blurAlpha = appState.wallpaper.blur / 100;
  context.fillStyle = `rgba(0,0,0,${0.11 + blurAlpha * 0.35})`;
  context.fillRect(0, 0, width, height);

  context.textBaseline = 'top';
  context.textAlign = 'left';
  context.shadowBlur = 18 + (appState.wallpaper.glow / 100) * 70;
  context.shadowColor = 'rgba(154, 242, 255, 0.72)';
  context.fillStyle = '#f7f9ff';
  context.font = "700 96px 'Space Grotesk', sans-serif";
  drawMultilineText({
    context,
    text: appState.wallpaper.quote || 'Still becoming.',
    x: 88,
    y: height * 0.65,
    maxWidth: width - 176,
    lineHeight: 116,
  });
}

function analyzeMoodText(text) {
  const lower = text.toLowerCase();
  const hasCalm = ['peaceful', 'slow', 'quiet', 'still'].some((word) => lower.includes(word));
  const hasTired = ['tired', 'exhausted', 'drained', 'burnout'].some((word) => lower.includes(word));
  const hasProud = ['proud', 'accomplished', 'won', 'progress'].some((word) => lower.includes(word));
  const hasLost = ['lost', 'empty', 'heavy', 'lonely'].some((word) => lower.includes(word));
  const hasNight = ['night', 'drive', 'rain', 'late'].some((word) => lower.includes(word));

  if (hasCalm) {
    return {
      mood: 'peaceful',
      energy: 'low',
      sentiment: 'positive',
      theme: 'japanese minimal',
      quote: 'Slow days still move your life forward.',
      palette: ['#080e1f', '#17495f', '#9edac0'],
    };
  }
  if (hasTired && hasProud) {
    return {
      mood: 'resilient',
      energy: 'medium',
      sentiment: 'mixed',
      theme: 'dark academia',
      quote: 'You carried the weight and still kept your light.',
      palette: ['#14110f', '#594f43', '#dfd4c4'],
    };
  }
  if (hasLost) {
    return {
      mood: 'healing',
      energy: 'low',
      sentiment: 'negative',
      theme: 'rainy-night aesthetics',
      quote: 'Not every wandering soul is lost.',
      palette: ['#05070f', '#1e3a8a', '#72abf8'],
    };
  }
  if (hasNight) {
    return {
      mood: 'nostalgic',
      energy: 'balanced',
      sentiment: 'mixed',
      theme: 'cyberpunk neon',
      quote: 'Midnight roads remember every version of you.',
      palette: ['#04001f', '#3d17b4', '#25d6f8'],
    };
  }
  return {
    mood: 'reflective',
    energy: 'balanced',
    sentiment: 'mixed',
    theme: 'dreamy pastel',
    quote: 'Your story is still unfolding in beautiful gradients.',
    palette: ['#0f1024', '#7132df', '#f89ec2'],
  };
}

function transformText(input, mode) {
  if (mode === 'lowercase') {
    return input.toLowerCase();
  }
  if (mode === 'uppercase') {
    return input.toUpperCase();
  }
  if (mode === 'title') {
    return input
      .split(/\s+/)
      .filter(Boolean)
      .map((word) => `${word.slice(0, 1).toUpperCase()}${word.slice(1).toLowerCase()}`)
      .join(' ');
  }
  if (mode === 'spacing') {
    return input
      .toUpperCase()
      .split('')
      .join(' ')
      .replaceAll('  ', '   ')
      .trim();
  }
  if (mode === 'poetic') {
    return input.replaceAll('.', ' ·').replaceAll(',', ' /');
  }
  if (mode === 'handwritten') {
    return `${input.toLowerCase()} ~`;
  }
  if (mode === 'kinetic') {
    return input.toUpperCase();
  }
  return input;
}

function drawMultilineText({ context, text, x, y, maxWidth, lineHeight }) {
  const words = text.split(/\s+/);
  let line = '';
  let lineY = y;

  words.forEach((word, index) => {
    const testLine = `${line}${word} `;
    const lineSize = context.measureText(testLine).width;
    if (lineSize > maxWidth && index > 0) {
      context.fillText(line.trim(), x, lineY);
      line = `${word} `;
      lineY += lineHeight;
    } else {
      line = testLine;
    }
  });
  context.fillText(line.trim(), x, lineY);
}

function updateBackgroundPalette(palette) {
  const root = document.documentElement;
  root.style.setProperty('--bg-1', palette[0]);
  root.style.setProperty('--bg-2', palette[1]);
  root.style.setProperty('--bg-3', palette[2]);
}

function loadTimeline() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      return [];
    }
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

function showToast(message) {
  refs.toast.textContent = message;
  refs.toast.classList.remove('hidden');
  window.clearTimeout(showToast.timerId);
  showToast.timerId = window.setTimeout(() => refs.toast.classList.add('hidden'), 2400);
}

async function runExportProgress(label) {
  refs.progressLabel.textContent = label;
  refs.progressBar.style.width = '0%';
  refs.progressModal.classList.remove('hidden');
  refs.progressModal.setAttribute('aria-hidden', 'false');

  for (let step = 1; step <= 10; step += 1) {
    await sleep(80 + Math.random() * 80);
    refs.progressBar.style.width = `${step * 10}%`;
  }

  await sleep(120);
  refs.progressModal.classList.add('hidden');
  refs.progressModal.setAttribute('aria-hidden', 'true');
}

function estimateStreak(entries) {
  const daySet = new Set(
    entries.map((entry) => {
      const date = new Date(entry.createdAt);
      return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
    }),
  );

  let streak = 0;
  const cursor = new Date();
  while (true) {
    const dayKey = `${cursor.getFullYear()}-${cursor.getMonth() + 1}-${cursor.getDate()}`;
    if (!daySet.has(dayKey)) {
      break;
    }
    streak += 1;
    cursor.setDate(cursor.getDate() - 1);
  }
  return streak;
}

function registerServiceWorker() {
  if (!('serviceWorker' in navigator)) {
    return;
  }
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('service-worker.js').catch(() => {
      showToast('Offline mode is unavailable.');
    });
  });
}

function escapeHtml(value) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function sleep(milliseconds) {
  return new Promise((resolve) => window.setTimeout(resolve, milliseconds));
}
