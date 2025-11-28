import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const ActionButtons({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            onTap: onGalleryTap,
            color: const Color(0xFF8E2DE2),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionButton(
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            onTap: onCameraTap,
            color: const Color(0xFF4A00E0),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTypography.body.semibold.copyWith(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
