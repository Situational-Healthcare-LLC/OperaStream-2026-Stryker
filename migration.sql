/*
  # OperaStream Platform Database Setup

  Run this in your Supabase SQL Editor to set up all required tables.

  DIRECT LINK: https://supabase.com/dashboard/project/vfsuqgusrawzqilgaayq/sql/new

  Instructions:
  1. Click the link above (or copy-paste into your browser)
  2. Copy this ENTIRE file
  3. Paste into the SQL Editor
  4. Click RUN (or press Ctrl+Enter)
  5. Wait for "Success" message
*/

-- ==============================================
-- PATIENTS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS patients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  medical_record_number text UNIQUE NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  date_of_birth date NOT NULL,
  age integer,
  gender text,
  photo_url text,
  room_number text,
  status text DEFAULT 'stable',
  diagnosis text,
  priority text DEFAULT 'medium',
  allergies jsonb DEFAULT '[]'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_patients_mrn ON patients(medical_record_number);
CREATE INDEX IF NOT EXISTS idx_patients_room ON patients(room_number);

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view patients"
  ON patients FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create patients"
  ON patients FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update patients"
  ON patients FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete patients"
  ON patients FOR DELETE TO authenticated USING (true);

-- ==============================================
-- LAB RESULTS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS lab_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  test_name text NOT NULL,
  result_value text NOT NULL,
  normal_range text NOT NULL,
  unit text NOT NULL,
  status text DEFAULT 'normal',
  collected_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lab_results_patient ON lab_results(patient_id);

ALTER TABLE lab_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view lab results"
  ON lab_results FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create lab results"
  ON lab_results FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update lab results"
  ON lab_results FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete lab results"
  ON lab_results FOR DELETE TO authenticated USING (true);

-- ==============================================
-- PACS IMAGES TABLE (no foreign key - accepts local IDs)
-- ==============================================

CREATE TABLE IF NOT EXISTS pacs_images (
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

CREATE INDEX IF NOT EXISTS idx_pacs_images_patient ON pacs_images(patient_id);

ALTER TABLE pacs_images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view PACS images"
  ON pacs_images FOR SELECT USING (true);
CREATE POLICY "Anyone can create PACS images"
  ON pacs_images FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update PACS images"
  ON pacs_images FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Anyone can delete PACS images"
  ON pacs_images FOR DELETE USING (true);

-- ==============================================
-- TEAM MEMBERS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  role text NOT NULL,
  department text NOT NULL,
  email text UNIQUE NOT NULL,
  status text DEFAULT 'online',
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_team_members_email ON team_members(email);

ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view team members"
  ON team_members FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create team members"
  ON team_members FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update team members"
  ON team_members FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete team members"
  ON team_members FOR DELETE TO authenticated USING (true);

-- ==============================================
-- EXTERNAL CONTACTS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS external_contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  organization text NOT NULL,
  category text NOT NULL,
  title text,
  specialty text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_external_contacts_category ON external_contacts(category);

ALTER TABLE external_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view external contacts"
  ON external_contacts FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create external contacts"
  ON external_contacts FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update external contacts"
  ON external_contacts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete external contacts"
  ON external_contacts FOR DELETE TO authenticated USING (true);

-- ==============================================
-- PATIENT NOTES TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS patient_notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  patient_name text NOT NULL,
  note_type text DEFAULT 'dictation',
  note_content text NOT NULL,
  provider_name text NOT NULL,
  provider_specialty text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_patient_notes_patient ON patient_notes(patient_id);

ALTER TABLE patient_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view patient notes"
  ON patient_notes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create patient notes"
  ON patient_notes FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update patient notes"
  ON patient_notes FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete patient notes"
  ON patient_notes FOR DELETE TO authenticated USING (true);

-- ==============================================
-- PRESENTATIONS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS presentations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  presenter_name text,
  presentation_date timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE presentations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view presentations"
  ON presentations FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create presentations"
  ON presentations FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update presentations"
  ON presentations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete presentations"
  ON presentations FOR DELETE TO authenticated USING (true);

-- ==============================================
-- PRESENTATION ASSETS TABLE
-- ==============================================

CREATE TABLE IF NOT EXISTS presentation_assets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  presentation_id uuid NOT NULL REFERENCES presentations(id) ON DELETE CASCADE,
  asset_type text NOT NULL CHECK (asset_type IN ('image', 'video', 'pacs', 'document')),
  file_name text NOT NULL,
  file_size bigint NOT NULL,
  mime_type text NOT NULL,
  storage_path text NOT NULL,
  public_url text NOT NULL,
  thumbnail_url text,
  duration integer,
  order_index integer DEFAULT 0,
  metadata jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_presentation_assets_presentation ON presentation_assets(presentation_id);
CREATE INDEX IF NOT EXISTS idx_presentation_assets_order ON presentation_assets(presentation_id, order_index);

ALTER TABLE presentation_assets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view presentation assets"
  ON presentation_assets FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create presentation assets"
  ON presentation_assets FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update presentation assets"
  ON presentation_assets FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete presentation assets"
  ON presentation_assets FOR DELETE TO authenticated USING (true);

-- ==============================================
-- TRIGGERS FOR UPDATED_AT
-- ==============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_notes_updated_at
  BEFORE UPDATE ON patient_notes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_presentations_updated_at
  BEFORE UPDATE ON presentations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_presentation_assets_updated_at
  BEFORE UPDATE ON presentation_assets
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================
-- PATIENT PHOTOS TABLE (no foreign key - accepts local IDs)
-- ==============================================

CREATE TABLE IF NOT EXISTS patient_photos (
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

CREATE INDEX IF NOT EXISTS idx_patient_photos_patient ON patient_photos(patient_id);

ALTER TABLE patient_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view patient photos"
  ON patient_photos FOR SELECT USING (true);
CREATE POLICY "Anyone can create patient photos"
  ON patient_photos FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update patient photos"
  ON patient_photos FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Anyone can delete patient photos"
  ON patient_photos FOR DELETE USING (true);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_patient_photos_updated_at') THEN
    CREATE TRIGGER update_patient_photos_updated_at
      BEFORE UPDATE ON patient_photos
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

-- ==============================================
-- STORAGE BUCKETS SETUP
-- ==============================================
-- Note: Storage buckets must be created manually in Supabase Dashboard
-- Go to Storage → Create new bucket
--
-- Required buckets:
-- 1. "patient-photos" - For patient profile photos
-- 2. "pacs-images" - For radiology/PACS images
-- 3. "educational-videos" - For educational content
--
-- Make all buckets PUBLIC so images can be displayed
-- ==============================================
