import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

class ImageCarousel extends StatelessWidget {
  final List<Uint8List> images;
  final int selectedIndex;
  final Function(int) onTap;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      separatorBuilder: (context, index) => SizedBox(width: 12.w),
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return ScaleReveal(
          delay: Duration(milliseconds: 100 * index),
          child: ScaleOnTap(
            onTap: () => onTap(index),
            scaleDown: 0.95,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected ? AppShadows.card : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(images[index], fit: BoxFit.cover),
                    // Selection overlay
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 0.0 : 0.1,
                      child: Container(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
