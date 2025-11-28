import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/generation_options.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

/// Style configuration bottom sheet for Color Tone, Framing, and Creativity
class StyleConfigSheet extends StatefulWidget {
  final ColorTone? selectedColorTone;
  final FramingOption? selectedFraming;
  final VariationLevel? selectedVariation;
  final ValueChanged<ColorTone?> onColorToneChanged;
  final ValueChanged<FramingOption?> onFramingChanged;
  final ValueChanged<VariationLevel?> onVariationChanged;

  const StyleConfigSheet({
    super.key,
    this.selectedColorTone,
    this.selectedFraming,
    this.selectedVariation,
    required this.onColorToneChanged,
    required this.onFramingChanged,
    required this.onVariationChanged,
  });

  /// Show the style configuration sheet
  static Future<void> show(
    BuildContext context, {
    ColorTone? selectedColorTone,
    FramingOption? selectedFraming,
    VariationLevel? selectedVariation,
    required ValueChanged<ColorTone?> onColorToneChanged,
    required ValueChanged<FramingOption?> onFramingChanged,
    required ValueChanged<VariationLevel?> onVariationChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleConfigSheet(
        selectedColorTone: selectedColorTone,
        selectedFraming: selectedFraming,
        selectedVariation: selectedVariation,
        onColorToneChanged: onColorToneChanged,
        onFramingChanged: onFramingChanged,
        onVariationChanged: onVariationChanged,
      ),
    );
  }

  @override
  State<StyleConfigSheet> createState() => _StyleConfigSheetState();
}

class _StyleConfigSheetState extends State<StyleConfigSheet> {
  late ColorTone? _colorTone;
  late FramingOption? _framing;
  late VariationLevel? _variation;

  @override
  void initState() {
    super.initState();
    _colorTone = widget.selectedColorTone;
    _framing = widget.selectedFraming;
    _variation = widget.selectedVariation;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 16.w, 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Style Settings',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 24.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.background,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Color Tone Section
                      _buildSection(
                        title: 'Color Tone',
                        subtitle: 'Choose the mood of your photo',
                        child: _buildColorToneOptions(),
                      ),
                      SizedBox(height: 28.h),

                      // Framing Section
                      _buildSection(
                        title: 'Framing',
                        subtitle: 'How should the photo be composed',
                        child: _buildFramingOptions(),
                      ),
                      SizedBox(height: 28.h),

                      // Creativity Section
                      _buildSection(
                        title: 'Creativity Level',
                        subtitle: 'How creative should AI be',
                        child: _buildVariationOptions(),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              // Apply Button - Fixed at bottom
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _applyChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Apply Style',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textTertiary),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  Widget _buildColorToneOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: ColorTone.all.map((tone) {
        final isSelected = _colorTone?.id == tone.id;
        return _OptionChip(
          emoji: tone.emoji,
          label: tone.name,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _colorTone = isSelected ? null : tone;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFramingOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: FramingOption.all.map((framing) {
        final isSelected = _framing?.id == framing.id;
        return _OptionChip(
          emoji: framing.emoji,
          label: framing.name,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _framing = isSelected ? null : framing;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildVariationOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: VariationLevel.all.map((variation) {
        final isSelected = _variation?.id == variation.id;
        return _OptionChip(
          emoji: variation.emoji,
          label: variation.name,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _variation = isSelected ? null : variation;
            });
          },
        );
      }).toList(),
    );
  }

  void _applyChanges() {
    widget.onColorToneChanged(_colorTone);
    widget.onFramingChanged(_framing);
    widget.onVariationChanged(_variation);
    Navigator.pop(context);
  }
}

/// Option chip for style selection
class _OptionChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
