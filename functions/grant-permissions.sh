#!/bin/bash

# Script to grant Vertex AI permissions to Cloud Functions service account

PROJECT_ID="photo-ai-9fafc"
PROJECT_NUMBER="153197667098"

# Default Cloud Functions service account
SERVICE_ACCOUNT="${PROJECT_ID}@appspot.gserviceaccount.com"

echo "Granting Vertex AI User role to: $SERVICE_ACCOUNT"

# Grant Vertex AI User role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/aiplatform.user"

echo "Done! Permissions granted."
echo "Please wait 1-2 minutes for changes to propagate, then try again."
