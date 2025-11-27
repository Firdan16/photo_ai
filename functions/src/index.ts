/**
 * Photo AI - Cloud Functions Entry Point
 *
 * This file exports all Cloud Functions for the Photo AI application.
 * Functions are organized in separate modules under ./ai/ directory.
 */

import {setGlobalOptions} from "firebase-functions";

// Export Cloud Functions
export {generateImage} from "./ai/generateImages";

// Global configuration for all functions
// Limit max instances to control costs during traffic spikes
setGlobalOptions({maxInstances: 10});
