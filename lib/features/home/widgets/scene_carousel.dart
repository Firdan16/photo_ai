import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/scene_options.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

/// Visual scene carousel with gradient cards like reference design
class SceneCarousel extends StatelessWidget {
  final SceneOption? selectedScene;
  final ValueChanged<SceneOption?> onSceneChanged;

  const SceneCarousel({
    super.key,
    this.selectedScene,
    required this.onSceneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            'Choose Scene',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: SceneOptions.all.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final scene = SceneOptions.all[index];
              final isSelected = selectedScene?.id == scene.id;
              return _SceneCard(
                scene: scene,
                isSelected: isSelected,
                gradient: _getGradient(index),
                onTap: () => onSceneChanged(isSelected ? null : scene),
              );
            },
          ),
        ),
      ],
    );
  }

  LinearGradient _getGradient(int index) {
    final gradients = [
      // Landscape scenes
      [const Color(0xFF1a1a2e), const Color(0xFF16213e)], // Night - dark blue
      [const Color(0xFFff7e5f), const Color(0xFFfeb47b)], // Sunset - orange
      [const Color(0xFF606c88), const Color(0xFF3f4c6b)], // Moody - gray blue
      [
        const Color(0xFF373b44),
        const Color(0xFF4286f4),
      ], // Dramatic - dark blue
      // Portrait scenes
      [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)], // Cafe - purple pink
      [
        const Color(0xFF667eea),
        const Color(0xFF764ba2),
      ], // Rooftop - blue purple
      [const Color(0xFF11998e), const Color(0xFF38ef7d)], // Street - teal green
      [const Color(0xFFf093fb), const Color(0xFFf5576c)], // Mirror - pink red
      [const Color(0xFFff9a9e), const Color(0xFFfecfef)], // Gym - soft pink
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Travel - blue cyan
      [
        const Color(0xFFfa709a),
        const Color(0xFFfee140),
      ], // Golden - pink yellow
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Beach - green cyan
      [
        const Color(0xFF30cfd0),
        const Color(0xFF330867),
      ], // Night out - cyan purple
      [const Color(0xFFffecd2), const Color(0xFFfcb69f)], // Home - cream orange
    ];
    return LinearGradient(
      colors: gradients[index % gradients.length],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _SceneCard extends StatelessWidget {
  final SceneOption scene;
  final bool isSelected;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _SceneCard({
    required this.scene,
    required this.isSelected,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100.w,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.grey : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
        ),
        child: Stack(
          children: [
            // Selection check
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.sp,
                    color: gradient.colors.first,
                  ),
                ),
              ),
            // Content
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scene.emoji, style: TextStyle(fontSize: 32.sp)),
                  SizedBox(height: 8.h),
                  Text(
                    scene.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
