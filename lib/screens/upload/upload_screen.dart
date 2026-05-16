import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../models/post_model.dart';
import '../../supabase/supabase_client.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _captionCtrl = TextEditingController();
  XFile? _mediaFile;
  bool _isVideo = false;
  bool _loading = false;

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, {bool video = false}) async {
    final picker = ImagePicker();
    final file = video ? await picker.pickVideo(source: source) : await picker.pickImage(source: source);
    if (file != null) setState(() { _mediaFile = file; _isVideo = video; });
  }

  Future<void> _post() async {
    if (_mediaFile == null && _captionCtrl.text.isEmpty) return;
    setState(() => _loading = true);

    try {
      String? mediaUrl;

      if (_mediaFile != null) {
        final ext = _mediaFile!.path.split('.').last;
        final fileName = '${const Uuid().v4()}.$ext';
        final bucket = _isVideo ? 'videos' : 'images';
        final bytes = await File(_mediaFile!.path).readAsBytes();

        await supabase.storage.from(bucket).uploadBinary(fileName, bytes, fileOptions: FileOptions(contentType: _isVideo ? 'video/$ext' : 'image/$ext'));
        mediaUrl = supabase.storage.from(bucket).getPublicUrl(fileName);
      }

      final user = context.read<AuthProvider>().currentUser;
      if (user == null) return;

      await context.read<FeedProvider>().createPost(
            creatorId: user.id,
            caption: _captionCtrl.text.trim().isEmpty ? null : _captionCtrl.text.trim(),
            mediaUrl: mediaUrl,
            type: _isVideo ? PostType.video : (_mediaFile != null ? PostType.image : PostType.text),
          );

      if (mounted) {
        context.go('/feed');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post published!'), backgroundColor: AppColors.primaryLight));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: Text(l10n.uploadPost),
        actions: [
          TextButton(
            onPressed: _loading ? null : _post,
            child: Text(l10n.post, style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showMediaPicker(context, l10n),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: _mediaFile == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, size: 52, color: AppColors.textSecondary),
                            const SizedBox(height: 12),
                            Text(l10n.chooseFromGallery, style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16)),
                            child: Center(child: Icon(_isVideo ? Icons.video_file_outlined : Icons.image_outlined, size: 52, color: AppColors.primaryLight)),
                          ),
                          Positioned(
                            top: 8, right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _mediaFile = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionCtrl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: l10n.addCaption, alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),
            if (_loading) const Center(child: CircularProgressIndicator(color: AppColors.primaryLight)),
          ],
        ),
      ),
    );
  }

  void _showMediaPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(margin: const EdgeInsets.symmetric(vertical: 8), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            ListTile(leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryLight), title: Text(l10n.chooseFromGallery, style: const TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); _pickMedia(ImageSource.gallery); }),
            ListTile(leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryLight), title: Text(l10n.takePhoto, style: const TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); _pickMedia(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.videocam_outlined, color: AppColors.primaryLight), title: Text(l10n.recordVideo, style: const TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); _pickMedia(ImageSource.camera, video: true); }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
