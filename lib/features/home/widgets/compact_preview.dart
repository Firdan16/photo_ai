import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';

class CompactPreview extends StatelessWidget {
  final File selectedImage;
  final VoidCallback onChangeTap;
  final VoidCallback onResetTap;

  const CompactPreview({
    super.key,
    required this.selectedImage,
    required this.onChangeTap,
    required this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              selectedImage,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo Ready',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Select a scene above, then generate!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onChangeTap,
            icon: Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.textSecondary,
              size: 18.sp,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.background,
              shape: const CircleBorder(),
            ),
          ),
          IconButton(
            onPressed: onResetTap,
            icon: Icon(
              Icons.close_rounded,
              color: Colors.red.shade400,
              size: 18.sp,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
