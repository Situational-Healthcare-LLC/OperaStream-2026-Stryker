/*
  # Fix Image Tables for Local Patient IDs

  Run this in your Supabase SQL Editor to fix image storage.
  This removes foreign key constraints so images work with local patient IDs.

  DIRECT LINK: https://supabase.com/dashboard/project/_/sql/new
*/

-- Drop existing tables (they have wrong constraints)
DROP TABLE IF EXISTS patient_photos CASCADE;
DROP TABLE IF EXISTS pacs_images CASCADE;

-- Recreate patient_photos with text patient_id and large public_url for base64
CREATE TABLE patient_photos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id text UNIQUE NOT NULL,
  storage_path text NOT NULL,
  public_url text NOT NULL,
  file_name text NOT NULL DEFAULT 'photo.jpg',
  file_size bigint NOT NULL DEFAULT 0,
  mime_type text NOT NULL DEFAULT 'image/jpeg',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX idx_patient_photos_patient ON patient_photos(patient_id);
ALTER TABLE patient_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view patient photos"
  ON patient_photos FOR SELECT USING (true);
CREATE POLICY "Anyone can create patient photos"
  ON patient_photos FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update patient photos"
  ON patient_photos FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Anyone can delete patient photos"
  ON patient_photos FOR DELETE USING (true);

-- Recreate pacs_images with text patient_id
CREATE TABLE pacs_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id text NOT NULL,
  modality text NOT NULL,
  study_description text NOT NULL,
  body_part text DEFAULT '',
  image_url text NOT NULL,
  radiologist_notes text,
  study_date timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_pacs_images_patient ON pacs_images(patient_id);
ALTER TABLE pacs_images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view PACS images"
  ON pacs_images FOR SELECT USING (true);
CREATE POLICY "Anyone can create PACS images"
  ON pacs_images FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update PACS images"
  ON pacs_images FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Anyone can delete PACS images"
  ON pacs_images FOR DELETE USING (true);

-- Verify tables were created
SELECT 'Tables created successfully!' as status;
