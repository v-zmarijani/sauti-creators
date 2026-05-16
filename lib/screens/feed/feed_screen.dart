import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/feed_provider.dart';
import '../../models/post_model.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/creator_avatar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SAUTI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 3, color: AppColors.primaryLight)),
        actions: [
          IconButton(icon: const Icon(Icons.live_tv_outlined, color: AppColors.live), onPressed: () => context.push('/live/demo_channel'), tooltip: 'Go Live'),
          IconButton(icon: const Icon(Icons.search_outlined), onPressed: () {}),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => FeedProvider(),
        child: Consumer<FeedProvider>(
          builder: (_, feed, __) {
            if (feed.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primaryLight));
            return RefreshIndicator(
              color: AppColors.primaryLight,
              onRefresh: feed.fetchFeed,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: feed.posts.length,
                itemBuilder: (_, i) => _PostCard(post: feed.posts[i], onLike: () => feed.toggleLike(feed.posts[i].id)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  const _PostCard({required this.post, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.push('/profile/${post.creatorId}'),
                  child: CreatorAvatar(avatarUrl: post.creatorAvatarUrl, name: post.creatorName, radius: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.creatorName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
                      Text('@${post.creatorUsername}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(72, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: const BorderSide(color: AppColors.primaryLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(l10n.follow, style: const TextStyle(color: AppColors.primaryLight, fontSize: 12)),
                ),
              ],
            ),
          ),
          if (post.mediaUrl != null || post.type == PostType.image)
            Container(
              height: 280,
              color: AppColors.surfaceVariant,
              child: Center(
                child: Icon(post.type == PostType.video ? Icons.play_circle_outline : Icons.image_outlined, size: 64, color: AppColors.textSecondary),
              ),
            ),
          if (post.caption != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(post.caption!, style: const TextStyle(fontSize: 14, color: AppColors.onSurface)),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                _ActionBtn(icon: post.isLiked ? Icons.favorite : Icons.favorite_border, color: post.isLiked ? Colors.red : AppColors.textSecondary, label: _formatCount(post.likesCount), onTap: onLike),
                _ActionBtn(icon: Icons.chat_bubble_outline, color: AppColors.textSecondary, label: _formatCount(post.commentsCount), onTap: () {}),
                _ActionBtn(icon: Icons.share_outlined, color: AppColors.textSecondary, label: _formatCount(post.sharesCount), onTap: () {}),
                const Spacer(),
                _ActionBtn(icon: Icons.bookmark_border_outlined, color: AppColors.textSecondary, label: '', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _formatCount(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              if (label.isNotEmpty) ...[const SizedBox(width: 4), Text(label, style: TextStyle(color: color, fontSize: 13))],
            ],
          ),
        ),
      );
}
