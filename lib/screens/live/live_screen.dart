import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class LiveScreen extends StatefulWidget {
  final String channelId;
  const LiveScreen({super.key, required this.channelId});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final _commentCtrl = TextEditingController();
  final List<_LiveComment> _comments = [
    _LiveComment(name: 'Amina', text: 'Karibu sana! 🔥🔥', isGold: false),
    _LiveComment(name: 'John', text: '💰 Tip: Tsh 5,000', isGold: true),
    _LiveComment(name: 'Fatuma', text: 'Unafundisha vizuri sana!', isGold: false),
  ];
  int _viewerCount = 1247;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentCtrl.text.isEmpty) return;
    setState(() {
      _comments.add(_LiveComment(name: 'Me', text: _commentCtrl.text, isGold: false));
      _commentCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
            color: const Color(0xFF0D1B0E),
            child: const Center(child: Icon(Icons.videocam_outlined, size: 80, color: AppColors.primary)),
          ),
          // Top bar
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(6)),
                        child: Row(children: [
                          const Icon(Icons.circle, size: 8, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(l10n.liveNow, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text('$_viewerCount', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => context.pop()),
                    ],
                  ),
                ),
                const Spacer(),
                // Comments list
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _comments.length,
                    itemBuilder: (_, i) {
                      final c = _comments[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: c.isGold ? AppColors.tip.withValues(alpha: 0.2) : Colors.black38,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: '${c.name} ', style: TextStyle(fontWeight: FontWeight.bold, color: c.isGold ? AppColors.tip : AppColors.primary, fontSize: 13)),
                                    TextSpan(text: c.text, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Andika hapa...',
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            suffixIcon: IconButton(icon: const Icon(Icons.send, color: AppColors.primary, size: 20), onPressed: _sendComment),
                          ),
                          onSubmitted: (_) => _sendComment(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _LiveIconBtn(icon: Icons.monetization_on_outlined, color: AppColors.tip, onTap: () => _showTipSheet(context, l10n)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _LiveIconBtn(icon: _isMuted ? Icons.mic_off : Icons.mic_outlined, color: Colors.white, onTap: () => setState(() => _isMuted = !_isMuted)),
                      _LiveIconBtn(icon: _isCameraOff ? Icons.videocam_off_outlined : Icons.videocam_outlined, color: Colors.white, onTap: () => setState(() => _isCameraOff = !_isCameraOff)),
                      _LiveIconBtn(icon: Icons.flip_camera_android_outlined, color: Colors.white, onTap: () {}),
                      _LiveIconBtn(icon: Icons.share_outlined, color: Colors.white, onTap: () {}),
                    ],
                  ),
                ),
                SafeArea(top: false, child: const SizedBox(height: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTipSheet(BuildContext context, AppLocalizations l10n) {
    final amounts = ['1,000', '5,000', '10,000', '20,000', '50,000'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sendTip, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: amounts.map((a) => GestureDetector(
                onTap: () { Navigator.pop(context); setState(() { _comments.add(_LiveComment(name: 'Me', text: '💰 Tip: Tsh $a', isGold: true)); }); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.tip.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.tip.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Tsh $a', style: const TextStyle(color: AppColors.tip, fontWeight: FontWeight.w600)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LiveComment {
  final String name;
  final String text;
  final bool isGold;
  _LiveComment({required this.name, required this.text, required this.isGold});
}

class _LiveIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _LiveIconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
      );
}
