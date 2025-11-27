import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

class StoryThumbnail extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final Widget child;

  const StoryThumbnail({
    super.key,
    required this.onTap,
    this.isSelected = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: const Duration(milliseconds: 200),
      beginOffset: const Offset(-20, 0),
      child: ScaleOnTap(
        onTap: onTap,
        scaleDown: 0.95,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 3 : 1.5,
            ),
            boxShadow: AppShadows.card,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isSelected ? 13.r : 14.r),
            child: child,
          ),
        ),
      ),
    );
  }
}
