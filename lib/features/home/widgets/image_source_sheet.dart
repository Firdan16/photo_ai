import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';

/// Bottom sheet for selecting image source (gallery or camera)
class ImageSourceSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const ImageSourceSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGalleryTap,
    required VoidCallback onCameraTap,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => ImageSourceSheet(
        onGalleryTap: () {
          Navigator.pop(context);
          onGalleryTap();
        },
        onCameraTap: () {
          Navigator.pop(context);
          onCameraTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            SizedBox(height: 20.h),
            Text('Add Photo', style: AppTypography.h5),
            SizedBox(height: 20.h),
            _buildOption(
              icon: Icons.photo_library_outlined,
              title: 'Choose from Gallery',
              onTap: onGalleryTap,
            ),
            SizedBox(height: 8.h),
            _buildOption(
              icon: Icons.camera_alt_outlined,
              title: 'Take a Photo',
              onTap: onCameraTap,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22.sp),
      ),
      title: Text(title, style: AppTypography.labelMedium),
      onTap: onTap,
    );
  }
}
