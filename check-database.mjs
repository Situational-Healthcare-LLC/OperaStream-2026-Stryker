import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Supabase credentials not found in .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function checkDatabase() {
  console.log('🔍 Checking Supabase Database Setup...\n');
  console.log(`📍 Supabase URL: ${supabaseUrl}\n`);

  const tables = [
    'patients',
    'patient_photos',
    'pacs_images',
    'educational_videos',
    'lab_results',
    'team_members'
  ];

  const results = {};

  for (const table of tables) {
    try {
      const { data, error } = await supabase
        .from(table)
        .select('id', { count: 'exact', head: true })
        .limit(1);

      if (error) {
        if (error.code === '42P01' || error.message.includes('does not exist')) {
          results[table] = { exists: false, error: 'Table does not exist' };
        } else {
          results[table] = { exists: false, error: error.message };
        }
      } else {
        const { count } = await supabase.from(table).select('*', { count: 'exact', head: true });
        results[table] = { exists: true, count: count || 0 };
      }
    } catch (err) {
      results[table] = { exists: false, error: err.message };
    }
  }

  console.log('📊 Table Status:\n');
  for (const [table, status] of Object.entries(results)) {
    if (status.exists) {
      console.log(`✅ ${table.padEnd(25)} - EXISTS (${status.count} rows)`);
    } else {
      console.log(`❌ ${table.padEnd(25)} - MISSING`);
    }
  }

  console.log('\n📦 Checking Storage Buckets...\n');

  try {
    const { data: buckets, error } = await supabase.storage.listBuckets();

    if (error) {
      console.log('❌ Could not list storage buckets:', error.message);
    } else {
      const bucketNames = buckets.map(b => b.name);
      const requiredBuckets = ['educational-videos', 'patient-photos', 'pacs-images'];

      for (const bucket of requiredBuckets) {
        if (bucketNames.includes(bucket)) {
          console.log(`✅ ${bucket.padEnd(25)} - EXISTS`);
        } else {
          console.log(`❌ ${bucket.padEnd(25)} - MISSING`);
        }
      }
    }
  } catch (err) {
    console.log('❌ Storage check failed:', err.message);
  }

  console.log('\n' + '='.repeat(60));
  console.log('Summary:');
  const missingTables = Object.entries(results).filter(([_, v]) => !v.exists).map(([k]) => k);

  if (missingTables.length === 0) {
    console.log('✅ All required tables exist!');
  } else {
    console.log(`❌ Missing ${missingTables.length} table(s): ${missingTables.join(', ')}`);
  }
}

checkDatabase().catch(console.error);
