import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/models/generation_options.dart';
import '../../core/models/scene_options.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../core/utils/error_helper.dart';
import '../../core/utils/image_picker_helper.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _promptController = TextEditingController();
  final _carouselController = PageController();
  final _aiService = AiService();
  final _storageService = StorageService();

  File? _selectedImage;
  String? _uploadedImageUrl;
  List<Uint8List> _generatedImages = [];
  int _selectedImageIndex = 0;
  String? _errorMessage;

  SceneOption? _selectedScene;
  ColorTone? _selectedColorTone;
  FramingOption? _selectedFraming;
  VariationLevel? _selectedVariation;

  bool _isUploading = false;
  bool _isGenerating = false;

  int _sampleCount = 4;
  String _aspectRatio = '1:1';
  String _quality = 'Standard';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _animationController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  int get _styleCount {
    int count = 0;
    if (_selectedColorTone != null) count++;
    if (_selectedFraming != null) count++;
    if (_selectedVariation != null) count++;
    return count;
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePickerHelper.pickFromGallery();
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _uploadedImageUrl = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> _captureImage() async {
    try {
      final image = await ImagePickerHelper.pickFromCamera();
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _uploadedImageUrl = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      _setError(e);
    }
  }

  void _showImageSourcePicker() {
    ImageSourceSheet.show(
      context,
      onGalleryTap: _pickImage,
      onCameraTap: _captureImage,
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    setState(() => _isUploading = true);

    try {
      final url = await _storageService.uploadOriginal(_selectedImage!);
      setState(() => _uploadedImageUrl = url);
    } catch (e) {
      _setError(e);
      rethrow;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _generateImages() async {
    final hasScene = _selectedScene != null;
    final hasCustomPrompt = _promptController.text.trim().isNotEmpty;

    if (!hasScene && !hasCustomPrompt) {
      setState(
        () => _errorMessage = 'Please select a scene or describe what you want',
      );
      return;
    }

    if (_selectedImage == null) {
      setState(() => _errorMessage = 'Please upload your photo first');
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _generatedImages = [];
      _selectedImageIndex = 0;
    });

    _animationController.reset();

    try {
      if (_uploadedImageUrl == null) await _uploadImage();

      final response = await _aiService.generateImages(
        prompt: _buildPrompt(),
        originalUrl: _uploadedImageUrl,
        inputImageUrl: _uploadedImageUrl,
        sampleCount: _sampleCount,
        aspectRatio: _aspectRatio,
      );

      if (mounted) {
        setState(() {
          _generatedImages = response.imagesBytes;
          _isGenerating = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        _setError(e);
      }
    }
  }

  String _buildPrompt() {
    final parts = <String>[];
    final isLandscapeScene =
        _selectedScene?.id.startsWith('landscape_') ?? false;

    if (_selectedScene != null) {
      parts.add(_selectedScene!.promptTemplate);
    } else {
      parts.add(
        'Transform this photo with the requested style while preserving '
        'the main subject and composition. Do not add or remove people or objects',
      );
    }

    if (_selectedColorTone != null &&
        _selectedColorTone!.promptAddition.isNotEmpty) {
      parts.add(_selectedColorTone!.promptAddition);
    }

    if (!isLandscapeScene &&
        _selectedFraming != null &&
        _selectedFraming!.promptAddition.isNotEmpty) {
      parts.add(_selectedFraming!.promptAddition);
    }

    if (_selectedVariation != null) {
      if (_selectedVariation!.value <= 0.25) {
        parts.add(
          'Keep the result very close to the original photo with minimal changes. '
          'Preserve all subjects exactly as they appear',
        );
      } else if (_selectedVariation!.value <= 0.5) {
        parts.add(
          'Apply moderate changes while keeping the original composition and subjects intact',
        );
      } else if (_selectedVariation!.value <= 0.75) {
        parts.add(
          'Allow creative interpretation while maintaining the core elements of the photo',
        );
      } else {
        parts.add(
          'Be creative with style and mood but preserve the main subject',
        );
      }
    } else {
      parts.add('Preserve the original subjects and composition');
    }

    if (_promptController.text.trim().isNotEmpty) {
      parts.add('Additional details: ${_promptController.text.trim()}');
    }

    parts.add('Make it look natural and high quality, suitable for social media');
    parts.add('Do not add any people or objects that are not in the original photo');

    return parts.join('. ');
  }

  void _onThumbnailTap(int index) {
    setState(() => _selectedImageIndex = index);
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showOriginalImage() => setState(() => _selectedImageIndex = -1);

  void _resetGeneration() {
    setState(() {
      _selectedImage = null;
      _uploadedImageUrl = null;
      _generatedImages = [];
      _selectedImageIndex = 0;
      _errorMessage = null;
      _selectedScene = null;
      _selectedColorTone = null;
      _selectedFraming = null;
      _selectedVariation = null;
      _promptController.clear();
    });
    _animationController.reset();
  }

  void _showSettingsSheet() {
    SettingsSheet.show(
      context,
      settings: GenerationSettings(
        sampleCount: _sampleCount,
        aspectRatio: _aspectRatio,
        quality: _quality,
      ),
      onSettingsChanged: (settings) {
        setState(() {
          _sampleCount = settings.sampleCount;
          _aspectRatio = settings.aspectRatio;
          _quality = settings.quality;
        });
      },
    );
  }

  void _showStyleConfigSheet() {
    StyleConfigSheet.show(
      context,
      selectedColorTone: _selectedColorTone,
      selectedFraming: _selectedFraming,
      selectedVariation: _selectedVariation,
      onColorToneChanged: (tone) => setState(() => _selectedColorTone = tone),
      onFramingChanged: (framing) => setState(() => _selectedFraming = framing),
      onVariationChanged: (v) => setState(() => _selectedVariation = v),
    );
  }

  void _setError(dynamic e) {
    setState(() => _errorMessage = ErrorHelper.getUserFriendlyMessage(e));
  }

  @override
  Widget build(BuildContext context) {
    final isResultMode = _generatedImages.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(isResultMode),
            Expanded(child: _buildContent(isResultMode)),
            _buildBottomSection(isResultMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isResultMode) {
    if (isResultMode) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Text('Result Images', style: AppTypography.h3),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Text('Photo AI', style: AppTypography.h1.copyWith(height: 1.0)),
          ),
          SizedBox(height: 4.h),
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Time to be Instagramable 😉',
              style: AppTypography.body.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isResultMode) {
    final shouldScroll = _selectedImage != null || isResultMode;

    return SingleChildScrollView(
      physics: shouldScroll ? null : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildContentBody(isResultMode),
      ),
    );
  }

  Widget _buildContentBody(bool isResultMode) {
    final stateKey = _selectedImage == null
        ? 'initial'
        : isResultMode
            ? 'result'
            : 'preview';

    return Column(
      key: ValueKey(stateKey),
      children: [
        SizedBox(height: 12.h),
        if (_selectedImage == null && !isResultMode)
          ..._buildInitialState()
        else if (_selectedImage != null && !isResultMode)
          ..._buildPreviewState()
        else
          ..._buildResultState(),
        SizedBox(height: 20.h),
        if (_errorMessage != null) ...[
          ErrorMessage(message: _errorMessage!),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }

  List<Widget> _buildInitialState() {
    return [
      FadeSlideIn(
        delay: const Duration(milliseconds: 100),
        child: const HeroSection(),
      ),
      SizedBox(height: 28.h),
      FadeSlideIn(
        delay: const Duration(milliseconds: 200),
        child: ActionButtons(
          onGalleryTap: _pickImage,
          onCameraTap: _captureImage,
        ),
      ),
      SizedBox(height: 28.h),
      FadeSlideIn(
        delay: const Duration(milliseconds: 300),
        child: SceneCarousel(
          selectedScene: _selectedScene,
          onSceneChanged: (scene) => setState(() => _selectedScene = scene),
        ),
      ),
      SizedBox(height: 32.h),
    ];
  }

  List<Widget> _buildPreviewState() {
    return [
      FadeSlideIn(
        delay: const Duration(milliseconds: 100),
        child: SceneCarousel(
          selectedScene: _selectedScene,
          onSceneChanged: (scene) => setState(() => _selectedScene = scene),
        ),
      ),
      SizedBox(height: 16.h),
      FadeSlideIn(
        delay: const Duration(milliseconds: 200),
        child: CompactPreview(
          selectedImage: _selectedImage!,
          onChangeTap: _showImageSourcePicker,
          onResetTap: _resetGeneration,
        ),
      ),
    ];
  }

  List<Widget> _buildResultState() {
    return [
      MainPreview(
        selectedImage: _selectedImage,
        generatedImages: _generatedImages,
        selectedImageIndex: _selectedImageIndex,
        isUploading: _isUploading,
        isGenerating: _isGenerating,
        fadeAnimation: _fadeAnimation,
        carouselController: _carouselController,
        onReset: _resetGeneration,
        onTapEmpty: _showImageSourcePicker,
        onPageChanged: (index) => setState(() => _selectedImageIndex = index),
      ),
      if (_selectedImage != null) ...[
        SizedBox(height: 20.h),
        FadeSlideIn(
          delay: const Duration(milliseconds: 200),
          child: ThumbnailsRow(
            selectedImage: _selectedImage,
            generatedImages: _generatedImages,
            selectedImageIndex: _selectedImageIndex,
            onOriginalTap: _showOriginalImage,
            onAddTap: _showImageSourcePicker,
            onGeneratedTap: _onThumbnailTap,
          ),
        ),
      ],
    ];
  }

  Widget _buildBottomSection(bool isResultMode) {
    final shouldShow = _selectedImage != null || isResultMode;

    return BottomInputSection(
      promptController: _promptController,
      sampleCount: _sampleCount,
      isGenerating: _isGenerating,
      showInput: shouldShow,
      styleCount: _styleCount,
      onSettingsTap: _showSettingsSheet,
      onStyleTap: _showStyleConfigSheet,
      onGenerateTap: _generateImages,
    );
  }
}
