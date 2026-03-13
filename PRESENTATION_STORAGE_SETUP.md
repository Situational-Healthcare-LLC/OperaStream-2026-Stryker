# Presentation Storage Setup Guide

This guide will help you set up cloud storage for your presentations with plenty of space for images, videos, and PACS images.

## Storage Capacity

**Supabase Storage Limits:**
- Free Tier: 1 GB total storage
- Pro Plan ($25/month): 100 GB storage
- Team Plan: Custom storage limits

**File Size Limits (per file):**
- Images: 50 MB
- Videos: 500 MB
- PACS Images: 100 MB
- Documents: 50 MB

This is much better than browser local storage which is limited to ~5-10MB total!

## Setup Instructions

### Step 1: Run the Database Migration

1. Go to your Supabase Dashboard:
   https://vfsuqgusrawzqilgaayq.supabase.co

2. Click on "SQL Editor" in the left sidebar

3. Open the migration file: `supabase_migrations/create_presentation_storage.sql`

4. Copy all the contents and paste into the SQL Editor

5. Click "Run" to execute the migration

6. You should see a success message

### Step 2: Create Storage Buckets

Go to **Storage** in the Supabase Dashboard and create these 4 buckets:

#### Bucket 1: presentation-images
- Name: `presentation-images`
- Public bucket: ✅ Yes
- File size limit: 50 MB
- Allowed MIME types: `image/jpeg, image/png, image/gif, image/webp, image/svg+xml`

#### Bucket 2: presentation-videos
- Name: `presentation-videos`
- Public bucket: ✅ Yes
- File size limit: 500 MB
- Allowed MIME types: `video/mp4, video/webm, video/quicktime, video/x-msvideo`

#### Bucket 3: presentation-pacs
- Name: `presentation-pacs`
- Public bucket: ✅ Yes
- File size limit: 100 MB
- Allowed MIME types: `image/jpeg, image/png, application/dicom`

#### Bucket 4: presentation-documents
- Name: `presentation-documents`
- Public bucket: ✅ Yes
- File size limit: 50 MB
- Allowed MIME types: `application/pdf, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.ms-powerpoint`

### Step 3: Verify Setup

1. Restart your application
2. Look for these console messages:
   - `[PresentationStorage] ✓ Presentation created: [title]`
   - `[PresentationStorage] ✓ image uploaded: [filename]`

## Usage

### Creating a Presentation

```typescript
import { presentationStorage } from './services/presentationStorage';

const presentation = await presentationStorage.createPresentation({
  title: 'Cardiac Surgery Techniques',
  description: 'Advanced surgical procedures',
  presenter_name: 'Dr. Smith',
  presentation_date: '2026-03-15T14:00:00'
});
```

### Uploading Assets

```typescript
// Upload an image
const imageAsset = await presentationStorage.uploadAsset(
  presentationId,
  imageFile,
  'image',
  0  // order index
);

// Upload a video
const videoAsset = await presentationStorage.uploadAsset(
  presentationId,
  videoFile,
  'video',
  1
);

// Upload PACS images
const pacsAsset = await presentationStorage.uploadAsset(
  presentationId,
  pacsFile,
  'pacs',
  2
);
```

### Getting Assets

```typescript
const assets = await presentationStorage.getPresentationAssets(presentationId);
```

### Storage Statistics

```typescript
const stats = await presentationStorage.getStorageStats();
console.log(`Total: ${stats.totalAssets} files, ${stats.totalSize} bytes`);
```

## Upgrading Storage

If you need more storage:

1. Go to Supabase Dashboard > Settings > Billing
2. Upgrade to Pro Plan ($25/month) for 100GB
3. Or contact Supabase for custom enterprise plans

## Best Practices

1. **Compress images** before uploading to save space
2. **Use appropriate formats:**
   - Images: WebP or JPEG (avoid PNG for photos)
   - Videos: MP4 with H.264 codec
   - PACS: Original format or JPEG for previews
3. **Delete old presentations** to free up space
4. **Monitor usage** with the storage stats dashboard

## Troubleshooting

### "Storage bucket not found"
Make sure you created all 4 buckets in Supabase Storage

### "File too large"
Check the file size limits for each bucket type

### "Upload failed"
- Check your internet connection
- Verify Supabase credentials in .env file
- Check Supabase Dashboard for storage quota

## Security Notes

- All buckets are PUBLIC for easy access during presentations
- RLS policies ensure only authenticated users can upload/delete
- Files are served directly from Supabase CDN
- URLs are permanent and don't expire
