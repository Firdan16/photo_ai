import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/services/ai_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../core/utils/error_helper.dart';
import '../../core/utils/image_picker_helper.dart';
import 'widgets/widgets.dart';

/// Main home screen for Photo AI app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _promptController = TextEditingController();
  final _carouselController = PageController();

  // Services
  final _aiService = AiService();
  final _storageService = StorageService();

  // State
  File? _selectedImage;
  String? _uploadedImageUrl;
  List<Uint8List> _generatedImages = [];
  int _selectedImageIndex = 0;
  String? _errorMessage;

  // Loading states
  bool _isUploading = false;
  bool _isGenerating = false;

  // Settings
  int _sampleCount = 4;
  String _aspectRatio = '1:1';
  String _quality = 'Standard';

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _animationController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Image Selection
  // ─────────────────────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────────────────────
  // Image Generation
  // ─────────────────────────────────────────────────────────────────────────────

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
    if (_promptController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please describe what you want to create');
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
      if (_selectedImage != null && _uploadedImageUrl == null) {
        await _uploadImage();
      }

      final response = await _aiService.generateImages(
        prompt: _promptController.text.trim(),
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

  // ─────────────────────────────────────────────────────────────────────────────
  // Navigation & State Management
  // ─────────────────────────────────────────────────────────────────────────────

  void _onThumbnailTap(int index) {
    setState(() => _selectedImageIndex = index);
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showOriginalImage() {
    setState(() => _selectedImageIndex = -1);
  }

  void _resetGeneration() {
    setState(() {
      _selectedImage = null;
      _uploadedImageUrl = null;
      _generatedImages = [];
      _selectedImageIndex = 0;
      _errorMessage = null;
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

  void _setError(dynamic e) {
    setState(() => _errorMessage = ErrorHelper.getUserFriendlyMessage(e));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Expanded(child: _buildContent()),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Photo AI',
              style: AppTypography.h1.copyWith(height: 1.0),
            ),
          ),
          SizedBox(height: 4.h),
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Create your masterpiece',
              style: AppTypography.body.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
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
            onPageChanged: (index) {
              setState(() => _selectedImageIndex = index);
            },
          ),
          SizedBox(height: 20.h),
          ThumbnailsRow(
            selectedImage: _selectedImage,
            generatedImages: _generatedImages,
            selectedImageIndex: _selectedImageIndex,
            onOriginalTap: _showOriginalImage,
            onAddTap: _showImageSourcePicker,
            onGeneratedTap: _onThumbnailTap,
          ),
          SizedBox(height: 24.h),
          if (_errorMessage != null) ...[
            ErrorMessage(message: _errorMessage!),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return BottomInputSection(
      promptController: _promptController,
      sampleCount: _sampleCount,
      isGenerating: _isGenerating,
      onSettingsTap: _showSettingsSheet,
      onGenerateTap: _generateImages,
    );
  }
}
