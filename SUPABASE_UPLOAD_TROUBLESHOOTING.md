# Supabase Upload Troubleshooting Guide

## Current Status
The upload feature has been implemented with comprehensive logging to identify issues. When you press the "Upload Images to Cloud" button, detailed logs will appear in the console.

## What to Check in the Logs

### 1. Initial Upload Trigger
```
🚀 Starting upload of X images...
bloc called
📤 Uploading images: 0/X
```

### 2. Repository Layer
```
📦 Repository: Calling remote data source...
```

### 3. Supabase Storage Service
```
🔧 SupabaseStorageService: Starting upload of X files
🔧 Bucket name: freight_images
🔧 Base path: freights/freight_XXXXX
🔧 Supabase client initialized: true
🔧 Testing bucket access...
```

### 4. Expected Success Flow
```
✅ Bucket access successful
🔧 Uploading file 0: freights/freight_XXXXX/image_XXXXX_0.jpg
🔧 File exists: true
🔧 File size: XXXXX bytes
🔧 Calling Supabase upload...
🔧 Upload successful, getting public URL...
🔧 Public URL: https://sumvtkgiynyhpjkcsrfd.supabase.co/storage/v1/object/public/freight_images/...
✅ All uploads completed. Total URLs: X
📦 Repository: Upload successful, got X URLs
✅ Upload successful! X images uploaded
📸 Image 1: https://...
```

## Common Issues and Solutions

### Issue 1: Bucket Access Failed
**Log Pattern:**
```
❌ Bucket access failed: ...
❌ This likely means the bucket "freight_images" does not exist or you don't have permission
```

**Solution:**
1. Go to your Supabase Dashboard: https://app.supabase.com
2. Navigate to Storage section
3. Create a new bucket named `freight_images`
4. Set bucket permissions:
   - **Public bucket**: Enable if you want public URLs
   - **File size limit**: Set to at least 5MB
   - **Allowed MIME types**: image/jpeg, image/png, image/jpg

### Issue 2: Upload Permission Denied
**Log Pattern:**
```
❌ Upload error for file 0: StorageException: ...permission denied...
```

**Solution:**
1. Go to Supabase Dashboard → Storage → freight_images
2. Click on "Policies" tab
3. Add a new policy for INSERT:
   ```sql
   -- Allow authenticated users to upload
   CREATE POLICY "Allow authenticated uploads"
   ON storage.objects FOR INSERT
   TO authenticated
   WITH CHECK (bucket_id = 'freight_images');
   ```
4. Or for testing, you can allow public uploads:
   ```sql
   -- Allow anyone to upload (NOT RECOMMENDED FOR PRODUCTION)
   CREATE POLICY "Allow public uploads"
   ON storage.objects FOR INSERT
   TO public
   WITH CHECK (bucket_id = 'freight_images');
   ```

### Issue 3: Invalid Credentials
**Log Pattern:**
```
❌ Bucket access failed: Invalid API key...
```

**Solution:**
1. Verify your Supabase credentials in `lib/core/storage/supabase_config.dart`
2. Get correct credentials from Supabase Dashboard → Settings → API
3. Update:
   - `supabaseUrl`: Your project URL
   - `supabaseAnonKey`: Your anon/public key
   - `storageBucket`: Should be `freight_images`

### Issue 4: File Too Large
**Log Pattern:**
```
❌ Upload error: File size exceeds limit...
```

**Solution:**
1. Check Supabase bucket settings for file size limit
2. Increase the limit in Supabase Dashboard
3. The app already validates files to be under 5MB before upload

### Issue 5: Network/Connection Issues
**Log Pattern:**
```
❌ Upload error: SocketException...
❌ Upload error: TimeoutException...
```

**Solution:**
1. Check your internet connection
2. Verify Supabase project is not paused (free tier projects pause after inactivity)
3. Check if you can access the Supabase URL in a browser

## Testing Steps

1. **Run the app** with detailed logging enabled
2. **Navigate** to Post Freight Page
3. **Select images** using the image picker (max 5 images, each under 5MB)
4. **Press** "Upload Images to Cloud" button
5. **Check console logs** for detailed information
6. **Look for**:
   - Bucket access confirmation
   - File upload progress
   - Public URLs being generated
   - Success message with URLs

## Supabase Dashboard Setup Checklist

- [ ] Bucket `freight_images` exists
- [ ] Bucket is set to public (or has appropriate policies)
- [ ] File size limit is at least 5MB
- [ ] Upload policy is configured for authenticated users
- [ ] Read policy is configured (for public URLs)
- [ ] Supabase project is active (not paused)
- [ ] Credentials in `supabase_config.dart` are correct

## Example Bucket Policy (Complete Setup)

```sql
-- Allow authenticated users to upload to their own folder
CREATE POLICY "Allow authenticated uploads"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'freight_images' AND
  (storage.foldername(name))[1] = 'freights'
);

-- Allow public read access
CREATE POLICY "Allow public downloads"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'freight_images');

-- Allow users to delete their own files
CREATE POLICY "Allow authenticated deletes"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'freight_images');
```

## Next Steps After Successful Upload

Once you see the signed URLs in the console:
1. The URLs can be stored in your freight data
2. They can be used to display images in the UI
3. They can be sent to your backend API as part of the freight creation request

## Need More Help?

If you're still experiencing issues:
1. Copy the complete console log output
2. Check the exact error message
3. Verify all checklist items above
4. Ensure your Supabase project is on a paid plan if you need higher limits
