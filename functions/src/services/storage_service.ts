import * as admin from "firebase-admin";

/**
 * Service for handling Firebase Storage operations
 */
export class StorageService {
  private bucket = admin.storage().bucket();

  /**
   * Upload generated image to Firebase Storage
   * Path: users/{uid}/generated/{generationId}/{index}.jpg
   * @param {string} uid - User ID
   * @param {string} generationId - Generation ID
   * @param {number} index - Image index
   * @param {string} base64Data - Base64 encoded image data
   * @return {Promise<string>} Public URL of the uploaded image
   */
  async uploadGeneratedImage(
    uid: string,
    generationId: string,
    index: number,
    base64Data: string
  ): Promise<string> {
    const filePath = `users/${uid}/generated/${generationId}/${index}.jpg`;
    const file = this.bucket.file(filePath);
    const buffer = Buffer.from(base64Data, "base64");

    await file.save(buffer, {
      contentType: "image/jpeg",
    });

    await file.makePublic();
    return `https://storage.googleapis.com/${this.bucket.name}/${filePath}`;
  }
}
