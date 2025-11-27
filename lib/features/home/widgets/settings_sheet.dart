import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';

/// Generation settings data class
class GenerationSettings {
  final int sampleCount;
  final String aspectRatio;
  final String quality;

  const GenerationSettings({
    this.sampleCount = 4,
    this.aspectRatio = '1:1',
    this.quality = 'Standard',
  });

  GenerationSettings copyWith({
    int? sampleCount,
    String? aspectRatio,
    String? quality,
  }) {
    return GenerationSettings(
      sampleCount: sampleCount ?? this.sampleCount,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      quality: quality ?? this.quality,
    );
  }
}

/// Bottom sheet for generation settings
class SettingsSheet extends StatefulWidget {
  final GenerationSettings settings;
  final ValueChanged<GenerationSettings> onSettingsChanged;

  const SettingsSheet({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required GenerationSettings settings,
    required ValueChanged<GenerationSettings> onSettingsChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) => SettingsSheet(
        settings: settings,
        onSettingsChanged: onSettingsChanged,
      ),
    );
  }

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late GenerationSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSettings(GenerationSettings newSettings) {
    setState(() => _settings = newSettings);
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),
            SizedBox(height: 20.h),
            _buildTitle(),
            SizedBox(height: 28.h),
            _buildSampleCountSection(),
            SizedBox(height: 24.h),
            _buildAspectRatioSection(),
            SizedBox(height: 24.h),
            _buildQualitySection(),
            SizedBox(height: 28.h),
            _buildDoneButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(child: Text('Generation Settings', style: AppTypography.h4));
  }

  Widget _buildSampleCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Number of Images', style: AppTypography.label),
        SizedBox(height: 4.h),
        Text('How many variations to generate', style: AppTypography.caption),
        SizedBox(height: 12.h),
        Row(
          children: [1, 2, 4].map((count) {
            final isSelected = _settings.sampleCount == count;
            return Expanded(
              child: _buildOptionCard(
                isSelected: isSelected,
                onTap: () =>
                    _updateSettings(_settings.copyWith(sampleCount: count)),
                child: Column(
                  children: [
                    Text(
                      '$count',
                      style: AppTypography.number.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      count == 1 ? 'image' : 'images',
                      style: AppTypography.overline.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAspectRatioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aspect Ratio', style: AppTypography.label),
        SizedBox(height: 4.h),
        Text('Output image dimensions', style: AppTypography.caption),
        SizedBox(height: 12.h),
        Row(
          children: ['1:1', '16:9', '9:16'].map((ratio) {
            final isSelected = _settings.aspectRatio == ratio;
            return Expanded(
              child: _buildOptionCard(
                isSelected: isSelected,
                onTap: () =>
                    _updateSettings(_settings.copyWith(aspectRatio: ratio)),
                child: Column(
                  children: [
                    Icon(
                      ratio == '1:1'
                          ? Icons.crop_square_rounded
                          : ratio == '16:9'
                          ? Icons.crop_landscape_rounded
                          : Icons.crop_portrait_rounded,
                      size: 24.sp,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      ratio,
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQualitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quality', style: AppTypography.label),
        SizedBox(height: 4.h),
        Text(
          'Higher quality takes longer to generate',
          style: AppTypography.caption,
        ),
        SizedBox(height: 12.h),
        Row(
          children: ['Standard', 'HD'].map((q) {
            final isSelected = _settings.quality == q;
            return Expanded(
              child: _buildOptionCard(
                isSelected: isSelected,
                onTap: () => _updateSettings(_settings.copyWith(quality: q)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      q == 'Standard' ? Icons.speed_rounded : Icons.hd_rounded,
                      size: 20.sp,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      q,
                      style: AppTypography.buttonSmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(child: Text('Done', style: AppTypography.button)),
      ),
    );
  }
}
