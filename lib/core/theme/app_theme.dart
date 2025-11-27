import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// COLOR SYSTEM
// =============================================================================

class AppColors {
  AppColors._();

  // Primary colors
  static const primary = Color(0xFF000000);
  static const secondary = Color(0xFF333333);

  // Background colors
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
  static const surfaceVariant = Color(0xFFF5F5F5);

  // Text colors
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);
  static const textInverse = Colors.white;

  // Border & Divider
  static const border = Color(0xFFEEEEEE);
  static const divider = Color(0xFFF0F0F0);

  // Semantic colors
  static const error = Color(0xFFFF3B30);
  static const success = Color(0xFF34C759);
  static const warning = Color(0xFFFF9500);
  static const info = Color(0xFF007AFF);
}

// =============================================================================
// SHADOW SYSTEM
// =============================================================================

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20.r,
      offset: Offset(0, 4.h),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 10.r,
      offset: Offset(0, 2.h),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get floating => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 30.r,
      offset: Offset(0, 10.h),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8.r,
      offset: Offset(0, 2.h),
    ),
  ];
}

// =============================================================================
// TYPOGRAPHY SYSTEM - Using Google Fonts Inter
// =============================================================================

/// Typography Design System
///
/// Usage examples:
/// ```dart
/// Text('Title', style: AppTypography.h1)
/// Text('Body', style: AppTypography.body)
/// Text('Caption', style: AppTypography.caption.secondary)
/// Text('Button', style: AppTypography.button.white)
/// ```
class AppTypography {
  AppTypography._();

  // ---------------------------------------------------------------------------
  // HEADINGS
  // ---------------------------------------------------------------------------

  /// Hero/Display - 34sp, Extra Bold
  /// Use for: Main app title, hero sections
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 34.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  /// Page Title - 28sp, Bold
  /// Use for: Page titles, section headers
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Section Title - 22sp, Bold
  /// Use for: Card titles, dialog titles
  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Subtitle - 20sp, SemiBold
  /// Use for: Bottom sheet titles, list headers
  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Small Heading - 18sp, SemiBold
  /// Use for: Modal titles, form section headers
  static TextStyle get h5 => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // BODY TEXT
  // ---------------------------------------------------------------------------

  /// Body Large - 17sp, Regular
  /// Use for: Primary content, paragraphs
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body Default - 15sp, Regular
  /// Use for: General text, descriptions
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body Small - 14sp, Regular
  /// Use for: Secondary content
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // LABELS & UI TEXT
  // ---------------------------------------------------------------------------

  /// Label Large - 16sp, SemiBold
  /// Use for: List item titles, form labels
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Label Medium - 15sp, Medium
  /// Use for: Input labels, tab labels
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Label Small - 13sp, Medium
  /// Use for: Chip labels, badges
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // ---------------------------------------------------------------------------
  // BUTTONS
  // ---------------------------------------------------------------------------

  /// Button Large - 17sp, SemiBold
  /// Use for: Primary action buttons
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: Colors.white,
    height: 1.0,
  );

  /// Button Medium - 15sp, SemiBold
  /// Use for: Secondary buttons, text buttons
  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.primary,
    height: 1.0,
  );

  /// Button Small - 14sp, SemiBold
  /// Use for: Compact buttons, chips
  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: AppColors.primary,
    height: 1.0,
  );

  // ---------------------------------------------------------------------------
  // CAPTION & OVERLINE
  // ---------------------------------------------------------------------------

  /// Caption - 13sp, Regular
  /// Use for: Helper text, timestamps
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  /// Overline - 12sp, Medium, Uppercase
  /// Use for: Section labels, tags
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
    height: 1.0,
  );

  /// Micro - 10sp, Bold
  /// Use for: Badges, notification counts
  static TextStyle get micro => GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: Colors.white,
    height: 1.0,
  );

  // ---------------------------------------------------------------------------
  // INPUT TEXT
  // ---------------------------------------------------------------------------

  /// Input text - 16sp, Regular
  /// Use for: Text fields input
  static TextStyle get input => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Placeholder/Hint text - 16sp, Regular
  /// Use for: Input hints
  static TextStyle get hint => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // SPECIAL STYLES
  // ---------------------------------------------------------------------------

  /// Number Display - 24sp, Bold
  /// Use for: Stats, counts
  static TextStyle get number => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  /// Number Small - 14sp, SemiBold
  /// Use for: Small numbers, counters
  static TextStyle get numberSmall => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.0,
  );
}

// =============================================================================
// TEXT STYLE EXTENSIONS - For easy color & weight modifications
// =============================================================================

extension TextStyleExtensions on TextStyle {
  // Color modifiers
  TextStyle get primary => copyWith(color: AppColors.textPrimary);
  TextStyle get secondary => copyWith(color: AppColors.textSecondary);
  TextStyle get tertiary => copyWith(color: AppColors.textTertiary);
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get error => copyWith(color: AppColors.error);
  TextStyle get success => copyWith(color: AppColors.success);

  // Weight modifiers
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);

  // Size modifiers (relative)
  TextStyle get smaller => copyWith(fontSize: (fontSize ?? 14) - 2);
  TextStyle get larger => copyWith(fontSize: (fontSize ?? 14) + 2);

  // Custom color
  TextStyle withColor(Color color) => copyWith(color: color);

  // Custom opacity for color
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));
}

// =============================================================================
// LEGACY SUPPORT - AppTextStyles (for backward compatibility)
// =============================================================================

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => AppTypography.h1;
  static TextStyle get displayMedium => AppTypography.h2;
  static TextStyle get titleLarge => AppTypography.h3;
  static TextStyle get titleMedium => AppTypography.h4;
  static TextStyle get bodyLarge => AppTypography.bodyLarge;
  static TextStyle get bodyMedium => AppTypography.body;
  static TextStyle get labelLarge => AppTypography.label;
  static TextStyle get labelSmall => AppTypography.labelSmall;
  static TextStyle get button => AppTypography.button;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      // Set default text theme using Google Fonts Inter
      fontFamily: GoogleFonts.inter().fontFamily,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.labelLarge,
        labelSmall: AppTextStyles.labelSmall,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.bodyLarge,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.all(16.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
        space: 1,
      ),
    );
  }
}
