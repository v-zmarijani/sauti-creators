import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/feed_provider.dart';
import '../../models/post_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/creator_avatar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: ChangeNotifierProvider(
        create: (_) => FeedProvider(),
        child: CustomScrollView(
          slivers: [
            _SautiAppBar(),
            _LiveStrip(),
            Consumer<FeedProvider>(
              builder: (_, feed, __) {
                if (feed.isLoading) {
                  return const SliverFillRemaining(child: Center(child: CupertinoActivityIndicator(radius: 14)));
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _PostCard(post: feed.posts[i], onLike: () => feed.toggleLike(feed.posts[i].id)),
                    childCount: feed.posts.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SautiAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _BlurAppBarDelegate(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: AppColors.surface.withValues(alpha: 0.88),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 10),
              child: Row(
                children: [
                  Text('Sauti', style: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.onBackground, letterSpacing: -0.5)),
                  const Spacer(),
                  _IconBtn(icon: CupertinoIcons.video_camera, onTap: () => context.push('/live/demo_channel'),
                      badge: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.live, shape: BoxShape.circle))),
                  const SizedBox(width: 4),
                  _IconBtn(icon: CupertinoIcons.search, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
        height: MediaQuery.of(context).padding.top + 56,
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Widget? badge;
  const _IconBtn({required this.icon, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: AppColors.onBackground),
            ),
            if (badge != null) Positioned(top: 0, right: 0, child: badge!),
          ],
        ),
      );
}

class _LiveStrip extends StatelessWidget {
  final _creators = const [
    ('Amina', true), ('John', true), ('Fatuma', false), ('Peter', true), ('Sara', false),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('Live Now', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.2)),
          ),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) {
                final (name, isLive) = _creators[i];
                return Column(
                  children: [
                    CreatorAvatar(name: name, radius: 28, isLive: isLive),
                    const SizedBox(height: 6),
                    Text(name, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.onBackground)),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 20),
          ),
        ],
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.push('/profile/${post.creatorId}'),
                  child: CreatorAvatar(avatarUrl: post.creatorAvatarUrl, name: post.creatorName, radius: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(post.creatorName, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.onBackground)),
                    Text('@${post.creatorUsername}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ),
                _FollowChip(),
                const SizedBox(width: 6),
                Icon(CupertinoIcons.ellipsis, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
          if (post.mediaUrl != null || post.type != PostType.text)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.zero),
              child: Container(
                height: 240,
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(post.type == PostType.video ? CupertinoIcons.play_circle : CupertinoIcons.photo, size: 52, color: AppColors.textTertiary),
                ),
              ),
            ),
          if (post.caption != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: Text(post.caption!, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.onSurface, height: 1.4)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
            child: Row(
              children: [
                _ActionBtn(icon: post.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: post.isLiked ? AppColors.error : AppColors.textSecondary, label: _fmt(post.likesCount), onTap: onLike),
                _ActionBtn(icon: CupertinoIcons.chat_bubble, color: AppColors.textSecondary, label: _fmt(post.commentsCount), onTap: () {}),
                _ActionBtn(icon: CupertinoIcons.arrowshape_turn_up_right, color: AppColors.textSecondary, label: _fmt(post.sharesCount), onTap: () {}),
                const Spacer(),
                _ActionBtn(icon: CupertinoIcons.bookmark, color: AppColors.textSecondary, label: '', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _FollowChip extends StatefulWidget {
  @override
  State<_FollowChip> createState() => _FollowChipState();
}

class _FollowChipState extends State<_FollowChip> {
  bool _following = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => setState(() => _following = !_following),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: _following ? AppColors.surfaceVariant : AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(_following ? 'Following' : 'Follow', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: _following ? AppColors.textSecondary : Colors.white)),
        ),
      );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onPressed: onTap,
        minimumSize: Size.zero,
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            if (label.isNotEmpty) ...[const SizedBox(width: 4), Text(label, style: GoogleFonts.dmSans(color: color, fontSize: 13, fontWeight: FontWeight.w500))],
          ],
        ),
      );
}

class _BlurAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  const _BlurAppBarDelegate({required this.child, required this.height});

  @override
  Widget build(_, __, ___) => child;
  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;
  @override
  bool shouldRebuild(_) => false;
}
