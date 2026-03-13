import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

console.log('🔍 Checking Storage Buckets...\n');

const { data: buckets, error } = await supabase.storage.listBuckets();

if (error) {
  console.error('❌ Error fetching buckets:', error.message);
} else {
  console.log(`Found ${buckets.length} bucket(s):\n`);

  if (buckets.length === 0) {
    console.log('⚠️  No buckets found!');
    console.log('\nPlease create these buckets manually:');
    console.log('  • patient-photos (public)');
    console.log('  • pacs-images (public)');
    console.log('  • educational-videos (public)');
    console.log('  • presentation-images (public)');
    console.log('  • presentation-videos (public)');
    console.log('  • presentation-documents (public)');
  } else {
    buckets.forEach(bucket => {
      console.log(`✅ ${bucket.name}`);
      console.log(`   ID: ${bucket.id}`);
      console.log(`   Public: ${bucket.public ? 'Yes' : 'No'}`);
      console.log(`   Created: ${bucket.created_at}`);
      console.log('');
    });

    const required = [
      'patient-photos',
      'pacs-images',
      'educational-videos',
      'presentation-images',
      'presentation-videos',
      'presentation-documents'
    ];

    const missing = required.filter(name =>
      !buckets.find(b => b.name === name)
    );

    if (missing.length > 0) {
      console.log('\n⚠️  Missing buckets:');
      missing.forEach(name => console.log(`   • ${name}`));
    } else {
      console.log('\n✨ All required buckets are present!');
    }
  }
}
