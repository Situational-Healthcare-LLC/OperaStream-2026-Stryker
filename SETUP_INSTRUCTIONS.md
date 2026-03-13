# OperaStream Database Setup Instructions

## ⚡ Quick Method - Use This Link

**Click here to open SQL Editor directly:**
👉 https://supabase.com/dashboard/project/vfsuqgusrawzqilgaayq/sql/new

Then:
1. You'll see a blank SQL editor
2. Open `migration.sql` from this project
3. Copy ALL the content (Ctrl+A, Ctrl+C)
4. Paste into the editor (Ctrl+V)
5. Click **RUN** (or Ctrl+Enter)
6. Wait for "Success" message

---

## Alternative: Manual Dashboard Access

If the direct link doesn't work:

1. Go to: https://supabase.com/dashboard
2. Sign in to your account
3. Find and click your project: **vfsuqgusrawzqilgaayq**
4. Click **SQL Editor** in the left sidebar
5. Click **New Query** button
6. Open the `migration.sql` file in this project
7. Copy all the SQL code and paste it into the editor
8. Click **Run** (or press Cmd/Ctrl + Enter)

You should see a success message. This creates all required tables with proper security policies.

## Step 2: Create Storage Buckets

For the presentation manager feature, you need to create storage buckets:

1. In your Supabase Dashboard, go to **Storage** in the left sidebar
2. Click **Create Bucket** and create the following buckets (all should be **Public**):

   - **Name:** `presentation-images`
     - Public: ✅ Yes
     - File size limit: 50MB

   - **Name:** `presentation-videos`
     - Public: ✅ Yes
     - File size limit: 500MB

   - **Name:** `presentation-pacs`
     - Public: ✅ Yes
     - File size limit: 100MB

   - **Name:** `presentation-documents`
     - Public: ✅ Yes
     - File size limit: 50MB

## Step 2: Seed the Database with Sample Data

After creating the tables, run this command to add sample data:

```bash
node scripts/direct-seed.mjs
```

This will populate your database with:
- 10 sample patients with medical records
- Lab results for each patient
- PACS images for select patients
- 5 healthcare team members
- 4 external contacts

You should see:
```
✅ Added 10 patients
✅ Added 5 team members
✅ Added 4 contacts
✨ Database seeding complete!
```

## Verify Everything Works

1. Check that tables were created:
   - Go to **Table Editor** in Supabase Dashboard
   - You should see: patients, lab_results, pacs_images, team_members, external_contacts, patient_notes, presentations, presentation_assets

2. Check that storage buckets were created:
   - Go to **Storage** in Supabase Dashboard
   - You should see all 4 presentation buckets

3. Start your development server and test the application

## Troubleshooting

**If the migration fails:**
- Make sure you're connected to the correct Supabase project
- Check that your .env file has the correct credentials
- Try running the SQL in smaller chunks if there are any errors

**If seeding fails:**
- Make sure the migration ran successfully first
- Check your .env file has correct Supabase credentials
- Look at the console output for specific error messages

**If storage uploads fail:**
- Verify all 4 storage buckets are created and set to Public
- Check the bucket names match exactly (case-sensitive)
- Ensure the file size limits are set appropriately
