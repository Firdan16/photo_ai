import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Stacked preview images
          SizedBox(
            height: 100.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background card 1
                Positioned(
                  left: 60.w,
                  child: Transform.rotate(
                    angle: 0.15,
                    child: _buildPreviewCard('🌅', const Color(0xFFFFE4D6)),
                  ),
                ),
                // Background card 2
                Positioned(
                  right: 60.w,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: _buildPreviewCard('🌃', const Color(0xFFD6E4FF)),
                  ),
                ),
                // Front card
                _buildPreviewCard('✨', const Color(0xFFF0E6FF), isMain: true),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF1a1a1a), Color(0xFF4a4a4a)],
            ).createShader(bounds),
            child: Text(
              'Create Magic',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            'Turn your selfies into stunning\nprofessional photos instantly',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textSecondary,
              height: 1.5,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 20.h),

          // Feature pills
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              _FeaturePill(
                text: 'AI Powered',
                icon: Icons.auto_awesome_rounded,
              ),
              _FeaturePill(text: 'Instant', icon: Icons.bolt_rounded),
              _FeaturePill(
                text: 'HD Quality',
                icon: Icons.high_quality_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(String emoji, Color color, {bool isMain = false}) {
    return Container(
      width: isMain ? 90.w : 70.w,
      height: isMain ? 90.w : 70.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isMain
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: isMain ? 36.sp : 28.sp)),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String text;
  final IconData icon;

  const _FeaturePill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
