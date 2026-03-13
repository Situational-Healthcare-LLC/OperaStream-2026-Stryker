import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_SERVICE_ROLE_KEY
);

console.log('🔄 Toggling all buckets to public...\n');

const { data: buckets, error: listError } = await supabase.storage.listBuckets();

if (listError) {
  console.error('❌ Error fetching buckets:', listError.message);
  process.exit(1);
}

if (buckets.length === 0) {
  console.log('⚠️  No buckets found to toggle!');
  console.log('\nCreate buckets first before toggling them.');
  process.exit(0);
}

console.log(`Found ${buckets.length} bucket(s):\n`);

for (const bucket of buckets) {
  console.log(`📦 ${bucket.name}`);
  console.log(`   Current status: ${bucket.public ? 'Public ✅' : 'Private 🔒'}`);

  if (bucket.public) {
    console.log(`   Already public, skipping...\n`);
    continue;
  }

  const { data, error } = await supabase.storage.updateBucket(bucket.name, {
    public: true
  });

  if (error) {
    console.error(`   ❌ Error toggling ${bucket.name}:`, error.message);
  } else {
    console.log(`   ✅ Successfully made public!\n`);
  }
}

console.log('\n✨ Done! Checking final status...\n');

const { data: finalBuckets, error: finalError } = await supabase.storage.listBuckets();

if (!finalError) {
  finalBuckets.forEach(bucket => {
    console.log(`${bucket.public ? '✅' : '❌'} ${bucket.name} - ${bucket.public ? 'Public' : 'Private'}`);
  });
}
