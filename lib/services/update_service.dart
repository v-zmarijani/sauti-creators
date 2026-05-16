import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class UpdateService {
  // Update this to your GitHub repo
  static const _owner = 'v-zmarijani';
  static const _repo = 'sauti-creators';
  static const _releasesApi = 'https://api.github.com/repos/$_owner/$_repo/releases/latest';
  static const _releasesPage = 'https://github.com/$_owner/$_repo/releases/latest';

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version; // e.g. "1.0.0"

      final res = await http.get(Uri.parse(_releasesApi), headers: {'Accept': 'application/vnd.github.v3+json'}).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return;

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final latestTag = (body['tag_name'] as String? ?? '').replaceFirst('v', '');
      final releaseNotes = body['body'] as String? ?? '';

      if (!context.mounted) return;
      if (_isNewer(latestTag, currentVersion)) {
        _showUpdateDialog(context, latestTag, releaseNotes);
      }
    } catch (_) {
      // Fail silently — update check should never crash the app
    }
  }

  static bool _isNewer(String latest, String current) {
    if (latest.isEmpty || current.isEmpty) return false;
    try {
      final l = latest.split('.').map(int.parse).toList();
      final c = current.split('.').map(int.parse).toList();
      for (var i = 0; i < l.length; i++) {
        if (i >= c.length || l[i] > c[i]) return true;
        if (l[i] < c[i]) return false;
      }
    } catch (_) {}
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String version, String notes) {
    final colors = context.colors;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.system_update_rounded, color: colors.primary, size: 24),
          const SizedBox(width: 10),
          Text('Update Available', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: colors.onBackground)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sauti v$version is ready to install.', style: GoogleFonts.dmSans(color: colors.onSurface, fontSize: 14)),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                child: Text(notes.length > 200 ? '${notes.substring(0, 200)}…' : notes, style: GoogleFonts.dmSans(fontSize: 12, color: colors.textSecondary)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later', style: GoogleFonts.dmSans(color: colors.textSecondary, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary, minimumSize: const Size(100, 40)),
            onPressed: () async {
              Navigator.pop(context);
              await launchUrl(Uri.parse(_releasesPage), mode: LaunchMode.externalApplication);
            },
            child: Text('Download', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
