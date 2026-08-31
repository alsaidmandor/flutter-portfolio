import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AccentPalette {
  cyan('Electric Cyan', Color(0xFF00E5FF), Color(0xFF59C8FF), Color(0xFF7DFFCF)),
  violet('Cyber Violet', Color(0xFFA855F7), Color(0xFFC084FC), Color(0xFFF472B6)),
  emerald('Emerald Aurora', Color(0xFF10B981), Color(0xFF34D399), Color(0xFF38BDF8)),
  amber('Sunset Amber', Color(0xFFF59E0B), Color(0xFFFBBF24), Color(0xFFFF6B6B));

  const AccentPalette(this.label, this.primary, this.lightPrimary, this.secondary);

  final String label;
  final Color primary;
  final Color lightPrimary;
  final Color secondary;
}

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._();
  ThemeController._();

  AccentPalette _palette = AccentPalette.cyan;
  AccentPalette get palette => _palette;

  void setPalette(AccentPalette newPalette) {
    if (_palette != newPalette) {
      _palette = newPalette;
      notifyListeners();
    }
  }
}

abstract final class AppColors {
  static const background = Color(0xFF070B14);
  static const backgroundDeep = Color(0xFF04070D);
  static const surface = Color(0xFF0D1524);
  static const surfaceSoft = Color(0xFF121E33);
  static const surfaceGlass = Color(0xCC0D1524);
  static const border = Color(0xFF1E2E48);
  static const borderGlow = Color(0x3359C8FF);
  static const text = Color(0xFFF4F8FC);
  static const textMuted = Color(0xFF94A3B8);
  static const textDim = Color(0xFF64748B);

  // Dynamic colors derived from current palette
  static Color get primary => ThemeController.instance.palette.primary;
  static Color get lightPrimary => ThemeController.instance.palette.lightPrimary;
  static Color get secondary => ThemeController.instance.palette.secondary;
}

abstract final class AppTheme {
  static ThemeData get dark {
    final palette = ThemeController.instance.palette;
    
    final baseTextTheme = ThemeData.dark().textTheme;
    
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: palette.primary,
        secondary: palette.secondary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.text,
          fontSize: 64,
          height: 1.05,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.text,
          fontSize: 38,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.text,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 17,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted,
          fontSize: 14,
          height: 1.55,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      useMaterial3: true,
    );
  }
}

