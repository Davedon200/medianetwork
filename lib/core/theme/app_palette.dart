import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.pageGradientStart,
    required this.pageGradientEnd,
    required this.landingGradientStart,
    required this.landingGradientEnd,
    required this.surfaceNav,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceAbout,
    required this.surfaceModal,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnModal,
    required this.textOnModalMuted,
    required this.accentTeal,
    required this.accentPurple,
    required this.liveBadgeBg,
    required this.liveBadgeBorder,
    required this.scrim,
    required this.footerBg,
    required this.chipFill,
    required this.chipBorder,
    required this.statFill,
    required this.statBorder,
    required this.shadowColor,
    required this.aboutLabelBg,
    required this.aboutAccent,
  });

  static const oxfordBlue = Color(0xFF0F172A);

  final Color pageGradientStart;
  final Color pageGradientEnd;
  final Color landingGradientStart;
  final Color landingGradientEnd;
  final Color surfaceNav;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceAbout;
  final Color surfaceModal;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnModal;
  final Color textOnModalMuted;
  final Color accentTeal;
  final Color accentPurple;
  final Color liveBadgeBg;
  final Color liveBadgeBorder;
  final Color scrim;
  final Color footerBg;
  final Color chipFill;
  final Color chipBorder;
  final Color statFill;
  final Color statBorder;
  final Color shadowColor;
  final Color aboutLabelBg;
  final Color aboutAccent;

  static const brandGradient = LinearGradient(
    colors: [Color(0xFF6A5AE0), Color(0xFF2DD4BF)],
  );

  static const _modalSurface = Colors.white;
  static const _textOnModal = Color(0xFF111827);
  static const _textOnModalMuted = Color(0xFF6B7280);
  /// Light-theme cards: white with a subtle Oxford blue tint (~4%).
  static const _lightCardSurface = Color(0xFFF6F7F9);

  static const dark = AppPalette(
    pageGradientStart: oxfordBlue,
    pageGradientEnd: Color(0xFF1F3F55),
    landingGradientStart: Color(0xFF0B0C10),
    landingGradientEnd: Color(0xFF1F2833),
    surfaceNav: Color(0xFF020617),
    surfaceCard: Color(0xFF020617),
    surfaceElevated: Color(0xFF1E293B),
    surfaceAbout: Color(0xFFF6F7FB),
    surfaceModal: _modalSurface,
    borderSubtle: Color(0x14FFFFFF),
    textPrimary: Colors.white,
    textSecondary: Color(0xB3FFFFFF),
    textMuted: Color(0x8AFFFFFF),
    textOnModal: _textOnModal,
    textOnModalMuted: _textOnModalMuted,
    accentTeal: Color(0xFF2DD4BF),
    accentPurple: Color(0xFF6A5AE0),
    liveBadgeBg: Color(0x262DD4BF),
    liveBadgeBorder: Color(0x662DD4BF),
    scrim: Color(0xB3000000),
    footerBg: Color(0xFF0B0F1A),
    chipFill: Color(0x0DFFFFFF),
    chipBorder: Color(0x14FFFFFF),
    statFill: Color(0x0DFFFFFF),
    statBorder: Color(0x14FFFFFF),
    shadowColor: Color(0x40000000),
    aboutLabelBg: Color(0xFFEEF2FF),
    aboutAccent: Color(0xFF4F46E5),
  );

  static const light = AppPalette(
    pageGradientStart: Color(0xFFE8EEF5),
    pageGradientEnd: Color(0xFFDCE4EE),
    landingGradientStart: Color(0xFFF0F2F8),
    landingGradientEnd: Color(0xFFE2E8F0),
    surfaceNav: Color(0xFFF8FAFC),
    surfaceCard: Color(0xFFE8EEF5),
    surfaceElevated: _lightCardSurface,
    surfaceAbout: Color(0xFFEEF2FF),
    surfaceModal: _modalSurface,
    borderSubtle: Color(0x260F172A),
    textPrimary: oxfordBlue,
    textSecondary: Color(0xFF6B7280),
    textMuted: Color(0xFF9CA3AF),
    textOnModal: _textOnModal,
    textOnModalMuted: _textOnModalMuted,
    accentTeal: Color(0xFF2DD4BF),
    accentPurple: Color(0xFF6A5AE0),
    liveBadgeBg: Color(0x1F2DD4BF),
    liveBadgeBorder: Color(0x662DD4BF),
    scrim: Color(0x80000000),
    footerBg: Color(0xFF1F2937),
    chipFill: Color(0x0F0F172A),
    chipBorder: Color(0xFFD0D9E4),
    statFill: _lightCardSurface,
    statBorder: Color(0xFFD0D9E4),
    shadowColor: Color(0x220F172A),
    aboutLabelBg: Color(0xFFE0E7FF),
    aboutAccent: Color(0xFF4F46E5),
  );

  @override
  AppPalette copyWith({
    Color? pageGradientStart,
    Color? pageGradientEnd,
    Color? landingGradientStart,
    Color? landingGradientEnd,
    Color? surfaceNav,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceAbout,
    Color? surfaceModal,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOnModal,
    Color? textOnModalMuted,
    Color? accentTeal,
    Color? accentPurple,
    Color? liveBadgeBg,
    Color? liveBadgeBorder,
    Color? scrim,
    Color? footerBg,
    Color? chipFill,
    Color? chipBorder,
    Color? statFill,
    Color? statBorder,
    Color? shadowColor,
    Color? aboutLabelBg,
    Color? aboutAccent,
  }) {
    return AppPalette(
      pageGradientStart: pageGradientStart ?? this.pageGradientStart,
      pageGradientEnd: pageGradientEnd ?? this.pageGradientEnd,
      landingGradientStart: landingGradientStart ?? this.landingGradientStart,
      landingGradientEnd: landingGradientEnd ?? this.landingGradientEnd,
      surfaceNav: surfaceNav ?? this.surfaceNav,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceAbout: surfaceAbout ?? this.surfaceAbout,
      surfaceModal: surfaceModal ?? this.surfaceModal,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOnModal: textOnModal ?? this.textOnModal,
      textOnModalMuted: textOnModalMuted ?? this.textOnModalMuted,
      accentTeal: accentTeal ?? this.accentTeal,
      accentPurple: accentPurple ?? this.accentPurple,
      liveBadgeBg: liveBadgeBg ?? this.liveBadgeBg,
      liveBadgeBorder: liveBadgeBorder ?? this.liveBadgeBorder,
      scrim: scrim ?? this.scrim,
      footerBg: footerBg ?? this.footerBg,
      chipFill: chipFill ?? this.chipFill,
      chipBorder: chipBorder ?? this.chipBorder,
      statFill: statFill ?? this.statFill,
      statBorder: statBorder ?? this.statBorder,
      shadowColor: shadowColor ?? this.shadowColor,
      aboutLabelBg: aboutLabelBg ?? this.aboutLabelBg,
      aboutAccent: aboutAccent ?? this.aboutAccent,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      pageGradientStart:
          Color.lerp(pageGradientStart, other.pageGradientStart, t)!,
      pageGradientEnd: Color.lerp(pageGradientEnd, other.pageGradientEnd, t)!,
      landingGradientStart:
          Color.lerp(landingGradientStart, other.landingGradientStart, t)!,
      landingGradientEnd:
          Color.lerp(landingGradientEnd, other.landingGradientEnd, t)!,
      surfaceNav: Color.lerp(surfaceNav, other.surfaceNav, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceAbout: Color.lerp(surfaceAbout, other.surfaceAbout, t)!,
      surfaceModal: Color.lerp(surfaceModal, other.surfaceModal, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textOnModal: Color.lerp(textOnModal, other.textOnModal, t)!,
      textOnModalMuted:
          Color.lerp(textOnModalMuted, other.textOnModalMuted, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      liveBadgeBg: Color.lerp(liveBadgeBg, other.liveBadgeBg, t)!,
      liveBadgeBorder: Color.lerp(liveBadgeBorder, other.liveBadgeBorder, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      footerBg: Color.lerp(footerBg, other.footerBg, t)!,
      chipFill: Color.lerp(chipFill, other.chipFill, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      statFill: Color.lerp(statFill, other.statFill, t)!,
      statBorder: Color.lerp(statBorder, other.statBorder, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      aboutLabelBg: Color.lerp(aboutLabelBg, other.aboutLabelBg, t)!,
      aboutAccent: Color.lerp(aboutAccent, other.aboutAccent, t)!,
    );
  }
}

/// Fixed status accent colors (same in light and dark).
abstract final class AppStatusColors {
  static const live = Color(0xFF2DD4BF);
  static const inProgress = Color(0xFFF59E0B);
  static const completed = Color(0xFF9CA3AF);
}
