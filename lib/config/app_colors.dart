import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  // ── Brand — ocean teal: fresh, clear, forward-moving (no purple anywhere)
  static const Color primary = Color(0xFF0891B2);
  static const Color primaryLight = Color(0xFF22B9D4);
  static const Color primaryDark = Color(0xFF0E7490);
  static const Color primaryContainer = Color(0xFFE0F7FB);

  // deep orange: excitement, streak flame, "start now" energy
  static const Color accent = Color(0xFFFF7043);
  static const Color accentLight = Color(0xFFFF9068);
  static const Color accentContainer = Color(0xFFFFF0EB);

  // warm gold: XP coins, celebration, "you earned this" moments
  static const Color highlight = Color(0xFFFFB800);
  static const Color highlightContainer = Color(0xFFFFF8E0);

  // ── Backgrounds & surfaces ─────────────────────────────────────────────────
  // barely-cyan tint — inviting and fresh, not clinical white
  static const Color background = Color(0xFFF5FCFD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEBF8FA);

  // ── Text ───────────────────────────────────────────────────────────────────
  // deep ocean — cohesive with teal, readable
  static const Color textPrimary = Color(0xFF0C2D36);
  static const Color textSecondary = Color(0xFF4F7D88);
  static const Color textDisabled = Color(0xFFA8C9D0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);
  static const Color textOnHighlight = Color(0xFF0C2D36);

  // ── Semantic — score bars & feedback ──────────────────────────────────────
  static const Color scoreHigh = Color(0xFF22C55E);   // 80–100 green
  static const Color scoreMid = Color(0xFFF59E0B);    // 50–79 amber
  static const Color scoreLow = Color(0xFFEF4444);    // 0–49 red

  // ── Gamification ──────────────────────────────────────────────────────────
  static const Color streak = Color(0xFFFF7043);       // orange flame
  static const Color xp = Color(0xFFFFB800);           // gold coins
  static const Color badge = Color(0xFF22C55E);        // green achievement

  // ── Utility ───────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFDFF2F5);
  static const Color border = Color(0xFFC8E8ED);
  static const Color shadow = Color(0x1A0891B2);       // primary at 10% opacity
}
