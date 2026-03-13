# GET YOUR MVP WORKING IN 3 MINUTES

Your database tables already exist! You just need to refresh Supabase's cache and add data.

## Step 1: Refresh Schema Cache (30 seconds)

1. Go to: https://vfsuqgusrawzqilgaayq.supabase.co/project/_/settings/api
2. Scroll to **"PostgREST"** section
3. Click **"Restart Service"** button
4. Wait for the green checkmark (~15 seconds)

## Step 2: Add Sample Data (30 seconds)

After the restart completes, run:

```bash
npm run db:seed
```

This adds 10 patients, lab results, team members, and contacts.

## Step 3: Create Storage Buckets (2 minutes)

For the Presentation Manager feature:

1. Go to: https://vfsuqgusrawzqilgaayq.supabase.co/project/_/storage/buckets
2. Click **"Create new bucket"** (4 times, once for each bucket below)

**Bucket 1:**
- Name: `presentation-images`
- Public: ✅ YES
- Click Create

**Bucket 2:**
- Name: `presentation-videos`
- Public: ✅ YES
- Click Create

**Bucket 3:**
- Name: `presentation-pacs`
- Public: ✅ YES
- Click Create

**Bucket 4:**
- Name: `presentation-documents`
- Public: ✅ YES
- Click Create

## Done!

Your MVP is ready. Start the dev server (it may already be running):

```bash
npm run dev
```

## What You Get

✅ 10 sample patients with medical records
✅ Lab results and vital signs
✅ PACS imaging viewer
✅ Team collaboration tools
✅ External contacts database
✅ Medical education presentation manager
✅ Virtual nursing desktop
✅ AI assistant features

Everything is configured and ready for your presentations!
