/**
 * Cloud Function: generateImage
 *
 * Generates AI images using Google Gemini API.
 * Supports text-to-image and image-to-image generation.
 * Results are stored in Firebase Storage and metadata in Firestore.
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { CallableRequest } from "firebase-functions/v2/https";
import { StorageService } from "../services/storage_service";
import { GeminiImageService, AspectRatio } from "../services/gemini_service";

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
db.settings({ databaseId: "photo" });

const storageService = new StorageService();
const geminiService = new GeminiImageService();

/** Request parameters for image generation */
interface ImageGenerationRequest {
  prompt: string;
  originalUrl?: string;
  inputImageUrl?: string;
  inputImageBase64?: string;
  inputImageMimeType?: string;
  sampleCount?: number;
  aspectRatio?: AspectRatio;
  generationId?: string;
}

/** Response from image generation */
interface ImageGenerationResponse {
  success: boolean;
  images?: string[];
  imageUrls?: string[];
  generationId?: string;
  error?: string;
}

/**
 * Firebase Callable Function for AI image generation
 * Requires authenticated user (anonymous auth supported)
 */
export const generateImage = functions.https.onCall(
  async (
    request: CallableRequest<ImageGenerationRequest>
  ): Promise<ImageGenerationResponse> => {
    const data = request.data;
    const auth = request.auth;

    try {
      // Validate request
      if (!data.prompt) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Prompt is required"
        );
      }

      const uid = auth?.uid;
      if (!uid) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated"
        );
      }

      const sampleCount = Math.min(Math.max(data.sampleCount || 4, 1), 4);
      const generationId = data.generationId ||
        `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

      // Prepare input image for image-to-image editing
      let inputImage: { base64Data: string; mimeType: string } | undefined;

      if (data.inputImageUrl) {
        inputImage = await geminiService.downloadImageAsBase64(
          data.inputImageUrl
        );
      } else if (data.inputImageBase64) {
        inputImage = {
          base64Data: data.inputImageBase64,
          mimeType: data.inputImageMimeType || "image/jpeg",
        };
      }

      // Generate images via Gemini API
      const results = await geminiService.generateImages({
        prompt: data.prompt,
        sampleCount,
        inputImage,
        aspectRatio: data.aspectRatio,
      });

      // Upload to Firebase Storage
      const imageUrls: string[] = [];
      const images: string[] = [];

      for (let i = 0; i < results.length; i++) {
        const url = await storageService.uploadGeneratedImage(
          uid,
          generationId,
          i,
          results[i].base64Data
        );
        imageUrls.push(url);
        images.push(results[i].base64Data);
      }

      // Save to Firestore
      const userRef = db.collection("users").doc(uid);

      await userRef.set({
        lastActive: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      await userRef.collection("generations").doc(generationId).set({
        prompt: data.prompt,
        originalUrl: data.originalUrl || null,
        inputImageUrl: data.inputImageUrl || null,
        hasInputImage: !!inputImage,
        aspectRatio: data.aspectRatio || null,
        generatedImages: imageUrls,
        count: images.length,
        status: "completed",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return {
        success: true,
        images,
        imageUrls,
        generationId,
      };
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (error: any) {
      console.error("generateImage error:", error.message);

      if (error instanceof functions.https.HttpsError) {
        throw error;
      }

      return {
        success: false,
        error: error.message || "Failed to generate image",
      };
    }
  }
);
