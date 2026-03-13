# Supabase Storage Setup Guide

This guide explains how to set up Supabase to store patient photos, PACS images, and other medical data.

## Quick Setup (5 minutes)

### Step 1: Run the Database Migration

1. Open your Supabase Dashboard: https://supabase.com/dashboard/project/vfsuqgusrawzqilgaayq
2. Click **SQL Editor** in the left sidebar
3. Click **New query**
4. Copy the entire contents of `migration.sql` file
5. Paste into the SQL editor
6. Click **RUN** (or press Ctrl+Enter)
7. Wait for "Success. No rows returned" message

### Step 2: Create Storage Buckets

1. In your Supabase Dashboard, click **Storage** in the left sidebar
2. Click **New bucket**
3. Create these 3 buckets (one at a time):

   **Bucket 1: patient-photos**
   - Name: `patient-photos`
   - Public bucket: ✅ YES
   - Click **Create bucket**

   **Bucket 2: pacs-images**
   - Name: `pacs-images`
   - Public bucket: ✅ YES
   - Click **Create bucket**

   **Bucket 3: educational-videos**
   - Name: `educational-videos`
   - Public bucket: ✅ YES
   - Click **Create bucket**

### Step 3: Refresh Your App

1. Refresh your browser
2. You're done! The app will now automatically use Supabase cloud storage

## What Gets Stored Where

### Database Tables (created by migration.sql)
- **patients** - Patient demographics and medical records
- **patient_photos** - Metadata for patient profile photos
- **pacs_images** - Metadata for radiology images (X-Ray, CT, MRI)
- **lab_results** - Laboratory test results
- **team_members** - Clinical staff directory
- **external_contacts** - External healthcare providers
- **patient_notes** - Clinical notes and dictations
- **presentations** - Educational presentation metadata
- **presentation_assets** - Educational content files

### Storage Buckets (created manually)
- **patient-photos/** - Actual patient photo files
- **pacs-images/** - Actual PACS/radiology image files
- **educational-videos/** - Educational video files

## How Uploads Work

### Patient Photos
1. Go to **Administration** → **Patient Photos** tab
2. Click **Upload** next to any patient
3. Select an image file
4. File is uploaded to `patient-photos` bucket
5. Database record created in `patient_photos` table
6. Photo appears everywhere that patient is shown

### PACS Images
1. Go to **Administration** → **PACS Images** tab
2. Select patient, modality (X-Ray/CT/MRI), and description
3. Click **Select Image to Upload**
4. File is uploaded to `pacs-images` bucket
5. Database record created in `pacs_images` table
6. Image appears in PACS Viewer

### New Patients
1. Click **Manage Patients** button on home page (next to "Select Workflow")
2. Click **Add Patient**
3. Fill in required info (name, MRN, date of birth)
4. Patient is saved to `patients` table
5. Patient appears in all patient lists

## Fallback Behavior

If Supabase isn't configured or buckets don't exist:
- ✅ App continues to work
- 📦 Data stored in browser localStorage instead
- ⚠️ Data is NOT shared across devices
- ⚠️ Data may be lost if you clear browser cache

## Troubleshooting

### "Database tables not set up" error
**Fix:** Run the SQL migration (Step 1 above)

### "Storage bucket not found" error
**Fix:** Create the storage buckets (Step 2 above)

### Photos/images not appearing
1. Check browser console for errors
2. Verify buckets are set to **Public**
3. Try uploading again
4. Refresh the page

### Patient creation fails
1. Make sure migration.sql was run successfully
2. Check that your Supabase credentials in `.env` are correct
3. Verify you have internet connection

## Storage Costs

Supabase free tier includes:
- ✅ 500 MB database storage
- ✅ 1 GB file storage
- ✅ 2 GB bandwidth per month

This is plenty for testing and small deployments. For production use with many patients and images, consider upgrading to Supabase Pro.

## Security

All tables use Row Level Security (RLS):
- Only authenticated users can access data
- Users can view/modify all patient records
- Customize RLS policies in Supabase Dashboard if needed

Storage buckets are PUBLIC by default:
- Anyone with the URL can view images
- For HIPAA compliance, consider making buckets private and using signed URLs
- Contact Supabase for enterprise security options
