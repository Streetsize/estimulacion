<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CALISTENIA — Tracker</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&family=Syne:wght@400;600;700;800&family=Instrument+Serif:ital@0;1&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #0a0a0c;
    --bg2: #111115;
    --bg3: #1a1a20;
    --border: #2a2a35;
    --border2: #3a3a48;
    --text: #e8e8f0;
    --muted: #6a6a80;
    --accent: #c8f545;
    --accent2: #f5c845;
    --accent3: #45c8f5;
    --danger: #f54545;
    --push: #f5a845;
    --pull: #45c8f5;
    --legs: #c845f5;
    --full: #c8f545;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Mono', monospace;
    min-height: 100vh;
    overflow-x: hidden;
  }

  /* GRAIN OVERLAY */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");
    pointer-events: none;
    z-index: 9999;
    opacity: 0.5;
  }

  /* ── NAV ─────────────────────────────── */
  nav {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 16px;
    border-bottom: 1px solid var(--border);
    position: sticky;
    top: 0;
    background: rgba(10,10,12,0.95);
    backdrop-filter: blur(12px);
    z-index: 100;
    gap: 8px;
  }
  .nav-logo {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 15px;
    letter-spacing: -0.5px;
    color: var(--accent);
    flex-shrink: 0;
  }
  .nav-tabs { display: flex; gap: 3px; flex-wrap: wrap; }
  .nav-tab {
    background: none;
    border: 1px solid transparent;
    color: var(--muted);
    font-family: 'DM Mono', monospace;
    font-size: 10px;
    padding: 5px 9px;
    cursor: pointer;
    border-radius: 4px;
    transition: all 0.2s;
    letter-spacing: 0.3px;
    text-transform: uppercase;
    white-space: nowrap;
  }
  .nav-tab:hover { color: var(--text); border-color: var(--border); }
  .nav-tab.active { color: var(--accent); border-color: var(--accent); background: rgba(200,245,69,0.06); }

  /* ── FRASE ───────────────────────────── */
  .frase-banner {
    margin: 14px 16px 0;
    border: 1px solid var(--border);
    padding: 12px 16px;
    background: var(--bg2);
    border-radius: 6px;
    position: relative;
    overflow: hidden;
  }
  .frase-banner::before {
    content: '';
    position: absolute;
    left: 0; top: 0; bottom: 0;
    width: 3px;
    background: var(--accent);
  }
  .frase-label { font-size: 9px; letter-spacing: 2px; color: var(--muted); text-transform: uppercase; margin-bottom: 6px; }
  .frase-text { font-family: 'Instrument Serif', serif; font-style: italic; font-size: 13px; color: var(--text); line-height: 1.55; }
  .frase-cat { font-size: 9px; color: var(--accent); margin-top: 6px; letter-spacing: 1px; text-transform: uppercase; }

  /* ── PAGES ───────────────────────────── */
  .page { display: none; padding: 16px 16px 100px; }
  .page.active { display: block; }

  /* ── HOME ────────────────────────────── */
  .page-title { font-family: 'Syne', sans-serif; font-size: 22px; font-weight: 800; margin-bottom: 5px; letter-spacing: -0.5px; }
  .page-subtitle { color: var(--muted); font-size: 11px; margin-bottom: 20px; }

  .week-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 4px;
    margin-bottom: 24px;
  }
  .week-day {
    text-align: center;
    padding: 8px 2px;
    border: 1px solid var(--border);
    border-radius: 5px;
    font-size: 9px;
    background: var(--bg2);
    overflow: hidden;
  }
  .week-day .day-name { color: var(--muted); margin-bottom: 3px; }
  .week-day .day-type { font-weight: 500; font-size: 8px; }
  .week-day.push .day-type { color: var(--push); }
  .week-day.pull .day-type { color: var(--pull); }
  .week-day.legs .day-type { color: var(--legs); }
  .week-day.full .day-type { color: var(--full); }
  .week-day.rest .day-type { color: var(--muted); }
  .week-day.today { border-color: var(--accent); }

  .rutinas-grid { display: grid; grid-template-columns: 1fr; gap: 12px; }

  .rutina-card {
    border: 1px solid var(--border);
    background: var(--bg2);
    border-radius: 8px;
    padding: 18px;
    cursor: pointer;
    transition: all 0.25s;
    position: relative;
    overflow: hidden;
  }
  .rutina-card::after { content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 2px; transition: opacity 0.25s; opacity: 0; }
  .rutina-card.push::after { background: var(--push); }
  .rutina-card.pull::after { background: var(--pull); }
  .rutina-card.legs::after { background: var(--legs); }
  .rutina-card.full::after { background: var(--full); }
  .rutina-card:hover { border-color: var(--border2); }
  .rutina-card:hover::after { opacity: 1; }

  .rutina-day { font-size: 10px; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 6px; }
  .rutina-card.push .rutina-day { color: var(--push); }
  .rutina-card.pull .rutina-day { color: var(--pull); }
  .rutina-card.legs .rutina-day { color: var(--legs); }
  .rutina-card.full .rutina-day { color: var(--full); }

  .rutina-name { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 6px; }
  .rutina-desc { font-size: 11px; color: var(--muted); margin-bottom: 12px; line-height: 1.6; }
  .rutina-exercises { font-size: 10px; color: var(--muted); margin-bottom: 14px; }

  /* ── BUTTONS ─────────────────────────── */
  .btn {
    background: none;
    border: 1px solid var(--border);
    color: var(--text);
    font-family: 'DM Mono', monospace;
    font-size: 11px;
    padding: 9px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.2s;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    touch-action: manipulation;
  }
  .btn:hover { border-color: var(--border2); background: var(--bg3); }
  .btn-accent { background: var(--accent); color: #0a0a0c; border-color: var(--accent); font-weight: 500; }
  .btn-accent:hover { background: #d8ff55; border-color: #d8ff55; }
  .btn-sm { padding: 7px 12px; font-size: 10px; }
  .btn-danger { border-color: var(--danger); color: var(--danger); }
  .btn-danger:hover { background: rgba(245,69,69,0.1); }

  /* ── WORKOUT SCREEN ──────────────────── */
  #workout-screen {
    display: none;
    position: fixed;
    inset: 0;
    background: var(--bg);
    z-index: 200;
    overflow-y: auto;
    overflow-x: hidden;
    padding: 16px 16px 40px;
  }
  #workout-screen.active { display: block; }

  .workout-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    margin-bottom: 16px;
    gap: 12px;
  }
  .workout-day-label { font-size: 9px; letter-spacing: 2px; text-transform: uppercase; color: var(--muted); margin-bottom: 3px; }
  .workout-title { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; letter-spacing: -0.5px; }

  .progress-bar-wrap { background: var(--bg2); border-radius: 2px; height: 3px; margin-bottom: 16px; overflow: hidden; }
  .progress-bar-fill { height: 100%; background: var(--accent); border-radius: 2px; transition: width 0.4s ease; }

  /* ── EXERCISE LAYOUT ─────────────────── */
  /* Mobile: single column, timer below card */
  .exercise-main { display: flex; flex-direction: column; gap: 14px; margin-bottom: 14px; }

  /* ── EXERCISE CARD ───────────────────── */
  .exercise-card {
    border: 1px solid var(--border);
    background: var(--bg2);
    border-radius: 10px;
    padding: 16px;
    width: 100%;
    min-width: 0;
  }

  .exercise-num { font-size: 9px; letter-spacing: 2px; color: var(--muted); text-transform: uppercase; margin-bottom: 6px; }
  .exercise-name { font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 700; letter-spacing: -0.3px; margin-bottom: 10px; line-height: 1.2; }

  .exercise-meta { display: flex; gap: 14px; margin-bottom: 14px; flex-wrap: wrap; }
  .exercise-meta-item { display: flex; flex-direction: column; gap: 2px; }
  .meta-label { font-size: 9px; color: var(--muted); letter-spacing: 1px; text-transform: uppercase; }
  .meta-value { font-size: 14px; font-weight: 500; color: var(--accent); }

  .exercise-tip {
    border: 1px solid var(--border);
    background: var(--bg3);
    border-radius: 6px;
    padding: 10px 12px;
    font-size: 11px;
    color: var(--muted);
    line-height: 1.7;
    margin-bottom: 14px;
    word-break: break-word;
  }
  .exercise-tip strong { color: var(--text); }

  .progression-hint { font-size: 10px; color: var(--accent2); display: flex; align-items: flex-start; gap: 6px; margin-bottom: 14px; line-height: 1.4; }

  /* ── SERIES ──────────────────────────── */
  .series-section { margin-bottom: 14px; }
  .series-label { font-size: 9px; letter-spacing: 1px; text-transform: uppercase; color: var(--muted); margin-bottom: 8px; }
  .series-row {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 6px;
    padding: 10px 12px;
    background: var(--bg3);
    border-radius: 6px;
    border: 1px solid var(--border);
  }
  .series-badge {
    width: 26px; height: 26px;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 10px; font-weight: 500;
    background: var(--bg);
    border: 1px solid var(--border2);
    color: var(--muted);
    flex-shrink: 0;
  }
  .series-badge.done { background: var(--accent); color: #0a0a0c; border-color: var(--accent); }
  .series-input {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 4px;
    color: var(--text);
    font-family: 'DM Mono', monospace;
    font-size: 16px; /* 16px prevents iOS zoom */
    padding: 6px 8px;
    width: 64px;
    text-align: center;
    flex-shrink: 0;
  }
  .series-input:focus { outline: none; border-color: var(--accent2); }
  .series-unit { font-size: 11px; color: var(--muted); }
  .series-check {
    margin-left: auto;
    background: none;
    border: 1px solid var(--border);
    color: var(--muted);
    width: 36px; height: 36px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition: all 0.2s;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
    touch-action: manipulation;
  }
  .series-check:hover { border-color: var(--accent); color: var(--accent); }
  .series-check.done { background: var(--accent); border-color: var(--accent); color: #0a0a0c; }

  /* ── TIMER CARD ──────────────────────── */
  .timer-card {
    border: 1px solid var(--border);
    background: var(--bg2);
    border-radius: 10px;
    padding: 16px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
  }
  .timer-label { font-size: 9px; letter-spacing: 2px; text-transform: uppercase; color: var(--muted); text-align: center; width: 100%; }

  .timer-ring { width: 90px; height: 90px; position: relative; flex-shrink: 0; }
  .timer-ring svg { transform: rotate(-90deg); display: block; }
  .timer-ring circle { fill: none; stroke-width: 4; }
  .timer-ring .bg-ring { stroke: var(--border); }
  .timer-ring .fg-ring { stroke: var(--accent); stroke-linecap: round; transition: stroke-dashoffset 1s linear, stroke 0.3s; }
  .timer-inner { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; flex-direction: column; }
  .timer-number { font-family: 'Syne', sans-serif; font-size: 24px; font-weight: 800; line-height: 1; }
  .timer-small { font-size: 8px; color: var(--muted); letter-spacing: 1px; }

  .timer-controls { display: flex; flex-direction: column; gap: 8px; flex: 1; min-width: 0; }
  .rest-presets { display: flex; gap: 5px; flex-wrap: wrap; }
  .rest-btn {
    background: var(--bg3); border: 1px solid var(--border); color: var(--text);
    font-family: 'DM Mono', monospace; font-size: 10px; padding: 6px 10px;
    border-radius: 4px; cursor: pointer; transition: all 0.2s; touch-action: manipulation;
  }
  .rest-btn:hover { border-color: var(--accent); color: var(--accent); }
  .rest-btn.active { border-color: var(--accent); color: var(--accent); background: rgba(200,245,69,0.08); }

  .custom-rest { display: flex; align-items: center; gap: 6px; }
  .rest-custom-input {
    width: 58px; background: var(--bg3); border: 1px solid var(--border); border-radius: 4px;
    color: var(--text); font-family: 'DM Mono', monospace; font-size: 14px; padding: 5px 8px; text-align: center;
  }
  .rest-custom-input:focus { outline: none; border-color: var(--accent2); }

  /* ── WORKOUT CONTROLS ────────────────── */
  .workout-controls {
    display: flex;
    gap: 8px;
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px solid var(--border);
  }
  .workout-controls .btn { flex: 1; text-align: center; }

  /* ── NOTES ───────────────────────────── */
  .notes-input {
    width: 100%;
    background: var(--bg3);
    border: 1px solid var(--border);
    border-radius: 6px;
    color: var(--text);
    font-family: 'DM Mono', monospace;
    font-size: 14px; /* prevent iOS zoom */
    padding: 10px 12px;
    resize: vertical;
    min-height: 60px;
    margin-top: 10px;
  }
  .notes-input:focus { outline: none; border-color: var(--border2); }

  /* ── DESKTOP UPGRADES ────────────────── */
  @media (min-width: 600px) {
    nav { padding: 14px 28px; }
    .nav-logo { font-size: 17px; }
    .nav-tab { font-size: 11px; padding: 6px 13px; }
    .frase-banner { margin: 20px 28px 0; padding: 14px 20px; }
    .frase-text { font-size: 14px; }
    .page { padding: 22px 28px 80px; }
    .page-title { font-size: 26px; }
    .week-grid { gap: 6px; }
    .week-day { padding: 10px 4px; font-size: 10px; }
    .week-day .day-type { font-size: 9px; }
    .rutinas-grid { grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 14px; }
    .rutina-card { padding: 20px; }
    .rutina-name { font-size: 22px; }
    #workout-screen { padding: 22px 28px 40px; }
    .workout-title { font-size: 24px; }
    .exercise-card { padding: 22px; }
    .exercise-name { font-size: 22px; }
    .timer-card { flex-direction: column; padding: 20px; }
    .timer-ring { width: 120px; height: 120px; }
    .timer-number { font-size: 32px; }
  }

  @media (min-width: 900px) {
    nav { padding: 16px 36px; }
    .nav-logo { font-size: 18px; }
    .frase-banner { margin: 24px 36px 0; }
    .page { padding: 24px 36px 80px; }
    .page-title { font-size: 28px; }
    #workout-screen { padding: 24px 36px 40px; }
    .exercise-main { flex-direction: row; align-items: flex-start; }
    .exercise-main > *:first-child { flex: 1; min-width: 0; }
    .exercise-main > *:last-child { width: 300px; flex-shrink: 0; position: sticky; top: 20px; }
    .timer-card { flex-direction: column; }
    .timer-ring { width: 140px; height: 140px; }
    .timer-number { font-size: 36px; }
    .exercise-name { font-size: 24px; }
    .exercise-card { padding: 26px; }
  }

  /* REST OVERLAY */
  #rest-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(10,10,12,0.92); backdrop-filter: blur(16px);
    z-index: 300; align-items: center; justify-content: center;
    flex-direction: column; text-align: center; padding: 20px;
  }
  #rest-overlay.active { display: flex; }
  .rest-overlay-title { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: var(--muted); margin-bottom: 16px; }
  .rest-overlay-next { font-size: 12px; color: var(--muted); margin-top: 12px; }
  .rest-overlay-next strong { color: var(--text); }
  .rest-skip-btn {
    margin-top: 24px; background: none; border: 1px solid var(--border); color: var(--muted);
    font-family: 'DM Mono', monospace; font-size: 10px; padding: 10px 24px;
    border-radius: 4px; cursor: pointer; letter-spacing: 1px; text-transform: uppercase; transition: all 0.2s;
    touch-action: manipulation;
  }
  .rest-skip-btn:hover { color: var(--text); border-color: var(--border2); }

  /* PROFILE PAGE */
  .profile-grid { display: grid; grid-template-columns: 1fr; gap: 16px; margin-top: 8px; }
  @media (min-width: 760px) { .profile-grid { grid-template-columns: 300px 1fr; gap: 20px; } }

  .profile-card { border: 1px solid var(--border); background: var(--bg2); border-radius: 10px; padding: 18px; }
  @media (min-width: 600px) { .profile-card { padding: 22px; } }
  .profile-avatar { width: 54px; height: 54px; border-radius: 50%; background: var(--bg3); border: 2px solid var(--accent); display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 12px; }
  .profile-name { font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 700; margin-bottom: 4px; }
  .profile-role { font-size: 11px; color: var(--muted); margin-bottom: 16px; }
  .profile-field { margin-bottom: 14px; }
  .field-label { font-size: 9px; letter-spacing: 2px; text-transform: uppercase; color: var(--muted); margin-bottom: 5px; }
  .field-input { width: 100%; background: var(--bg3); border: 1px solid var(--border); border-radius: 4px; color: var(--text); font-family: 'DM Mono', monospace; font-size: 16px; padding: 8px 12px; }
  .field-input:focus { outline: none; border-color: var(--accent2); }
  .bmi-display { margin-top: 16px; padding: 14px; background: var(--bg3); border-radius: 6px; text-align: center; border: 1px solid var(--border); }
  .bmi-value { font-family: 'Syne', sans-serif; font-size: 30px; font-weight: 800; color: var(--accent); }
  .bmi-label { font-size: 10px; color: var(--muted); }
  .bmi-category { font-size: 12px; margin-top: 4px; }

  /* STATS / CHARTS */
  .stats-section { margin-bottom: 20px; }
  .stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; }
  @media (min-width: 600px) { .stats-grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); } }
  .stat-box { border: 1px solid var(--border); background: var(--bg2); border-radius: 8px; padding: 14px; text-align: center; }
  .stat-number { font-family: 'Syne', sans-serif; font-size: 26px; font-weight: 800; color: var(--accent); }
  .stat-label { font-size: 10px; color: var(--muted); margin-top: 4px; letter-spacing: 0.5px; }
  .chart-card { border: 1px solid var(--border); background: var(--bg2); border-radius: 10px; padding: 16px; margin-bottom: 16px; }
  @media (min-width: 600px) { .chart-card { padding: 22px; } }
  .chart-title { font-family: 'Syne', sans-serif; font-size: 14px; font-weight: 700; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
  .chart-title .dot { width: 8px; height: 8px; border-radius: 50%; }
  canvas { width: 100% !important; max-width: 100%; }
  .chart-tabs { display: flex; gap: 5px; margin-bottom: 14px; flex-wrap: wrap; }
  .chart-tab { background: none; border: 1px solid var(--border); color: var(--muted); font-family: 'DM Mono', monospace; font-size: 10px; padding: 5px 10px; border-radius: 4px; cursor: pointer; letter-spacing: 0.5px; transition: all 0.2s; touch-action: manipulation; }
  .chart-tab:hover { color: var(--text); border-color: var(--border2); }
  .chart-tab.active { color: var(--accent); border-color: var(--accent); background: rgba(200,245,69,0.06); }

  /* HISTORIAL */
  .historial-list { display: flex; flex-direction: column; gap: 8px; }
  .historial-item { border: 1px solid var(--border); background: var(--bg2); border-radius: 8px; padding: 12px 14px; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
  .hist-dot { width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0; }
  .hist-info { flex: 1; min-width: 0; }
  .hist-title { font-size: 13px; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .hist-date { font-size: 10px; color: var(--muted); margin-top: 2px; line-height: 1.4; }
  .hist-badge { font-size: 10px; padding: 3px 8px; border-radius: 3px; font-weight: 500; flex-shrink: 0; }

  /* CONFIRM MODAL */
  #confirm-modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(10,10,12,0.85);
    backdrop-filter: blur(8px);
    z-index: 9000;
    align-items: center;
    justify-content: center;
  }
  #confirm-modal.active { display: flex; }
  .confirm-box {
    background: var(--bg2);
    border: 1px solid var(--border2);
    border-radius: 10px;
    padding: 28px 32px;
    max-width: 360px;
    width: 90%;
    text-align: center;
  }
  .confirm-title {
    font-family: 'Syne', sans-serif;
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 8px;
  }
  .confirm-msg { font-size: 12px; color: var(--muted); margin-bottom: 22px; line-height: 1.6; }
  .confirm-btns { display: flex; gap: 10px; justify-content: center; }

  /* TOAST */
  #toast {
    position: fixed;
    bottom: 28px;
    right: 28px;
    background: var(--bg3);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 12px 18px;
    font-size: 12px;
    z-index: 500;
    transform: translateY(80px);
    opacity: 0;
    transition: all 0.3s;
    max-width: 300px;
  }
  #toast.show { transform: translateY(0); opacity: 1; }
  #toast.success { border-color: var(--accent); color: var(--accent); }
  #toast.error { border-color: var(--danger); color: var(--danger); }

  /* EXERCISE LIST SIDEBAR */
  .exercise-list-sidebar {
    display: flex;
    flex-direction: column;
    gap: 6px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid var(--border);
  }
  .ex-sidebar-item {
    padding: 8px 12px;
    border-radius: 4px;
    font-size: 11px;
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    color: var(--muted);
    transition: all 0.2s;
    border: 1px solid transparent;
  }
  .ex-sidebar-item:hover { color: var(--text); background: var(--bg3); }
  .ex-sidebar-item.current { color: var(--text); border-color: var(--border); background: var(--bg3); }
  .ex-sidebar-item.done { color: var(--accent); }
  .ex-sidebar-item.done::before { content: '✓'; color: var(--accent); font-size: 10px; }

  /* MUSCLE FOCUS */
  /* EXERCISE LIST SIDEBAR */
  .exercise-list-sidebar { display: flex; flex-direction: column; gap: 5px; margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border); }
  .ex-sidebar-item { padding: 8px 12px; border-radius: 4px; font-size: 11px; display: flex; align-items: center; gap: 8px; cursor: pointer; color: var(--muted); transition: all 0.2s; border: 1px solid transparent; touch-action: manipulation; }
  .ex-sidebar-item:hover { color: var(--text); background: var(--bg3); }
  .ex-sidebar-item.current { color: var(--text); border-color: var(--border); background: var(--bg3); }
  .ex-sidebar-item.done { color: var(--accent); }
  .ex-sidebar-item.done::before { content: '✓'; color: var(--accent); font-size: 10px; }

  /* MUSCLE TAGS */
  .muscle-tags { display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 12px; }
  .muscle-tag { font-size: 9px; padding: 3px 9px; border-radius: 12px; border: 1px solid var(--border2); color: var(--muted); letter-spacing: 0.5px; text-transform: uppercase; }

  .section-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; margin-top: 22px; }
  .section-title { font-family: 'Syne', sans-serif; font-size: 14px; font-weight: 700; letter-spacing: -0.3px; }

  /* SCROLLBAR */
  ::-webkit-scrollbar { width: 4px; height: 4px; }
  ::-webkit-scrollbar-track { background: var(--bg); }
  ::-webkit-scrollbar-thumb { background: var(--border2); border-radius: 2px; }

  /* ANIMATIONS */
  @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
  .page.active { animation: fadeIn 0.3s ease; }

  /* WORKOUT COMPLETE */
  .workout-complete-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(10,10,12,0.95); backdrop-filter: blur(20px);
    z-index: 400; align-items: center; justify-content: center;
    flex-direction: column; text-align: center; padding: 24px;
  }
  .workout-complete-overlay.active { display: flex; animation: fadeIn 0.5s ease; }
  .complete-emoji { font-size: 52px; margin-bottom: 16px; }
  .complete-title { font-family: 'Syne', sans-serif; font-size: 32px; font-weight: 800; color: var(--accent); letter-spacing: -1.5px; margin-bottom: 6px; }
  @media (min-width: 500px) { .complete-title { font-size: 40px; } }
  .complete-subtitle { color: var(--muted); font-size: 12px; margin-bottom: 22px; }
  .complete-stats { display: flex; gap: 20px; margin-bottom: 26px; flex-wrap: wrap; justify-content: center; }
  .complete-stat { text-align: center; }
  .complete-stat-num { font-family: 'Syne', sans-serif; font-size: 26px; font-weight: 800; color: var(--accent2); }
  .complete-stat-label { font-size: 10px; color: var(--muted); letter-spacing: 1px; }

  /* PESO TRACKER */
  .peso-entry { display: flex; gap: 8px; margin-bottom: 10px; }

  /* CONFIRM MODAL */
  #confirm-modal { display: none; position: fixed; inset: 0; background: rgba(10,10,12,0.85); backdrop-filter: blur(8px); z-index: 9000; align-items: center; justify-content: center; padding: 20px; }
  #confirm-modal.active { display: flex; }
  .confirm-box { background: var(--bg2); border: 1px solid var(--border2); border-radius: 10px; padding: 24px 22px; max-width: 360px; width: 100%; text-align: center; }
  .confirm-title { font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 700; margin-bottom: 8px; }
  .confirm-msg { font-size: 12px; color: var(--muted); margin-bottom: 20px; line-height: 1.6; }
  .confirm-btns { display: flex; gap: 10px; justify-content: center; }

  /* TOAST */
  #toast { position: fixed; bottom: 20px; right: 16px; left: 16px; background: var(--bg3); border: 1px solid var(--border); border-radius: 6px; padding: 12px 16px; font-size: 12px; z-index: 500; transform: translateY(80px); opacity: 0; transition: all 0.3s; text-align: center; }
  @media (min-width: 500px) { #toast { left: auto; max-width: 300px; } }
  #toast.show { transform: translateY(0); opacity: 1; }
  #toast.success { border-color: var(--accent); color: var(--accent); }
  #toast.error { border-color: var(--danger); color: var(--danger); }
</style>
</head>
<body>

<nav>
  <div class="nav-logo">CALI°TRACKER</div>
  <div class="nav-tabs">
    <button class="nav-tab active" onclick="showPage('home')">Rutinas</button>
    <button class="nav-tab" onclick="showPage('historial')">Historial</button>
    <button class="nav-tab" onclick="showPage('stats')">Stats</button>
    <button class="nav-tab" onclick="showPage('profile')">Perfil</button>
  </div>
  <div id="sync-status" style="font-size:9px;letter-spacing:1px;flex-shrink:0;display:none"></div>
</nav>

<!-- FRASE DEL DIA -->
<div class="frase-banner" id="frase-banner">
  <div class="frase-label">// frase del día</div>
  <div class="frase-text" id="frase-text">Cargando...</div>
  <div class="frase-cat" id="frase-cat"></div>
</div>

<!-- PAGES -->

<!-- HOME -->
<div class="page active" id="page-home">
  <div class="page-title" style="margin-top:24px">Tu semana.</div>
  <div class="page-subtitle">4 días de entrenamiento · Push · Pull · Legs · Full Body</div>
  
  <div class="week-grid" id="week-grid"></div>

  <div class="section-header">
    <div class="section-title">Sesiones</div>
  </div>
  <div class="rutinas-grid" id="rutinas-grid"></div>
</div>

<!-- HISTORIAL -->
<div class="page" id="page-historial">
  <div class="page-title" style="margin-top:24px">Historial</div>
  <div class="page-subtitle">Todos tus entrenamientos registrados</div>
  <div class="historial-list" id="historial-list"></div>
</div>

<!-- STATS -->
<div class="page" id="page-stats">
  <div class="page-title" style="margin-top:24px">Progresión</div>
  <div class="page-subtitle">Seguimiento fisiológico · Volumen · Frecuencia · IMC</div>
  
  <div class="stats-grid" id="stats-grid"></div>

  <div class="chart-card">
    <div class="chart-title">
      <span class="dot" style="background:var(--accent)"></span>
      Volumen Semanal (series totales)
    </div>
    <canvas id="chart-volumen" height="180"></canvas>
  </div>

  <div class="chart-card">
    <div class="chart-title">
      <span class="dot" style="background:var(--accent2)"></span>
      Progresión por Ejercicio
    </div>
    <div class="chart-tabs" id="exercise-tabs"></div>
    <canvas id="chart-ejercicio" height="180"></canvas>
  </div>

  <div class="chart-card">
    <div class="chart-title">
      <span class="dot" style="background:var(--accent3)"></span>
      Peso Corporal
    </div>
    <canvas id="chart-peso" height="180"></canvas>
  </div>

  <div class="chart-card">
    <div class="chart-title">
      <span class="dot" style="background:var(--legs)"></span>
      Frecuencia por Grupo Muscular
    </div>
    <canvas id="chart-frecuencia" height="180"></canvas>
  </div>
</div>

<!-- PROFILE -->
<div class="page" id="page-profile">
  <div class="page-title" style="margin-top:24px">Perfil</div>
  <div class="page-subtitle">Datos personales y seguimiento antropométrico</div>
  
  <div class="profile-grid">
    <div>
      <div class="profile-card" style="margin-bottom:16px">
        <div class="profile-avatar">🏋️</div>
        <div class="profile-name" id="profile-name-display">Diego</div>
        <div class="profile-role">Médico en formación · Mendoza</div>
        
        <div class="profile-field">
          <div class="field-label">Nombre</div>
          <input class="field-input" id="input-nombre" value="Diego" onchange="saveProfile()">
        </div>
        <div class="profile-field">
          <div class="field-label">Peso actual (kg)</div>
          <div style="display:flex;gap:8px">
            <input class="field-input" id="input-peso" type="number" step="0.1" placeholder="75.0" oninput="calcBMI(); saveProfile()">
            <button class="btn btn-sm" onclick="logPeso()">+</button>
          </div>
        </div>
        <div class="profile-field">
          <div class="field-label">Talla (cm)</div>
          <input class="field-input" id="input-talla" type="number" step="0.5" placeholder="175" oninput="calcBMI(); saveProfile()">
        </div>
        <div class="profile-field">
          <div class="field-label">Edad</div>
          <input class="field-input" id="input-edad" type="number" placeholder="25" oninput="saveProfile()">
        </div>
        <div class="profile-field">
          <div class="field-label">Objetivo calórico diario (kcal)</div>
          <input class="field-input" id="input-kcal" type="number" placeholder="2600" oninput="saveProfile()">
        </div>
        <div class="profile-field">
          <div class="field-label">Objetivo proteína (g/día)</div>
          <input class="field-input" id="input-proteina" type="number" placeholder="130" oninput="saveProfile()">
        </div>

        <div class="bmi-display">
          <div class="bmi-value" id="bmi-value">—</div>
          <div class="bmi-label">IMC</div>
          <div class="bmi-category" id="bmi-cat">Completá tus datos</div>
        </div>

        <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--border)">
          <div class="field-label" style="margin-bottom:8px">Google Sheets Sync</div>
          <button class="btn btn-sm" style="width:100%" onclick="manualSync()">↺ Sincronizar ahora</button>
        </div>
      </div>

      <div class="profile-card">
        <div class="section-title" style="margin-bottom:12px">🥚 Nutrición recordatorio</div>
        <div id="nutri-info" style="font-size:12px;line-height:1.9;color:var(--muted)">
          Completá tu peso y objetivo para ver tus metas.
        </div>
      </div>
    </div>

    <div>
      <div class="profile-card">
        <div class="section-title" style="margin-bottom:12px">📊 Registro de peso</div>
        <canvas id="chart-peso-profile" height="200"></canvas>
        <div id="peso-historial-list" style="margin-top:14px;font-size:11px;color:var(--muted);max-height:180px;overflow-y:auto;"></div>
      </div>
    </div>
  </div>
</div>

<!-- WORKOUT SCREEN -->
<div id="workout-screen">
  <div class="workout-header">
    <div>
      <div class="workout-day-label" id="ws-day-label"></div>
      <div class="workout-title" id="ws-title"></div>
    </div>
    <div style="display:flex;gap:8px;align-items:center">
      <div id="ws-elapsed" style="font-size:12px;color:var(--muted)">00:00</div>
      <button class="btn btn-sm btn-danger" onclick="confirmAbort()">Salir</button>
    </div>
  </div>
  <div class="progress-bar-wrap">
    <div class="progress-bar-fill" id="ws-progress"></div>
  </div>

  <div class="exercise-main">
    <div id="ws-exercise-main"></div>
    <div class="timer-card">
      <div class="timer-label">Descanso</div>
      <div class="timer-ring">
        <svg viewBox="0 0 140 140" style="width:100%;height:100%">
          <circle class="bg-ring" cx="70" cy="70" r="64"/>
          <circle class="fg-ring" id="timer-ring-fg" cx="70" cy="70" r="64"
            stroke-dasharray="402.1" stroke-dashoffset="0"/>
        </svg>
        <div class="timer-inner">
          <div class="timer-number" id="timer-num">—</div>
          <div class="timer-small" id="timer-small">seg</div>
        </div>
      </div>
      <div class="timer-controls">
        <div class="rest-presets">
          <button class="rest-btn" onclick="setRest(60)">60s</button>
          <button class="rest-btn active" id="rest-90" onclick="setRest(90)">90s</button>
          <button class="rest-btn" onclick="setRest(120)">120s</button>
          <button class="rest-btn" onclick="setRest(180)">180s</button>
        </div>
        <div class="custom-rest">
          <input class="rest-custom-input" id="rest-custom" type="number" placeholder="seg" min="10" max="600">
          <button class="btn btn-sm" onclick="setCustomRest()">Set</button>
        </div>
        <button class="btn btn-sm" id="timer-btn" onclick="startRestTimer()" style="width:100%">Iniciar descanso</button>
      </div>
    </div>
  </div>

  <div class="exercise-list-sidebar" id="ws-ex-list"></div>

  <div class="workout-controls">
    <button class="btn" id="btn-prev" onclick="prevExercise()">← Anterior</button>
    <button class="btn btn-accent" id="btn-next" onclick="nextExercise()">Siguiente →</button>
  </div>
</div>

<!-- REST OVERLAY -->
<div id="rest-overlay">
  <div class="rest-overlay-title">// descanso activo</div>
  <div class="timer-ring" style="width:min(180px,60vw);height:min(180px,60vw)">
    <svg viewBox="0 0 200 200" style="width:100%;height:100%">
      <circle class="bg-ring" cx="100" cy="100" r="90"/>
      <circle class="fg-ring" id="rest-ring-fg" cx="100" cy="100" r="90"
        stroke-dasharray="565.5" stroke-dashoffset="0"/>
    </svg>
    <div class="timer-inner">
      <div class="timer-number" id="rest-num" style="font-size:52px">—</div>
      <div class="timer-small">seg</div>
    </div>
  </div>
  <div class="rest-overlay-next" id="rest-next-label"></div>
  <button class="rest-skip-btn" onclick="skipRest()">Saltar descanso</button>
</div>

<!-- WORKOUT COMPLETE -->
<div class="workout-complete-overlay" id="complete-overlay">
  <div class="complete-emoji">🔥</div>
  <div class="complete-title">¡Sesión completa!</div>
  <div class="complete-subtitle" id="complete-subtitle"></div>
  <div class="complete-stats" id="complete-stats"></div>
  <div style="display:flex;gap:10px">
    <button class="btn btn-accent" onclick="finishWorkout()">Guardar y salir</button>
    <button class="btn" onclick="closeComplete()">Ver resumen</button>
  </div>
</div>

<!-- CONFIRM MODAL -->
<div id="confirm-modal">
  <div class="confirm-box">
    <div class="confirm-title">¿Salir del entrenamiento?</div>
    <div class="confirm-msg">Las series registradas en esta sesión se perderán si salís sin guardar.</div>
    <div class="confirm-btns">
      <button class="btn" onclick="closeConfirm()">Cancelar</button>
      <button class="btn btn-danger" onclick="doAbort()">Salir igual</button>
    </div>
  </div>
</div>

<!-- TOAST -->
<div id="toast"></div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
// ═══════════════════════════════════════════════
// SYNC — pegá tu URL de Apps Script acá abajo
// ═══════════════════════════════════════════════
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbx5ZA4BrJ3HfZK3_brm-g-6_8ScgCleieTj94qvV4QIFm2ncknSlNZLKbwuXALMcKZC/exec';

// ── API helpers ────────────────────────────────
async function apiGet() {
  if (!SCRIPT_URL) return null;
  try {
    const r = await fetch(SCRIPT_URL);
    const j = await r.json();
    return j.ok ? j.data : null;
  } catch { return null; }
}

async function apiPost(action, data) {
  if (!SCRIPT_URL) return;
  try {
    await fetch(SCRIPT_URL, {
      method: 'POST',
      body: JSON.stringify({ action, data }),
    });
  } catch {}
}

// ── Cargar datos desde Sheets (al abrir) ───────
async function syncLoad() {
  if (!SCRIPT_URL) return;
  setSyncStatus('syncing');
  const remote = await apiGet();
  if (!remote) { setSyncStatus('offline'); return; }

  if (remote.sessions?.length)  { sessions = remote.sessions;  saveStorage('cali_sessions', sessions); }
  if (remote.pesoLog?.length)   { pesoLog  = remote.pesoLog;   saveStorage('cali_peso_log', pesoLog); }
  if (remote.profile && Object.keys(remote.profile).length) {
    profile = remote.profile;
    saveStorage('cali_profile', profile);
    loadProfile();
  }
  setSyncStatus('ok');
}

// ── Estado visual del sync ─────────────────────
function setSyncStatus(status) {
  const el = document.getElementById('sync-status');
  if (!el) return;
  const map = {
    ok:      { text: '● Sincronizado', color: 'var(--accent)' },
    syncing: { text: '○ Sincronizando…', color: 'var(--accent2)' },
    offline: { text: '○ Sin conexión', color: 'var(--muted)' },
    saving:  { text: '○ Guardando…', color: 'var(--accent2)' },
    none:    { text: '○ Sin Sheets', color: 'var(--muted)' },
  };
  const s = map[status] || map.none;
  el.textContent = s.text;
  el.style.color = s.color;
}

// ═══════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════

const FRASES = [
  {id:1,cat:"Cinismo Clínico",txt:"El amor romántico es un pico de oxitocina y dopamina. Disfruta el viaje químico pero no le reces."},
  {id:2,cat:"Cinismo Clínico",txt:"Tu ansiedad es solo tu amígdala sobreaccionando a una notificación. No es un león. Respira."},
  {id:3,cat:"Cinismo Clínico",txt:"Eres un saco de agua y carbono con delirios de grandeza. Bájele un tono."},
  {id:4,cat:"Cinismo Clínico",txt:"El dolor emocional no es poético; es una alerta del sistema nervioso. Trátalo con frialdad."},
  {id:5,cat:"Cinismo Clínico",txt:"El 90% de las crisis existenciales se resuelven durmiendo ocho horas y tomando agua."},
  {id:6,cat:"Cinismo Clínico",txt:"La nostalgia es un error de procesamiento de la memoria. El pasado nunca fue tan bueno."},
  {id:7,cat:"Cinismo Clínico",txt:"Tu personalidad es solo un mecanismo de defensa que se salió de control."},
  {id:8,cat:"Cinismo Clínico",txt:"No hay almas gemelas; hay compatibilidades neuroquímicas temporales."},
  {id:9,cat:"Cinismo Clínico",txt:"Eres el resultado de miles de años de evolución. Compórtate a la altura de tu genoma."},
  {id:10,cat:"Cinismo Clínico",txt:"La tristeza crónica es mala praxis contigo mismo. Cambia la dosis de tu rutina."},
  {id:11,cat:"Silencio y Ruido",txt:"La dopamina barata te vacía el alma a plazos."},
  {id:12,cat:"Silencio y Ruido",txt:"El silencio absoluto asusta porque te obliga a escuchar al único fantasma real: tú mismo."},
  {id:13,cat:"Silencio y Ruido",txt:"Scrollear no es descansar; es anestesia local de corta duración."},
  {id:14,cat:"Silencio y Ruido",txt:"Apaga el teléfono. El mundo seguirá ardiendo sin tu supervisión."},
  {id:15,cat:"Silencio y Ruido",txt:"Aburrirse es el reinicio de fábrica que tu cerebro necesita desesperadamente."},
  {id:16,cat:"Silencio y Ruido",txt:"Fumar te compra cinco minutos de paz a cambio de tu capacidad pulmonar. Matemáticas pésimas."},
  {id:17,cat:"Silencio y Ruido",txt:"Si no puedes estar a solas en una habitación vacía, estás en mala compañía."},
  {id:18,cat:"Silencio y Ruido",txt:"El ruido externo es la excusa perfecta para no arreglar el desorden interno."},
  {id:19,cat:"Silencio y Ruido",txt:"Rompe la cadena del placer instantáneo. Deja que el cerebro pase hambre un rato."},
  {id:20,cat:"Silencio y Ruido",txt:"No huyas del vacío llenándolo de basura digital. Míralo de frente."},
  {id:21,cat:"Existencialismo Práctico",txt:"No busques un propósito cósmico. Limpia tu cuarto, paga tus cuentas y sobrevive al martes."},
  {id:22,cat:"Existencialismo Práctico",txt:"El universo no te debe respuestas. Acostúmbrate a la incertidumbre."},
  {id:23,cat:"Existencialismo Práctico",txt:"El absurdo no es una excusa para rendirse; es un pase libre para hacer lo que quieras."},
  {id:24,cat:"Existencialismo Práctico",txt:"Si nada importa a gran escala, tus errores de hoy tampoco."},
  {id:25,cat:"Existencialismo Práctico",txt:"Eres libre. Esa es exactamente la razón por la que sientes tanto pánico."},
  {id:26,cat:"Existencialismo Práctico",txt:"Acepta que eres el villano en la historia de alguien más y sigue caminando."},
  {id:27,cat:"Existencialismo Práctico",txt:"Construye tu vida sabiendo que el andamio se va a caer. Disfruta la vista mientras dure."},
  {id:28,cat:"Existencialismo Práctico",txt:"La felicidad es un concepto de marketing. Busca la tranquilidad operativa."},
  {id:29,cat:"Existencialismo Práctico",txt:"No estás deprimido; a veces solo estás prestando demasiada atención."},
  {id:30,cat:"Existencialismo Práctico",txt:"La muerte es el único límite de entrega. Todo lo demás es negociable."},
  {id:31,cat:"Antisocial y Máscaras",txt:"La sociedad exige que seas un engranaje. Sé un engranaje afilado."},
  {id:32,cat:"Antisocial y Máscaras",txt:"El qué dirán es irrelevante cuando entiendes que la mayoría ni siquiera sabe qué piensa."},
  {id:33,cat:"Antisocial y Máscaras",txt:"Ser normal es solo una psicopatía socialmente aceptada."},
  {id:34,cat:"Antisocial y Máscaras",txt:"No le debes una sonrisa a nadie si tu sistema operativo no la genera hoy."},
  {id:35,cat:"Antisocial y Máscaras",txt:"La empatía extrema te destruye. Administra tus recursos emocionales como un tacaño."},
  {id:36,cat:"Antisocial y Máscaras",txt:"Juega a ser el robot que el sistema espera, pero guarda las llaves de la máquina."},
  {id:37,cat:"Antisocial y Máscaras",txt:"Las interacciones sociales son transacciones. No inviertas donde hay déficit."},
  {id:38,cat:"Antisocial y Máscaras",txt:"Está bien aislarse, pero asegúrate de no estar construyendo tu propia celda."},
  {id:39,cat:"Antisocial y Máscaras",txt:"A veces estar bien significa fingir lo suficiente para que te dejen en paz."},
  {id:40,cat:"Antisocial y Máscaras",txt:"Nadie te entiende al 100%, ni tú mismo. Deja de exigirle imposibles al resto."},
  {id:41,cat:"Anti-Autoayuda",txt:"Las afirmaciones positivas frente al espejo son un insulto a tu inteligencia."},
  {id:42,cat:"Anti-Autoayuda",txt:"No atraes lo que piensas; obtienes lo que toleras."},
  {id:43,cat:"Anti-Autoayuda",txt:"El dolor no siempre te hace más fuerte. A veces solo te hace más cínico, y eso está bien."},
  {id:44,cat:"Anti-Autoayuda",txt:"\"Sé tú mismo\" es el peor consejo posible en pleno colapso. Mejor sé alguien funcional."},
  {id:45,cat:"Anti-Autoayuda",txt:"Acepta tu mediocridad en algunas áreas. Te quitará un peso enorme de encima."},
  {id:46,cat:"Anti-Autoayuda",txt:"No todo pasa por algo. A veces las cosas simplemente se rompen."},
  {id:47,cat:"Anti-Autoayuda",txt:"Perdonar no es obligatorio. Olvidar por mera conveniencia psíquica, sí."},
  {id:48,cat:"Anti-Autoayuda",txt:"No busques tu mejor versión. Busca la versión que sobrevive al lunes sin querer renunciar."},
  {id:49,cat:"Anti-Autoayuda",txt:"Escribir no te cura, pero al menos organiza la hemorragia."},
  {id:50,cat:"Anti-Autoayuda",txt:"Deja de esperar el momento de lucidez absoluta. Navega a ciegas como hacemos todos."},
];

const RUTINAS = [
  {
    id: 'push',
    color: 'push',
    colorVar: '--push',
    emoji: '💪',
    day: 'Día 1',
    name: 'PUSH',
    muscles: 'Pecho · Hombros · Tríceps',
    desc: 'Empuje horizontal y vertical. Foco en sobrecarga progresiva del pectoral mayor, deltoides anterior y tríceps braquial.',
    exercises: [
      {
        name: 'Flexiones Arqueras',
        series: 4, repsTarget: '12–20',
        muscles: ['pectoral mayor', 'serrato anterior', 'tríceps'],
        tip: '<strong>Mecánica:</strong> Una mano extendida carga el 70-80% del peso. Mantené el codo pegado al torso en la mano trabajadora. Bajá lento (3 seg) para maximizar el tiempo bajo tensión — clave para hipertrofia. La mano extendida es apoyo, no fuerza.',
        progression: '→ Flexiones a 1 brazo (asistidas con banda primero)',
        rpeTarget: 'Última serie al fallo'
      },
      {
        name: 'Flexiones Declinadas',
        series: 4, repsTarget: '8–12',
        muscles: ['pectoral mayor (porción clavicular)', 'deltoides anterior', 'tríceps'],
        tip: '<strong>Ángulo:</strong> Pies en silla a ~45°. A mayor elevación, mayor reclutamiento del pectoral superior y deltoides. Escápulas retraídas en la parte alta. No bloquees codos al tope.',
        progression: '→ Mayor elevación progresiva hasta handstand push-up',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Flexiones Diamante',
        series: 3, repsTarget: '10–15',
        muscles: ['tríceps braquial', 'pectoral clavicular', 'deltoides anterior'],
        tip: '<strong>Posición de manos:</strong> Pulgares e índices se tocan formando un rombo. El codo cierra hacia atrás, no hacia afuera. Este es el ejercicio de mayor activación de tríceps en calistenia. Si hay molestia en muñecas, abrí levemente.',
        progression: '→ Déficit con manos en libros/paralelas bajas',
        rpeTarget: 'Al fallo en S3'
      },
      {
        name: 'Pike Push-Up (pies elevados)',
        series: 4, repsTarget: '8–12',
        muscles: ['deltoides (cabeza anterior y lateral)', 'trapecio superior', 'tríceps'],
        tip: '<strong>Patrón de empuje vertical:</strong> Cuanto más vertical sea tu cuerpo, más deltoides. Bajá la cabeza entre las manos, codos a 45°. Es el precursor directo del handstand push-up. Progresá la elevación gradualmente.',
        progression: '→ Wall-assisted HSPU → Handstand push-up libre',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Dips en Silla',
        series: 3, repsTarget: '10–15',
        muscles: ['tríceps braquial', 'pectoral inferior', 'deltoides anterior'],
        tip: '<strong>Seguridad:</strong> Mantené los hombros deprimidos (abajo), no elevarlos al oído. Bajá hasta 90° de flexión de codo mínimo. El torso levemente inclinado hacia adelante recluta más pectoral; más vertical = más tríceps.',
        progression: '→ Dips en paralelas de parque (mayor ROM y carga)',
        rpeTarget: 'Serie 3 al fallo'
      }
    ]
  },
  {
    id: 'pull',
    color: 'pull',
    colorVar: '--pull',
    emoji: '🔙',
    day: 'Día 2',
    name: 'PULL',
    muscles: 'Espalda · Bíceps',
    desc: 'Jalones verticales y horizontales. Desarrollo del dorsal ancho, romboides, trapecio medio e inferior y bíceps braquial.',
    exercises: [
      {
        name: 'Dominadas Agarre Ancho',
        series: 4, repsTarget: '5–10',
        muscles: ['dorsal ancho', 'teres mayor', 'romboides', 'bíceps'],
        tip: '<strong>Rey de la calistenia:</strong> Agarre prono (palmas al frente), manos ligeramente más anchas que hombros. Iniciá el movimiento deprimiendo las escápulas ANTES de flexionar codos. Bajá completamente (dead hang) para elongar y reclutar todo el dorsal. Si no llegás a 5 reps: hacé negativas.',
        progression: '→ Dominadas lastradas con mochila',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Chin-Ups (agarre supino)',
        series: 4, repsTarget: '6–10',
        muscles: ['bíceps braquial', 'braquial', 'dorsal ancho (porción inferior)'],
        tip: '<strong>Diferencia clave vs dominadas:</strong> El agarre supino (palmas hacia vos) maximiza el bíceps porque lo coloca en posición óptima de fuerza. Suelen ser más fáciles que las dominadas. Usá ese beneficio para sumar volumen de bíceps sin curl extra.',
        progression: '→ Lastradas → Archer chin-ups',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Remo Invertido bajo Mesa',
        series: 4, repsTarget: '10–15',
        muscles: ['romboides', 'trapecio medio e inferior', 'dorsal ancho', 'bíceps'],
        tip: '<strong>El mejor remo de calistenia:</strong> Cuerpo rígido como tabla, pies en el suelo. Tirá el pecho hacia la mesa, codos a 45° del torso. Apretá la escápula al tope. Cuanto más horizontal estés, más difícil. Este ejercicio compensa el desequilibrio anterior/posterior.',
        progression: '→ Pies en silla elevada para más horizontalidad',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Dominadas Agarre Neutro',
        series: 3, repsTarget: '6–10',
        muscles: ['braquial', 'braquiorradial', 'dorsal ancho', 'bíceps'],
        tip: '<strong>El más funcional:</strong> Palmas enfrentadas (si tenés barra con agarre neutro o usá rincón de pared). Combina beneficios de dominadas y chin-ups. Menor stress en muñecas y codos. El braquial se activa más — engrosamiento del brazo más notable a largo plazo.',
        progression: '→ Archer pull-ups (transición al jalón a 1 brazo)',
        rpeTarget: 'Serie 3 al fallo'
      },
      {
        name: 'Curl de Bíceps con Mochila',
        series: 3, repsTarget: '12–15',
        muscles: ['bíceps braquial', 'braquial', 'braquiorradial'],
        tip: '<strong>Aislamiento:</strong> Sentado o de pie, codo fijo al costado del torso. Subí el dorso de la mano mirando al techo al tope (supinación). Bajá lento en 3 segundos — la fase excéntrica genera más daño muscular y por lo tanto más hipertrofia. Cargá la mochila gradualmente.',
        progression: '→ Más carga en mochila → Curl en inclinación',
        rpeTarget: 'Al fallo en S3'
      }
    ]
  },
  {
    id: 'legs',
    color: 'legs',
    colorVar: '--legs',
    emoji: '🦵',
    day: 'Día 3',
    name: 'LEGS',
    muscles: 'Cuádriceps · Isquios · Glúteos · Pantorrillas',
    desc: 'Cadena cinética inferior completa. El entrenamiento de piernas eleva GH y testosterona endógena, beneficiando todo el cuerpo.',
    exercises: [
      {
        name: 'Sentadilla Búlgara',
        series: 4, repsTarget: '8–12 c/lado',
        muscles: ['cuádriceps (vasto externo/interno)', 'glúteo mayor', 'isquiotibiales'],
        tip: '<strong>El rey de la sentadilla unilateral:</strong> Pie trasero en silla a ~45cm. El peso cae sobre el talón del pie delantero. Rodilla no pasa el tope del pie. Bajá hasta que isquio roce pantorrilla si la movilidad lo permite. El desequilibrio unilateral recluta más estabilizadores de cadera que la sentadilla bilateral.',
        progression: '→ Mochila cargada → Goblet position',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Hip Thrust (espalda en silla)',
        series: 4, repsTarget: '12–15',
        muscles: ['glúteo mayor', 'glúteo medio', 'isquiotibiales'],
        tip: '<strong>Máxima activación de glúteo:</strong> Hombros sobre el borde de la silla, pies a 90° de flexión de rodilla. Empujá el suelo con los talones. Al tope: apretar glúteo 2 segundos (contracción isométrica). Evitá hiperextender lumbar — la pelvis se mueve, la columna no. El patrón de extensión de cadera es el más importante para rendimiento y estética.',
        progression: '→ Una sola pierna → Pie elevado',
        rpeTarget: 'Serie 4 al fallo'
      },
      {
        name: 'Sentadilla Isométrica en Pared',
        series: 3, repsTarget: '45–60 seg',
        muscles: ['cuádriceps (vasto lateral + medial)', 'glúteo medio', 'gastrocnemio'],
        tip: '<strong>Tensión continua:</strong> Ángulo de rodilla a 90°. La contracción isométrica en ese ángulo específico genera estrés metabólico máximo en el cuádriceps — uno de los 3 mecanismos de hipertrofia. Ideal como finisher o entre series de ejercicios compuestos. Duele. Está bien.',
        progression: '→ Aumentar tiempo → Un solo pie',
        rpeTarget: 'Al límite muscular, no articular'
      },
      {
        name: 'Peso Muerto Rumano a 1 Pierna',
        series: 3, repsTarget: '10–12 c/lado',
        muscles: ['isquiotibiales', 'glúteo mayor', 'erector espinal', 'estabilizadores de tobillo'],
        tip: '<strong>Bisagra de cadera unilateral:</strong> Pivotá desde la cadera, no doblando la espalda. Pierna de soporte con leve flexión de rodilla. La pierna libre sube en línea con el torso. Este ejercicio genera gran daño excéntrico en isquiotibiales — dejate 48-72h antes del próximo entrenamiento de piernas.',
        progression: '→ Mochila en mano opuesta → Sobre superficie inestable',
        rpeTarget: 'Control técnico sobre fallo'
      },
      {
        name: 'Elevaciones de Pantorrilla',
        series: 4, repsTarget: '15–20',
        muscles: ['gastrocnemio (cabeza medial y lateral)', 'sóleo'],
        tip: '<strong>La pantorrilla es resistente:</strong> Necesita alto volumen y ROM completo. Bajá el talón por debajo del nivel del pie (déficit en escalón) para elongar el gastrocnemio. Subí al tope y aguantá 1 seg. La pantorrilla se recupera rápido: podés trabajarla todos los días. El gastrocnemio responde mejor a series pesadas y el sóleo a series largas.',
        progression: '→ Una pierna → Con mochila → Déficit mayor',
        rpeTarget: 'Al fallo con buena técnica'
      }
    ]
  },
  {
    id: 'full',
    color: 'full',
    colorVar: '--full',
    emoji: '🔄',
    day: 'Día 4',
    name: 'FULL BODY',
    muscles: 'Todo · Volumen extra',
    desc: 'Suma volumen adicional con los mejores ejercicios de cada grupo. Todas las series al fallo. Mayor respuesta hormonal global.',
    exercises: [
      {
        name: 'Dominadas (al fallo)',
        series: 3, repsTarget: 'Al fallo',
        muscles: ['dorsal ancho', 'bíceps', 'romboides'],
        tip: '<strong>Full body day = sin restricciones:</strong> Al fallo real significa que no podés hacer ni 1 rep más con buen rango. No detener en el penúltimo rep. Si hiciste PULL ayer: probablemente rendirás menos — es normal. La acumulación de fatiga es parte del proceso.',
        progression: '→ La variante más difícil que puedas completar',
        rpeTarget: 'RPE 10 — al fallo absoluto'
      },
      {
        name: 'Flexiones Declinadas (al fallo)',
        series: 3, repsTarget: 'Al fallo',
        muscles: ['pectoral mayor', 'deltoides anterior', 'tríceps'],
        tip: '<strong>Volumen extra de empuje:</strong> Recordá que ya entrenaste pecho en el día PUSH. Este volumen adicional en el día 4 es estratégico: el pecho se recupera en 48-72h y aquí estamos 4-5 días después. Aumentá la elevación si las reps superan 20.',
        progression: '→ Aumentar elevación para mayor dificultad',
        rpeTarget: 'Al fallo absoluto'
      },
      {
        name: 'Sentadilla Búlgara (extra)',
        series: 3, repsTarget: '10 c/lado',
        muscles: ['cuádriceps', 'glúteo mayor', 'isquiotibiales'],
        tip: '<strong>Frecuencia doble:</strong> El glúteo responde bien a 2 estímulos/semana. Al ser día 4 (4 días después de piernas), el músculo está recuperado. Cargá mochila si las 10 reps sin carga no representan desafío.',
        progression: '→ Con mochila si reps >12 sin esfuerzo',
        rpeTarget: 'RPE 8-9'
      },
      {
        name: 'Pike Push-Up (al fallo)',
        series: 3, repsTarget: '10–12',
        muscles: ['deltoides', 'trapecio', 'tríceps'],
        tip: '<strong>Segundo estímulo semanal de deltoides:</strong> Crucial para desarrollo de hombros. El deltoides se recupera rápido (24-48h). Acá suma 3 series más de volumen vertical. Si dominás el pike: hacé wall-assisted HSPU.',
        progression: '→ Mayor elevación de pies',
        rpeTarget: 'Al fallo'
      },
      {
        name: 'Remo Invertido (al fallo)',
        series: 3, repsTarget: 'Al fallo',
        muscles: ['trapecio', 'romboides', 'dorsal ancho', 'bíceps'],
        tip: '<strong>Balance anterior/posterior:</strong> Por cada serie de empuje, necesitás una de jalón. Este remo asegura que la musculatura posterior no quede atrás del volumen de push. Clave para salud de hombros a largo plazo.',
        progression: '→ Pies más elevados para mayor horizontalidad',
        rpeTarget: 'Al fallo con técnica limpia'
      },
      {
        name: 'Hollow Body Hold',
        series: 3, repsTarget: '30 seg',
        muscles: ['recto abdominal', 'transverso', 'psoas', 'serratos'],
        tip: '<strong>Core antifractura:</strong> Espalda baja pegada al suelo — ese es el cue. Brazos atrás, piernas extendidas, levantadas ~20cm. Si la espalda se despega: subí las piernas. El hollow body es la base de todos los movimientos de calistenia avanzada (muscle-up, front lever, planche). Inversión a largo plazo.',
        progression: '→ Aumentar tiempo → Hollow body rock',
        rpeTarget: 'Al fallo técnico (espalda despegada = parar)'
      }
    ]
  }
];

// ═══════════════════════════════════════════════
// STATE & STORAGE
// ═══════════════════════════════════════════════

let state = {
  currentPage: 'home',
  workout: null,
  restDuration: 90,
  restTimer: null,
  workoutTimer: null,
  workoutStartTime: null,
};

function loadStorage(key, def) {
  try { const v = localStorage.getItem(key); return v ? JSON.parse(v) : def; }
  catch { return def; }
}
function saveStorage(key, val) {
  try { localStorage.setItem(key, JSON.stringify(val)); } catch {}
}

let sessions = loadStorage('cali_sessions', []);
let profile  = loadStorage('cali_profile', { nombre:'Diego', peso:'', talla:'', edad:'', kcal:'2600', proteina:'130' });
let pesoLog  = loadStorage('cali_peso_log', []);

// ═══════════════════════════════════════════════
// INIT
// ═══════════════════════════════════════════════

async function init() {
  renderFrase();
  renderWeek();
  renderRutinas();
  loadProfile();

  if (SCRIPT_URL) {
    document.getElementById('sync-status').style.display = 'block';
    setSyncStatus('syncing');
    await syncLoad();
    renderRutinas();
    loadProfile();
  } else {
    setSyncStatus('none');
  }
}

function renderFrase() {
  const today = new Date();
  const dayOfYear = Math.floor((today - new Date(today.getFullYear(), 0, 0)) / 86400000);
  const frase = FRASES[dayOfYear % FRASES.length];
  document.getElementById('frase-text').textContent = frase.txt;
  document.getElementById('frase-cat').textContent = frase.cat;
}

function renderWeek() {
  const days = ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM'];
  const types = [
    {label:'PUSH',css:'push'},{label:'PULL',css:'pull'},{label:'—',css:'rest'},
    {label:'LEGS',css:'legs'},{label:'FULL',css:'full'},{label:'—',css:'rest'},{label:'—',css:'rest'}
  ];
  const today = new Date().getDay(); // 0=dom, 1=lun
  const todayIdx = today === 0 ? 6 : today - 1;
  
  const grid = document.getElementById('week-grid');
  grid.innerHTML = days.map((d, i) => `
    <div class="week-day ${types[i].css} ${i===todayIdx?'today':''}">
      <div class="day-name">${d}</div>
      <div class="day-type">${types[i].label}</div>
    </div>
  `).join('');
}

function renderRutinas() {
  const grid = document.getElementById('rutinas-grid');
  grid.innerHTML = RUTINAS.map(r => `
    <div class="rutina-card ${r.color}" onclick="startWorkout('${r.id}')">
      <div class="rutina-day">${r.emoji} ${r.day}</div>
      <div class="rutina-name">${r.name}</div>
      <div class="rutina-desc">${r.desc}</div>
      <div class="rutina-exercises">${r.exercises.length} ejercicios · ${r.exercises.reduce((a,e)=>a+e.series,0)} series totales</div>
      <button class="btn btn-sm" style="border-color:var(${r.colorVar});color:var(${r.colorVar})">
        Comenzar sesión →
      </button>
    </div>
  `).join('');
}

// ═══════════════════════════════════════════════
// PAGE NAVIGATION
// ═══════════════════════════════════════════════

function showPage(page) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
  document.getElementById('page-' + (page === 'home' ? 'home' : page === 'historial' ? 'historial' : page === 'stats' ? 'stats' : 'profile')).classList.add('active');
  document.querySelectorAll('.nav-tab')[['home','historial','stats','profile'].indexOf(page)].classList.add('active');
  state.currentPage = page;
  
  if (page === 'historial') renderHistorial();
  if (page === 'stats') renderStats();
  if (page === 'profile') renderProfileStats();
}

// ═══════════════════════════════════════════════
// WORKOUT ENGINE
// ═══════════════════════════════════════════════

function startWorkout(rutinaId) {
  const rutina = RUTINAS.find(r => r.id === rutinaId);
  if (!rutina) return;

  state.workout = {
    rutina: rutina,
    currentExIdx: 0,
    startTime: Date.now(),
    seriesData: rutina.exercises.map(e => ({
      name: e.name,
      series: Array(e.series).fill({ reps: '', done: false }).map(() => ({ reps: '', done: false }))
    })),
    notes: '',
    restDuration: state.restDuration
  };

  document.getElementById('ws-day-label').textContent = `${rutina.emoji} ${rutina.day} — ${rutina.muscles}`;
  document.getElementById('ws-title').textContent = rutina.name;

  document.getElementById('workout-screen').classList.add('active');
  renderExercise();
  startWorkoutTimer();
  
  // Set initial rest btn state
  document.querySelectorAll('.rest-btn').forEach(b => b.classList.remove('active'));
  document.querySelector(`.rest-btn[onclick="setRest(90)"]`) && 
    document.querySelector(`.rest-btn[onclick="setRest(90)"]`).classList.add('active');
}

function renderExercise() {
  const w = state.workout;
  const ex = w.rutina.exercises[w.currentExIdx];
  const total = w.rutina.exercises.length;
  
  // Progress
  document.getElementById('ws-progress').style.width = `${((w.currentExIdx) / total) * 100}%`;
  
  // Nav buttons
  document.getElementById('btn-prev').style.opacity = w.currentExIdx === 0 ? '0.3' : '1';
  document.getElementById('btn-next').textContent = w.currentExIdx === total - 1 ? '✓ Finalizar sesión' : 'Siguiente →';
  
  // Exercise card
  const sd = w.seriesData[w.currentExIdx];
  const seriesHTML = sd.series.map((s, i) => `
    <div class="series-row" id="series-row-${i}">
      <div class="series-badge ${s.done ? 'done' : ''}">${i+1}</div>
      <input class="series-input" type="text" placeholder="${ex.repsTarget}" 
        value="${s.reps}" 
        onchange="updateSeries(${i}, this.value)"
        id="series-input-${i}">
      <span class="series-unit">reps</span>
      <button class="series-check ${s.done ? 'done' : ''}" onclick="toggleSeriesDone(${i})" id="series-check-${i}">
        ${s.done ? '✓' : '○'}
      </button>
    </div>
  `).join('');

  document.getElementById('ws-exercise-main').innerHTML = `
    <div class="exercise-card">
      <div class="exercise-num">Ejercicio ${w.currentExIdx + 1} de ${total}</div>
      <div class="exercise-name">${ex.name}</div>
      <div class="muscle-tags">
        ${ex.muscles.map(m => `<span class="muscle-tag">${m}</span>`).join('')}
      </div>
      <div class="exercise-meta">
        <div class="exercise-meta-item">
          <span class="meta-label">Series</span>
          <span class="meta-value">${ex.series}</span>
        </div>
        <div class="exercise-meta-item">
          <span class="meta-label">Reps objetivo</span>
          <span class="meta-value">${ex.repsTarget}</span>
        </div>
        <div class="exercise-meta-item">
          <span class="meta-label">Intensidad</span>
          <span class="meta-value" style="font-size:11px;color:var(--accent2)">${ex.rpeTarget}</span>
        </div>
      </div>
      <div class="exercise-tip">📌 ${ex.tip}</div>
      <div class="progression-hint">⬆ ${ex.progression}</div>
      <div class="series-section">
        <div class="series-label">Registro de series</div>
        ${seriesHTML}
      </div>
      <textarea class="notes-input" placeholder="Notas del ejercicio (variante usada, sensaciones, PR...)" 
        onchange="updateNotes(this.value)"
        id="ex-notes">${sd.notes || ''}</textarea>
    </div>
  `;

  // Sidebar
  const listHTML = w.rutina.exercises.map((e, i) => {
    const done = w.seriesData[i].series.every(s => s.done);
    const cur = i === w.currentExIdx;
    return `<div class="ex-sidebar-item ${done ? 'done' : ''} ${cur ? 'current' : ''}" onclick="jumpToExercise(${i})">
      <span>${i+1}. ${e.name}</span>
      ${done ? '' : cur ? '<span style="margin-left:auto;font-size:9px;color:var(--accent)">● activo</span>' : ''}
    </div>`;
  }).join('');
  document.getElementById('ws-ex-list').innerHTML = listHTML;
  
  // Timer display
  document.getElementById('timer-num').textContent = state.restDuration;
  document.getElementById('timer-small').textContent = 'seg configurado';
}

function updateSeries(idx, val) {
  state.workout.seriesData[state.workout.currentExIdx].series[idx].reps = val;
}

function updateNotes(val) {
  state.workout.seriesData[state.workout.currentExIdx].notes = val;
}

function toggleSeriesDone(idx) {
  const s = state.workout.seriesData[state.workout.currentExIdx].series[idx];
  s.done = !s.done;
  // Update DOM
  const badge = document.getElementById(`series-row-${idx}`).querySelector('.series-badge');
  const btn = document.getElementById(`series-check-${idx}`);
  badge.classList.toggle('done', s.done);
  btn.classList.toggle('done', s.done);
  btn.textContent = s.done ? '✓' : '○';
  
  // Auto-start rest timer if all series completed
  const all = state.workout.seriesData[state.workout.currentExIdx].series;
  if (s.done && all.filter(x=>x.done).length < all.length) {
    // There are more series — start rest
    startRestOverlay();
  }
  if (s.done && all.every(x=>x.done)) {
    toast('✓ Ejercicio completado', 'success');
  }
}

function jumpToExercise(idx) {
  state.workout.currentExIdx = idx;
  renderExercise();
}

function prevExercise() {
  if (state.workout.currentExIdx > 0) {
    state.workout.currentExIdx--;
    renderExercise();
  }
}

function nextExercise() {
  const total = state.workout.rutina.exercises.length;
  if (state.workout.currentExIdx < total - 1) {
    state.workout.currentExIdx++;
    renderExercise();
  } else {
    showCompleteOverlay();
  }
}

// ═══════════════════════════════════════════════
// TIMERS
// ═══════════════════════════════════════════════

function startWorkoutTimer() {
  state.workoutStartTime = Date.now();
  state.workoutTimer = setInterval(() => {
    const elapsed = Math.floor((Date.now() - state.workoutStartTime) / 1000);
    const m = Math.floor(elapsed / 60).toString().padStart(2, '0');
    const s = (elapsed % 60).toString().padStart(2, '0');
    const el = document.getElementById('ws-elapsed');
    if (el) el.textContent = `${m}:${s}`;
  }, 1000);
}

function setRest(secs) {
  state.restDuration = secs;
  document.querySelectorAll('.rest-btn').forEach(b => b.classList.remove('active'));
  event.target.classList.add('active');
  document.getElementById('timer-num').textContent = secs;
  document.getElementById('timer-small').textContent = 'seg configurado';
  clearInterval(state.restTimer);
  state.restTimer = null;
  const fg = document.getElementById('timer-ring-fg');
  if (fg) { fg.style.strokeDashoffset = '0'; fg.style.stroke = 'var(--accent)'; }
}

function setCustomRest() {
  const v = parseInt(document.getElementById('rest-custom').value);
  if (v >= 10 && v <= 600) {
    state.restDuration = v;
    document.querySelectorAll('.rest-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('timer-num').textContent = v;
    document.getElementById('timer-small').textContent = 'seg configurado';
    toast(`Descanso: ${v} seg`, 'success');
  }
}

function startRestTimer() {
  clearInterval(state.restTimer);
  let remaining = state.restDuration;
  const total = state.restDuration;
  const circumference = 402.1;
  
  const btn = document.getElementById('timer-btn');
  btn.textContent = 'Reiniciar';
  
  document.getElementById('timer-num').textContent = remaining;
  document.getElementById('timer-small').textContent = 'restantes';

  state.restTimer = setInterval(() => {
    remaining--;
    const fg = document.getElementById('timer-ring-fg');
    const num = document.getElementById('timer-num');
    const small = document.getElementById('timer-small');
    
    if (!fg || !num) { clearInterval(state.restTimer); return; }
    
    const offset = circumference * (1 - remaining / total);
    fg.style.strokeDashoffset = offset;
    num.textContent = remaining;
    
    if (remaining <= 5) { fg.style.stroke = 'var(--danger)'; num.style.color = 'var(--danger)'; }
    else if (remaining <= 15) { fg.style.stroke = 'var(--accent2)'; num.style.color = 'var(--accent2)'; }
    
    if (remaining <= 0) {
      clearInterval(state.restTimer);
      small.textContent = '¡A entrenar!';
      num.textContent = '✓';
      fg.style.stroke = 'var(--accent)';
      num.style.color = 'var(--accent)';
      btn.textContent = 'Iniciar descanso';
      playBeep();
    }
  }, 1000);
}

function startRestOverlay() {
  const overlay = document.getElementById('rest-overlay');
  const w = state.workout;
  const nextEx = w.rutina.exercises[w.currentExIdx + 1];
  const label = nextEx 
    ? `Siguiente: <strong>${nextEx.name}</strong>` 
    : '<strong>Último ejercicio</strong> — ¡vas bien!';
  document.getElementById('rest-next-label').innerHTML = label;
  overlay.classList.add('active');

  let remaining = state.restDuration;
  const total = state.restDuration;
  const circumference = 565.5;

  const fg = document.getElementById('rest-ring-fg');
  const num = document.getElementById('rest-num');
  num.textContent = remaining;

  clearInterval(state.restTimer);
  state.restTimer = setInterval(() => {
    remaining--;
    if (!fg || !num) { clearInterval(state.restTimer); return; }
    const offset = circumference * (1 - remaining / total);
    fg.style.strokeDashoffset = offset;
    num.textContent = remaining;
    if (remaining <= 0) {
      clearInterval(state.restTimer);
      overlay.classList.remove('active');
      playBeep();
    }
  }, 1000);
}

function skipRest() {
  clearInterval(state.restTimer);
  document.getElementById('rest-overlay').classList.remove('active');
}

function playBeep() {
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.value = 880;
    osc.type = 'sine';
    gain.gain.setValueAtTime(0.3, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.4);
  } catch {}
}

// ═══════════════════════════════════════════════
// COMPLETE WORKOUT
// ═══════════════════════════════════════════════

function showCompleteOverlay() {
  const w = state.workout;
  const elapsed = Math.floor((Date.now() - state.workoutStartTime) / 1000);
  const m = Math.floor(elapsed / 60);
  const totalSeries = w.seriesData.reduce((a, s) => a + s.series.filter(x => x.done).length, 0);

  document.getElementById('complete-subtitle').textContent = `${w.rutina.emoji} ${w.rutina.name} · ${new Date().toLocaleDateString('es-AR')}`;
  document.getElementById('complete-stats').innerHTML = `
    <div class="complete-stat">
      <div class="complete-stat-num">${m}</div>
      <div class="complete-stat-label">MINUTOS</div>
    </div>
    <div class="complete-stat">
      <div class="complete-stat-num">${totalSeries}</div>
      <div class="complete-stat-label">SERIES</div>
    </div>
    <div class="complete-stat">
      <div class="complete-stat-num">${w.rutina.exercises.length}</div>
      <div class="complete-stat-label">EJERCICIOS</div>
    </div>
  `;
  document.getElementById('complete-overlay').classList.add('active');
}

function finishWorkout() {
  const w = state.workout;
  const elapsed = Math.floor((Date.now() - state.workoutStartTime) / 1000);
  
  const session = {
    id: Date.now(),
    date: new Date().toISOString(),
    rutinaId: w.rutina.id,
    rutinaName: w.rutina.name,
    color: w.rutina.color,
    durationMin: Math.floor(elapsed / 60),
    exercises: w.seriesData.map((sd, i) => ({
      name: sd.name,
      series: sd.series,
      notes: sd.notes || ''
    })),
    totalSeries: w.seriesData.reduce((a, s) => a + s.series.filter(x => x.done).length, 0)
  };
  
  sessions.unshift(session);
  saveStorage('cali_sessions', sessions);
  apiPost('append_session', session).then(() => setSyncStatus('ok'));
  setSyncStatus('saving');
  
  clearInterval(state.workoutTimer);
  clearInterval(state.restTimer);
  document.getElementById('complete-overlay').classList.remove('active');
  document.getElementById('workout-screen').classList.remove('active');
  state.workout = null;
  
  toast('✓ Sesión guardada', 'success');
  showPage('historial');
}

function closeComplete() {
  document.getElementById('complete-overlay').classList.remove('active');
}

function confirmAbort() {
  document.getElementById('confirm-modal').classList.add('active');
}
function closeConfirm() {
  document.getElementById('confirm-modal').classList.remove('active');
}
function doAbort() {
  clearInterval(state.workoutTimer);
  clearInterval(state.restTimer);
  document.getElementById('workout-screen').classList.remove('active');
  document.getElementById('rest-overlay').classList.remove('active');
  document.getElementById('confirm-modal').classList.remove('active');
  state.workout = null;
}

// ═══════════════════════════════════════════════
// HISTORIAL
// ═══════════════════════════════════════════════

function renderHistorial() {
  const list = document.getElementById('historial-list');
  if (!sessions.length) {
    list.innerHTML = `<div style="text-align:center;color:var(--muted);padding:40px;font-size:12px;">
      Todavía no hay sesiones registradas.<br>Comenzá tu primer entrenamiento arriba.
    </div>`;
    return;
  }
  list.innerHTML = sessions.map(s => {
    const d = new Date(s.date);
    const dateStr = d.toLocaleDateString('es-AR', { weekday: 'long', day: 'numeric', month: 'long' });
    const timeStr = d.toLocaleTimeString('es-AR', { hour: '2-digit', minute: '2-digit' });
    return `
      <div class="historial-item">
        <div class="hist-dot" style="background:var(--${s.color})"></div>
        <div class="hist-info">
          <div class="hist-title">${s.rutinaName}</div>
          <div class="hist-date">${dateStr} · ${timeStr} · ${s.durationMin} min · ${s.totalSeries} series</div>
        </div>
        <div class="hist-badge" style="background:rgba(var(--${s.color}-rgb,200,245,69),0.08);color:var(--${s.color})">
          ${s.totalSeries} series
        </div>
        <button class="btn btn-sm btn-danger" onclick="deleteSession(${s.id})" style="flex-shrink:0">✕</button>
      </div>
    `;
  }).join('');
}

function deleteSession(id) {
  sessions = sessions.filter(s => s.id !== id);
  saveStorage('cali_sessions', sessions);
  apiPost('delete_session', { id }).then(() => setSyncStatus('ok'));
  setSyncStatus('saving');
  renderHistorial();
  toast('Sesión eliminada', 'error');
}

// ═══════════════════════════════════════════════
// STATS & CHARTS
// ═══════════════════════════════════════════════

let charts = {};

function renderStats() {
  // Stats boxes
  const totalSessions = sessions.length;
  const totalSeries = sessions.reduce((a, s) => a + (s.totalSeries || 0), 0);
  const totalMin = sessions.reduce((a, s) => a + (s.durationMin || 0), 0);
  const streak = calcStreak();
  
  document.getElementById('stats-grid').innerHTML = `
    <div class="stat-box">
      <div class="stat-number">${totalSessions}</div>
      <div class="stat-label">Sesiones totales</div>
    </div>
    <div class="stat-box">
      <div class="stat-number">${totalSeries}</div>
      <div class="stat-label">Series completadas</div>
    </div>
    <div class="stat-box">
      <div class="stat-number">${totalMin}</div>
      <div class="stat-label">Minutos totales</div>
    </div>
    <div class="stat-box">
      <div class="stat-number">${streak}</div>
      <div class="stat-label">Racha actual (sem)</div>
    </div>
  `;
  
  renderVolumeChart();
  renderExerciseTabs();
  renderWeightChart();
  renderFrequencyChart();
}

function calcStreak() {
  if (!sessions.length) return 0;
  const weeks = new Set(sessions.map(s => {
    const d = new Date(s.date);
    const jan1 = new Date(d.getFullYear(), 0, 1);
    return Math.ceil((((d - jan1) / 86400000) + jan1.getDay() + 1) / 7);
  }));
  return weeks.size;
}

function getChartDefaults() {
  return {
    color: 'rgba(200,245,69,',
    gridColor: 'rgba(42,42,53,0.8)',
    textColor: '#6a6a80',
    fontFamily: 'DM Mono'
  };
}

function renderVolumeChart() {
  const ctx = document.getElementById('chart-volumen');
  if (!ctx) return;
  
  // Group sessions by week
  const weekMap = {};
  sessions.forEach(s => {
    const d = new Date(s.date);
    const weekStart = new Date(d);
    weekStart.setDate(d.getDate() - d.getDay() + 1);
    const key = weekStart.toISOString().slice(0,10);
    if (!weekMap[key]) weekMap[key] = { push:0, pull:0, legs:0, full:0, total:0 };
    weekMap[key][s.rutinaId] = (weekMap[key][s.rutinaId] || 0) + (s.totalSeries || 0);
    weekMap[key].total += s.totalSeries || 0;
  });
  
  const labels = Object.keys(weekMap).sort().slice(-8).map(k => {
    const d = new Date(k);
    return `${d.getDate()}/${d.getMonth()+1}`;
  });
  const sortedKeys = Object.keys(weekMap).sort().slice(-8);
  
  if (charts.volumen) charts.volumen.destroy();
  charts.volumen = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels.length ? labels : ['Sin datos'],
      datasets: [
        { label: 'PUSH', data: sortedKeys.map(k => weekMap[k].push || 0), backgroundColor: 'rgba(245,168,69,0.7)', borderRadius: 3 },
        { label: 'PULL', data: sortedKeys.map(k => weekMap[k].pull || 0), backgroundColor: 'rgba(69,200,245,0.7)', borderRadius: 3 },
        { label: 'LEGS', data: sortedKeys.map(k => weekMap[k].legs || 0), backgroundColor: 'rgba(200,69,245,0.7)', borderRadius: 3 },
        { label: 'FULL', data: sortedKeys.map(k => weekMap[k].full || 0), backgroundColor: 'rgba(200,245,69,0.7)', borderRadius: 3 },
      ]
    },
    options: getStackedBarOptions('Series')
  });
}

function getStackedBarOptions(label) {
  return {
    responsive: true,
    plugins: { legend: { labels: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } } },
    scales: {
      x: { stacked: true, grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } },
      y: { stacked: true, grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } }
    }
  };
}

function renderExerciseTabs() {
  // Collect all exercise names
  const exNames = new Set();
  sessions.forEach(s => s.exercises && s.exercises.forEach(e => exNames.add(e.name)));
  
  const tabs = document.getElementById('exercise-tabs');
  const names = [...exNames].slice(0, 8);
  
  tabs.innerHTML = names.map((n, i) => 
    `<button class="chart-tab ${i===0?'active':''}" onclick="renderExerciseChart('${n}', this)">${n}</button>`
  ).join('') || '<span style="font-size:11px;color:var(--muted)">Completá sesiones para ver progresión</span>';
  
  if (names.length) renderExerciseChart(names[0], tabs.querySelector('.chart-tab'));
}

function renderExerciseChart(exName, btn) {
  document.querySelectorAll('.chart-tab').forEach(t => t.classList.remove('active'));
  if (btn) btn.classList.add('active');
  
  const ctx = document.getElementById('chart-ejercicio');
  if (!ctx) return;
  
  const data = [];
  sessions.slice().reverse().forEach(s => {
    const ex = s.exercises && s.exercises.find(e => e.name === exName);
    if (ex) {
      const reps = ex.series.filter(sr => sr.done && sr.reps).map(sr => parseFloat(sr.reps) || 0);
      if (reps.length) {
        data.push({
          date: new Date(s.date).toLocaleDateString('es-AR', { day:'numeric', month:'numeric' }),
          maxReps: Math.max(...reps),
          avgReps: reps.reduce((a,b) => a+b, 0) / reps.length,
          volume: reps.reduce((a,b) => a+b, 0)
        });
      }
    }
  });
  
  if (charts.ejercicio) charts.ejercicio.destroy();
  charts.ejercicio = new Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map(d => d.date),
      datasets: [
        {
          label: 'Reps máximas',
          data: data.map(d => d.maxReps),
          borderColor: 'rgba(200,245,69,0.9)',
          backgroundColor: 'rgba(200,245,69,0.08)',
          tension: 0.4, fill: true, pointRadius: 4, pointBackgroundColor: 'rgba(200,245,69,1)'
        },
        {
          label: 'Reps promedio',
          data: data.map(d => Math.round(d.avgReps * 10) / 10),
          borderColor: 'rgba(245,200,69,0.7)',
          backgroundColor: 'transparent',
          tension: 0.4, borderDash: [4,4], pointRadius: 3
        }
      ]
    },
    options: {
      responsive: true,
      plugins: { legend: { labels: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } } },
      scales: {
        x: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } },
        y: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } }
      }
    }
  });
}

function renderWeightChart() {
  const ctx = document.getElementById('chart-peso');
  if (!ctx) return;
  
  const data = pesoLog.slice(-20);
  
  if (charts.peso) charts.peso.destroy();
  charts.peso = new Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map(d => new Date(d.date).toLocaleDateString('es-AR', { day:'numeric', month:'numeric' })),
      datasets: [{
        label: 'Peso (kg)',
        data: data.map(d => d.peso),
        borderColor: 'rgba(69,200,245,0.9)',
        backgroundColor: 'rgba(69,200,245,0.06)',
        tension: 0.3, fill: true, pointRadius: 4, pointBackgroundColor: 'rgba(69,200,245,1)'
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { labels: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } } },
      scales: {
        x: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } },
        y: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 10 } } }
      }
    }
  });
}

function renderFrequencyChart() {
  const ctx = document.getElementById('chart-frecuencia');
  if (!ctx) return;
  
  // Count sessions per rutina
  const counts = { push: 0, pull: 0, legs: 0, full: 0 };
  sessions.forEach(s => { if (counts[s.rutinaId] !== undefined) counts[s.rutinaId]++; });
  
  if (charts.freq) charts.freq.destroy();
  charts.freq = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['PUSH', 'PULL', 'LEGS', 'FULL BODY'],
      datasets: [{
        data: [counts.push, counts.pull, counts.legs, counts.full],
        backgroundColor: ['rgba(245,168,69,0.8)', 'rgba(69,200,245,0.8)', 'rgba(200,69,245,0.8)', 'rgba(200,245,69,0.8)'],
        borderColor: '#0a0a0c',
        borderWidth: 3
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { labels: { color: '#6a6a80', font: { family: 'DM Mono', size: 11 }, padding: 16 } }
      }
    }
  });
}

// ═══════════════════════════════════════════════
// PROFILE
// ═══════════════════════════════════════════════

function loadProfile() {
  document.getElementById('input-nombre').value = profile.nombre || '';
  document.getElementById('input-peso').value = profile.peso || '';
  document.getElementById('input-talla').value = profile.talla || '';
  document.getElementById('input-edad').value = profile.edad || '';
  document.getElementById('input-kcal').value = profile.kcal || '2600';
  document.getElementById('input-proteina').value = profile.proteina || '130';
  document.getElementById('profile-name-display').textContent = profile.nombre || 'Diego';
  calcBMI();
}

function saveProfile() {
  profile = {
    nombre: document.getElementById('input-nombre').value,
    peso: document.getElementById('input-peso').value,
    talla: document.getElementById('input-talla').value,
    edad: document.getElementById('input-edad').value,
    kcal: document.getElementById('input-kcal').value,
    proteina: document.getElementById('input-proteina').value,
  };
  saveStorage('cali_profile', profile);
  document.getElementById('profile-name-display').textContent = profile.nombre || 'Diego';
  updateNutriInfo();
  apiPost('save_profile', profile).then(() => setSyncStatus('ok'));
  setSyncStatus('saving');
}

function calcBMI() {
  const p = parseFloat(document.getElementById('input-peso').value);
  const t = parseFloat(document.getElementById('input-talla').value);
  const bmiVal = document.getElementById('bmi-value');
  const bmiCat = document.getElementById('bmi-cat');
  
  if (p && t && t > 0) {
    const h = t / 100;
    const bmi = p / (h * h);
    bmiVal.textContent = bmi.toFixed(1);
    
    let cat = '', color = '';
    if (bmi < 18.5) { cat = 'Bajo peso'; color = 'var(--accent3)'; }
    else if (bmi < 25) { cat = 'Peso normal ✓'; color = 'var(--accent)'; }
    else if (bmi < 30) { cat = 'Sobrepeso'; color = 'var(--accent2)'; }
    else { cat = 'Obesidad'; color = 'var(--danger)'; }
    
    bmiCat.textContent = cat;
    bmiCat.style.color = color;
  } else {
    bmiVal.textContent = '—';
    bmiCat.textContent = 'Completá tus datos';
  }
  updateNutriInfo();
}

function updateNutriInfo() {
  const p = parseFloat(profile.peso);
  const prot = parseFloat(profile.proteina) || 130;
  const kcal = parseFloat(profile.kcal) || 2600;
  
  const el = document.getElementById('nutri-info');
  if (!el) return;
  
  if (p) {
    const protPerKg = (prot / p).toFixed(1);
    el.innerHTML = `
      <div style="margin-bottom:8px"><span style="color:var(--accent)">${kcal}</span> kcal/día — objetivo mínimo</div>
      <div style="margin-bottom:8px"><span style="color:var(--accent)">${prot}g</span> proteína/día (<span style="color:var(--accent2)">${protPerKg}g/kg</span>)</div>
      <div style="color:var(--muted);font-size:10px;margin-top:12px;line-height:1.8">
        🥚 3 huevos ≈ 19g prot<br>
        🐔 100g pollo ≈ 31g prot<br>
        🐟 1 lata atún ≈ 25g prot<br>
        🧀 100g ricota ≈ 14g prot<br>
        🫘 1 taza lentejas cocidas ≈ 18g prot
      </div>
    `;
  } else {
    el.innerHTML = '<span style="color:var(--muted)">Completá tu peso para ver objetivos.</span>';
  }
}

function logPeso() {
  const v = parseFloat(document.getElementById('input-peso').value);
  if (!v || v < 30 || v > 250) { toast('Ingresá un peso válido', 'error'); return; }
  const entry = { date: new Date().toISOString(), peso: v };
  pesoLog.push(entry);
  saveStorage('cali_peso_log', pesoLog);
  apiPost('append_peso', entry).then(() => setSyncStatus('ok'));
  setSyncStatus('saving');
  saveProfile();
  toast(`Peso registrado: ${v} kg`, 'success');
  renderProfileStats();
}

function renderProfileStats() {
  const ctx = document.getElementById('chart-peso-profile');
  if (!ctx) return;
  
  const data = pesoLog.slice(-16);
  
  if (charts.pesoProfile) charts.pesoProfile.destroy();
  charts.pesoProfile = new Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map(d => new Date(d.date).toLocaleDateString('es-AR', { day:'numeric', month:'numeric' })),
      datasets: [{
        label: 'kg',
        data: data.map(d => d.peso),
        borderColor: 'rgba(69,200,245,0.9)',
        backgroundColor: 'rgba(69,200,245,0.05)',
        tension: 0.3, fill: true, pointRadius: 5, pointBackgroundColor: 'rgba(69,200,245,1)'
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        x: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 9 } } },
        y: { grid: { color: 'rgba(42,42,53,0.5)' }, ticks: { color: '#6a6a80', font: { family: 'DM Mono', size: 9 } } }
      }
    }
  });
  
  // Historial list
  const el = document.getElementById('peso-historial-list');
  if (el) {
    el.innerHTML = pesoLog.slice().reverse().slice(0,8).map(d => 
      `<div style="display:flex;justify-content:space-between;padding:5px 0;border-bottom:1px solid var(--border)">
        <span>${new Date(d.date).toLocaleDateString('es-AR', { weekday:'short', day:'numeric', month:'short' })}</span>
        <span style="color:var(--accent3)">${d.peso} kg</span>
      </div>`
    ).join('') || '<div style="color:var(--muted)">Sin registros aún.</div>';
  }
  
  updateNutriInfo();
}

// ═══════════════════════════════════════════════
// TOAST
// ═══════════════════════════════════════════════

let toastTimeout;
function toast(msg, type = '') {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className = `show ${type}`;
  clearTimeout(toastTimeout);
  toastTimeout = setTimeout(() => { t.className = ''; }, 2800);
}

// ═══════════════════════════════════════════════
// MANUAL SYNC
// ═══════════════════════════════════════════════

async function manualSync() {
  if (!SCRIPT_URL) {
    toast('Pegá tu URL de Apps Script en SCRIPT_URL', 'error');
    return;
  }
  setSyncStatus('syncing');
  toast('Sincronizando…', '');
  await syncLoad();
  renderHistorial();
  if (state.currentPage === 'stats') renderStats();
  loadProfile();
  renderProfileStats();
  toast('✓ Sincronizado con Google Sheets', 'success');
}

// ═══════════════════════════════════════════════
// START
// ═══════════════════════════════════════════════

init();
</script>
</body>
</html>
