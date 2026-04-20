const List<String> allowedAttachmentTypes = [
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
];

bool isValidAttachmentType(String? mimeType) {
  if (mimeType == null || mimeType.isEmpty) return false;
  return allowedAttachmentTypes.contains(mimeType);
}
