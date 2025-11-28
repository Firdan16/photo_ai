import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

/// Main preview widget for displaying original/generated images
class MainPreview extends StatelessWidget {
  final File? selectedImage;
  final List<Uint8List> generatedImages;
  final int selectedImageIndex;
  final bool isUploading;
  final bool isGenerating;
  final Animation<double> fadeAnimation;
  final PageController carouselController;
  final VoidCallback onReset;
  final VoidCallback onTapEmpty;
  final ValueChanged<int> onPageChanged;

  const MainPreview({
    super.key,
    required this.selectedImage,
    required this.generatedImages,
    required this.selectedImageIndex,
    required this.isUploading,
    required this.isGenerating,
    required this.fadeAnimation,
    required this.carouselController,
    required this.onReset,
    required this.onTapEmpty,
    required this.onPageChanged,
  });

  bool get _showOriginal => selectedImageIndex == -1 && selectedImage != null;

  double get _containerHeight {
    if (selectedImage == null && generatedImages.isEmpty) {
      return 260.h;
    }
    return 410.h;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: generatedImages.isNotEmpty
              ? fadeAnimation
              : const AlwaysStoppedAnimation(1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildContent(),
          ),
        ),
        if (generatedImages.isNotEmpty || selectedImage != null)
          _buildResetButton(),
      ],
    );
  }

  Widget _buildContent() {
    if (_showOriginal) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    }

    if (generatedImages.isNotEmpty) {
      return _buildGeneratedCarousel();
    }

    if (selectedImage != null) {
      return _buildSelectedImageWithOverlay();
    }

    if (isGenerating) {
      return const _LoadingPreview();
    }

    return _EmptyPreview(onTap: onTapEmpty);
  }

  Widget _buildGeneratedCarousel() {
    return PageView.builder(
      controller: carouselController,
      itemCount: generatedImages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Image.memory(generatedImages[index], fit: BoxFit.cover);
      },
    );
  }

  Widget _buildSelectedImageWithOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(selectedImage!, fit: BoxFit.cover),
        if (isUploading || isGenerating) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              isUploading ? 'Uploading...' : 'Dreaming...',
              style: AppTypography.bodyLarge.semibold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: ScaleOnTap(
        onTap: onReset,
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close_rounded, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }
}

/// Loading preview with bouncing dots
class _LoadingPreview extends StatelessWidget {
  const _LoadingPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BouncingDotsLoader(color: AppColors.primary, size: 12.r),
            SizedBox(height: 24.h),
            PulseAnimation(
              child: Text(
                'Creating your masterpiece...',
                style: AppTypography.bodyLarge.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty preview prompting user to add photo
class _EmptyPreview extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyPreview({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Container(
        decoration: BoxDecoration(color: AppColors.background),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeSlideIn(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 40.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            FadeSlideIn(
              delay: const Duration(milliseconds: 400),
              child: Text('Start Creating', style: AppTypography.h4),
            ),
            SizedBox(height: 8.h),
            FadeSlideIn(
              delay: const Duration(milliseconds: 500),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Upload a photo or describe your idea below to get started',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.secondary.copyWith(height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
