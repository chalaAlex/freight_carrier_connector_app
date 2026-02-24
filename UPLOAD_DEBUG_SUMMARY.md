# Upload Feature Debug Summary

## What Was Done

### 1. Added Comprehensive Logging
We've added detailed logging throughout the entire upload flow to identify exactly where the error occurs:

- **Error Handler** (`lib/core/error/error_handler.dart`):
  - Now logs error type and details
  - Preserves actual error messages for non-Dio exceptions
  - Previously all non-Dio errors showed generic "something wrong, try again later"

- **Repository Layer** (`lib/feature/freight/data/repositories/upload_repository_impl.dart`):
  - Logs when calling remote data source
  - Logs success with URL count
  - Logs detailed error information with stack trace

- **Storage Service** (`lib/core/storage/supabase_storage_service.dart`):
  - Logs upload initiation with file count, bucket name, and base path
  - Tests bucket access before attempting upload
  - Logs each file's upload progress
  - Logs file existence and size
  - Logs Supabase API calls
  - Logs public URLs generated
  - Logs detailed error information with stack trace

### 2. Added Bucket Access Check
Before attempting to upload files, the service now tests if the bucket exists and is accessible by calling `list()`. This will immediately identify if:
- The bucket doesn't exist
- You don't have permission to access the bucket
- The credentials are incorrect

### 3. Created Troubleshooting Guide
Created `SUPABASE_UPLOAD_TROUBLESHOOTING.md` with:
- Expected log patterns for success and failure
- Common issues and their solutions
- Supabase dashboard setup checklist
- Example bucket policies
- Step-by-step testing instructions

## What You Need to Do Next

### Step 1: Verify Supabase Configuration

Check `lib/core/storage/supabase_config.dart`:
```dart
static const String supabaseUrl = 'https://sumvtkgiynyhpjkcsrfd.supabase.co';
static const String supabaseAnonKey = 'eyJhbGci...'; // Your actual key
static const String storageBucket = 'freight_images';
```

Make sure these credentials are correct from your Supabase Dashboard.

### Step 2: Create the Storage Bucket

1. Go to https://app.supabase.com
2. Select your project
3. Navigate to **Storage** in the left sidebar
4. Click **New bucket**
5. Name it: `freight_images`
6. Set it as **Public bucket** (or configure policies)
7. Set **File size limit** to at least 5MB

### Step 3: Configure Bucket Policies

In the Supabase Dashboard, go to Storage → freight_images → Policies:

**For Testing (Quick Setup):**
```sql
-- Allow anyone to upload (for testing only)
CREATE POLICY "Allow public uploads"
ON storage.objects FOR INSERT
TO public
WITH CHECK (bucket_id = 'freight_images');

-- Allow anyone to read
CREATE POLICY "Allow public reads"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'freight_images');
```

**For Production (Recommended):**
```sql
-- Allow authenticated users to upload
CREATE POLICY "Allow authenticated uploads"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'freight_images');

-- Allow public read access
CREATE POLICY "Allow public reads"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'freight_images');
```

### Step 4: Run the App and Check Logs

1. Run the app: `flutter run`
2. Navigate to Post Freight Page
3. Select 1-5 images (each under 5MB)
4. Press "Upload Images to Cloud"
5. **Watch the console logs carefully**

### Step 5: Interpret the Logs

#### If Bucket Access Fails:
```
❌ Bucket access failed: ...
❌ This likely means the bucket "freight_images" does not exist or you don't have permission
```
→ Go back to Step 2 and create the bucket

#### If Upload Permission Denied:
```
❌ Upload error for file 0: ...permission denied...
```
→ Go back to Step 3 and configure policies

#### If Credentials Invalid:
```
❌ Bucket access failed: Invalid API key...
```
→ Go back to Step 1 and verify credentials

#### If Success:
```
✅ Bucket access successful
🔧 Uploading file 0: ...
🔧 Upload successful, getting public URL...
🔧 Public URL: https://...
✅ All uploads completed. Total URLs: X
✅ Upload successful! X images uploaded
📸 Image 1: https://sumvtkgiynyhpjkcsrfd.supabase.co/storage/v1/object/public/freight_images/...
```
→ Perfect! The upload is working. Copy these URLs - they're the public URLs of your uploaded images.

## Expected Behavior After Fix

Once everything is configured correctly:

1. User selects images from gallery/camera
2. User presses "Upload Images to Cloud"
3. Console shows detailed upload progress
4. Success message appears: "Upload successful! X images uploaded"
5. Console prints all public URLs
6. These URLs can be:
   - Stored in your freight data
   - Sent to your backend API
   - Used to display images in the UI

## Files Modified

1. `lib/core/error/error_handler.dart` - Better error handling
2. `lib/core/storage/supabase_storage_service.dart` - Added logging and bucket check
3. `lib/feature/freight/data/repositories/upload_repository_impl.dart` - Added logging
4. Created `SUPABASE_UPLOAD_TROUBLESHOOTING.md` - Comprehensive guide
5. Created `UPLOAD_DEBUG_SUMMARY.md` - This file

## Common Issues Quick Reference

| Issue | Log Pattern | Solution |
|-------|-------------|----------|
| Bucket doesn't exist | `Bucket access failed` | Create bucket in Supabase Dashboard |
| No upload permission | `permission denied` | Add INSERT policy to bucket |
| Invalid credentials | `Invalid API key` | Update credentials in supabase_config.dart |
| File too large | `File size exceeds limit` | Increase bucket size limit |
| Network issue | `SocketException` | Check internet connection |

## Next Steps After Successful Upload

Once you confirm uploads are working:

1. **Integrate with Freight Creation**: Add the uploaded URLs to your freight creation request
2. **Display Images**: Show uploaded images in the freight list/details
3. **Remove Debug Logs**: Clean up print statements for production
4. **Add Progress Indicator**: Show upload progress in the UI
5. **Handle Errors Gracefully**: Show user-friendly error messages

## Need Help?

If you're still seeing errors after following all steps:
1. Copy the complete console log
2. Check which step in the log flow fails
3. Refer to `SUPABASE_UPLOAD_TROUBLESHOOTING.md` for detailed solutions
4. Verify all Supabase Dashboard settings match the guide
