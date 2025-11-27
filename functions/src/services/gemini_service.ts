import axios from "axios";
import * as functions from "firebase-functions";
import {defineString} from "firebase-functions/params";
import {GoogleGenAI, Modality} from "@google/genai";

const geminiApiKey = defineString("GEMINI_API_KEY");

/** Supported aspect ratios for Gemini 2.5 Flash Image */
export type AspectRatio =
    | "1:1" | "2:3" | "3:2" | "3:4" | "4:3"
    | "4:5" | "5:4" | "9:16" | "16:9" | "21:9";

/** Result from Gemini image generation */
export interface GeminiImageResult {
    base64Data: string;
    mimeType: string;
}

/** Input image for image-to-image editing */
export interface ImageInput {
    base64Data: string;
    mimeType: string;
}

/** Options for image generation */
export interface GenerateImageOptions {
    prompt: string;
    sampleCount?: number;
    inputImage?: ImageInput;
    aspectRatio?: AspectRatio;
}

/**
 * Service for generating images using Google Gemini AI (gemini-2.5-flash-image)
 * Supports both text-to-image and image-to-image generation
 */
export class GeminiImageService {
  private readonly model = "gemini-2.5-flash-image";

  /**
       * Generate images using Gemini 2.5 Flash
       * @param {GenerateImageOptions} options - Generation options
       * @return {Promise<GeminiImageResult[]>} Array of generated images
       */
  async generateImages(
    options: GenerateImageOptions
  ): Promise<GeminiImageResult[]> {
    const {prompt, sampleCount = 1, inputImage, aspectRatio} = options;

    const apiKey = geminiApiKey.value();
    if (!apiKey) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Gemini API key not configured"
      );
    }

    const results: GeminiImageResult[] = [];

    try {
      const ai = new GoogleGenAI({apiKey});

      // Generate multiple images (one per request)
      for (let i = 0; i < sampleCount; i++) {
        const result = await this.generateSingleImage(
          ai, prompt, inputImage, aspectRatio
        );
        if (result) {
          results.push(result);
        }
      }

      if (results.length === 0) {
        throw new functions.https.HttpsError(
          "internal",
          "No images generated. Model may have rejected the prompt."
        );
      }

      return results;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (error: any) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Gemini API Error: ${error.message}`
      );
    }
  }

  /**
     * Generate a single image
     * @param {GoogleGenAI} ai - GoogleGenAI instance
     * @param {string} prompt - Text prompt
     * @param {ImageInput} inputImage - Optional input image
     * @param {AspectRatio} aspectRatio - Optional aspect ratio
     * @return {Promise<GeminiImageResult | null>} Generated image or null
     */
  private async generateSingleImage(
    ai: GoogleGenAI,
    prompt: string,
    inputImage?: ImageInput,
    aspectRatio?: AspectRatio
  ): Promise<GeminiImageResult | null> {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const parts: any[] = [];

    // Add input image for image-to-image editing
    if (inputImage) {
      parts.push({
        inlineData: {
          mimeType: inputImage.mimeType,
          data: inputImage.base64Data,
        },
      });
    }

    parts.push({text: prompt});

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const config: any = {
      responseModalities: [Modality.TEXT, Modality.IMAGE],
    };

    if (aspectRatio) {
      config.imageConfig = {aspectRatio};
    }

    const response = await ai.models.generateContent({
      model: this.model,
      contents: [{role: "user", parts}],
      config,
    });

    // Extract image from response
    if (response.candidates && response.candidates.length > 0) {
      const candidate = response.candidates[0];
      if (candidate.content && candidate.content.parts) {
        for (const part of candidate.content.parts) {
          if (part.inlineData) {
            return {
              base64Data: part.inlineData.data || "",
              mimeType: part.inlineData.mimeType || "image/png",
            };
          }
        }
      }
    }

    return null;
  }

  /**
       * Download image from URL and convert to base64
       * @param {string} imageUrl - URL of the image
       * @return {Promise<ImageInput>} Image as base64
       */
  async downloadImageAsBase64(imageUrl: string): Promise<ImageInput> {
    try {
      const response = await axios.get(imageUrl, {
        responseType: "arraybuffer",
        timeout: 30000,
      });

      return {
        base64Data: Buffer.from(response.data).toString("base64"),
        mimeType: response.headers["content-type"] || "image/jpeg",
      };
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } catch (error: any) {
      throw new functions.https.HttpsError(
        "internal",
        `Failed to download image: ${error.message}`
      );
    }
  }
}
