# How to Upload Images, Photos, and Patients

## Setup First (One-Time)

Before you can upload to Supabase cloud storage:

1. **Run the database migration:**
   - Open: https://supabase.com/dashboard/project/vfsuqgusrawzqilgaayq/sql/new
   - Copy all of `migration.sql`
   - Paste and click **RUN**

2. **Create storage buckets:**
   - Go to Storage in Supabase Dashboard
   - Create 3 PUBLIC buckets:
     - `patient-photos`
     - `pacs-images`
     - `educational-videos`

3. **Refresh the app**

See `SUPABASE_STORAGE_SETUP.md` for detailed instructions.

---

## Upload Patient Photos

**Where:** Administration → Patient Photos tab

**Steps:**
1. Find the patient in the grid
2. Click **Upload** button
3. Select a photo (JPG, PNG, etc.)
4. Photo uploads to Supabase `patient-photos` bucket
5. Photo appears on all patient cards, tiles, and lists

**Storage:**
- Files stored in Supabase bucket: `patient-photos/{patientId}/`
- Database record in: `patient_photos` table
- Falls back to browser localStorage if Supabase not configured

---

## Upload PACS Images

**Where:** Administration → PACS Images tab

**Steps:**
1. Select **Patient** from dropdown
2. Select **Modality** (X-Ray, CT, MRI, or Ultrasound)
3. Enter **Description** (required)
4. Click **Select Image to Upload**
5. Choose medical image file
6. Image uploads to Supabase `pacs-images` bucket
7. View in PACS Viewer module

**Storage:**
- Files stored in Supabase bucket: `pacs-images/pacs/{patientId}/`
- Database record in: `pacs_images` table
- Falls back to browser localStorage if Supabase not configured

---

## Add New Patients

**Where:** Home page → **Manage Patients** button (next to "Select Workflow")

**Steps:**
1. Click **Manage Patients** dropdown
2. Click **Add Patient**
3. Fill in required fields:
   - First Name *
   - Last Name *
   - Medical Record Number (MRN) *
   - Date of Birth *
4. Optional fields:
   - Gender
   - Room Number
   - Diagnosis
   - Priority level
   - Allergies (comma-separated)
5. Click **Add Patient**
6. Patient immediately appears in all patient lists

**Storage:**
- Stored in Supabase table: `patients`
- Requires database to be configured (no localStorage fallback)

---

## Remove Patients

**Where:** Home page → **Manage Patients** button → **Remove Patient**

**Steps:**
1. Click **Manage Patients** dropdown
2. Click **Remove Patient**
3. Click on patient to select
4. Click **Remove Patient** button
5. Confirm deletion
6. Patient and all associated data is deleted

**Warning:** This permanently deletes the patient record, photos, PACS images, lab results, and notes.

---

## Upload Educational Videos

**Where:** Administration → Educational Videos tab

**Steps:**
1. Enter **Video Title**
2. Enter **Description**
3. Click **Select Video to Upload**
4. Choose video file (max 50MB)
5. Video uploads to Supabase
6. Use in Educational Sessions

---

## Check What's Stored Where

### In Supabase Database:
- Patient records
- Photo/image metadata
- Lab results
- Notes
- Team members

### In Supabase Storage Buckets:
- Actual photo files
- Actual PACS image files
- Actual video files

### In Browser localStorage (fallback):
- Everything if Supabase not configured
- Temporary until you set up Supabase

---

## Troubleshooting

### "Database not configured" error
- Run migration.sql in Supabase SQL Editor
- Check `.env` file has correct Supabase credentials

### "Storage bucket not found" error
- Create the required buckets in Supabase Storage
- Make sure they are set to PUBLIC

### Images not appearing
- Refresh the page
- Check browser console for errors
- Verify buckets exist and are public

### Can't add patients
- Database must be configured (no localStorage fallback)
- Run migration.sql first
