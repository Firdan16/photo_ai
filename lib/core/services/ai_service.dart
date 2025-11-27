import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';

/// Response model for image generation
class GenerateImagesResponse {
  final List<String> imagesBase64;
  final List<String> imageUrls;
  final String? generationId;

  const GenerateImagesResponse({
    required this.imagesBase64,
    required this.imageUrls,
    this.generationId,
  });

  factory GenerateImagesResponse.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final urls = json['imageUrls'] as List<dynamic>? ?? [];

    return GenerateImagesResponse(
      imagesBase64: images.map((e) => e.toString()).toList(),
      imageUrls: urls.map((e) => e.toString()).toList(),
      generationId: json['generationId'] as String?,
    );
  }

  /// Convert base64 strings to Uint8List for Image.memory()
  List<Uint8List> get imagesBytes {
    return imagesBase64.map((b64) => base64Decode(b64)).toList();
  }
}

/// Service for AI image generation via Cloud Functions
class AiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Generate images from text prompt using Gemini via Cloud Function
  Future<GenerateImagesResponse> generateImages({
    required String prompt,
    String? originalUrl,
    String? inputImageUrl,
    String? inputImageBase64,
    String? inputImageMimeType,
    int sampleCount = 4,
    String? aspectRatio,
  }) async {
    final clampedCount = sampleCount.clamp(1, 4);

    try {
      final callable = _functions.httpsCallable(
        'generateImage',
        options: HttpsCallableOptions(timeout: const Duration(minutes: 5)),
      );

      final params = <String, dynamic>{
        'prompt': prompt,
        'sampleCount': clampedCount,
        if (originalUrl != null) 'originalUrl': originalUrl,
        if (inputImageUrl != null) 'inputImageUrl': inputImageUrl,
        if (inputImageBase64 != null) 'inputImageBase64': inputImageBase64,
        if (inputImageMimeType != null)
          'inputImageMimeType': inputImageMimeType,
        if (aspectRatio != null) 'aspectRatio': aspectRatio,
      };

      final result = await callable.call(params);
      final data = result.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw AiServiceException(
          data['error']?.toString() ?? 'Image generation failed',
        );
      }

      return GenerateImagesResponse.fromJson(data);
    } on FirebaseFunctionsException catch (e) {
      throw AiServiceException(
        'Cloud Function error: ${e.message ?? e.code}',
        code: e.code,
      );
    } catch (e) {
      if (e is AiServiceException) rethrow;
      throw AiServiceException('Failed to generate images: $e');
    }
  }
}

/// Custom exception for AI Service
class AiServiceException implements Exception {
  final String message;
  final String? code;

  const AiServiceException(this.message, {this.code});

  @override
  String toString() => message;
}
