import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import 'image_carousel.dart';
import 'story_thumbnail.dart';

/// Row of thumbnails showing original and generated images
class ThumbnailsRow extends StatelessWidget {
  final File? selectedImage;
  final List<Uint8List> generatedImages;
  final int selectedImageIndex;
  final VoidCallback onOriginalTap;
  final VoidCallback onAddTap;
  final ValueChanged<int> onGeneratedTap;

  const ThumbnailsRow({
    super.key,
    required this.selectedImage,
    required this.generatedImages,
    required this.selectedImageIndex,
    required this.onOriginalTap,
    required this.onAddTap,
    required this.onGeneratedTap,
  });

  bool get _isOriginalSelected =>
      selectedImageIndex == -1 ||
      (selectedImage != null && generatedImages.isEmpty);

  bool get _hasGeneratedImages => generatedImages.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Row(
        children: [
          _buildOriginalThumbnail(),
          SizedBox(width: 16.w),
          if (_hasGeneratedImages) _buildGeneratedCarousel(),
        ],
      ),
    );
  }

  Widget _buildOriginalThumbnail() {
    return StoryThumbnail(
      onTap: selectedImage != null && _hasGeneratedImages
          ? onOriginalTap
          : onAddTap,
      isSelected: _isOriginalSelected,
      child: selectedImage != null ? _buildOriginalImage() : _buildAddButton(),
    );
  }

  Widget _buildOriginalImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(selectedImage!, fit: BoxFit.cover),
        if (_hasGeneratedImages) _buildOriginalLabel(),
      ],
    );
  }

  Widget _buildOriginalLabel() {
    return Positioned(
      bottom: 4.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'Original',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.add_rounded,
          size: 32.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildGeneratedCarousel() {
    return Expanded(
      child: ImageCarousel(
        images: generatedImages,
        selectedIndex: selectedImageIndex,
        onTap: onGeneratedTap,
      ),
    );
  }
}
