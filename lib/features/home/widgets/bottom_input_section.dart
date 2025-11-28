import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

/// Bottom section with prompt input and generate button
class BottomInputSection extends StatelessWidget {
  final TextEditingController promptController;
  final int sampleCount;
  final bool isGenerating;
  final bool showInput;
  final int styleCount;
  final VoidCallback onSettingsTap;
  final VoidCallback onStyleTap;
  final VoidCallback onGenerateTap;

  const BottomInputSection({
    super.key,
    required this.promptController,
    required this.sampleCount,
    required this.isGenerating,
    this.showInput = false,
    this.styleCount = 0,
    required this.onSettingsTap,
    required this.onStyleTap,
    required this.onGenerateTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      child: showInput ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPromptInput(),
            SizedBox(height: 20.h),
            _buildButtonRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: promptController,
        maxLines: 3,
        minLines: 1,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.textPrimary,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Add details about what you want (optional)',
          hintStyle: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        _buildSettingsButton(),
        SizedBox(width: 12.w),
        _buildStyleButton(),
        SizedBox(width: 12.w),
        Expanded(child: _buildGenerateButton()),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return ScaleOnTap(
      onTap: onSettingsTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.tune_rounded, size: 24.sp, color: AppColors.textPrimary),
            Positioned(top: 8.h, right: 8.w, child: _buildBadge(sampleCount)),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleButton() {
    return ScaleOnTap(
      onTap: onStyleTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 24.sp,
              color: AppColors.textPrimary,
            ),
            if (styleCount > 0)
              Positioned(top: 8.h, right: 8.w, child: _buildBadge(styleCount)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(int count) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 18.w,
      height: 18.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ScaleOnTap(
      onTap: isGenerating ? null : onGenerateTap,
      enabled: !isGenerating,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isGenerating
                ? _buildLoadingContent()
                : _buildGenerateContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Creating...',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateContent() {
    return Row(
      key: const ValueKey('generate'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.auto_awesome, color: Colors.white, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          'Generate',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
