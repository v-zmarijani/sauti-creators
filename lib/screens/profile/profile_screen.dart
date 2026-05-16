import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/creator_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isOwnProfile => widget.userId == 'me';

  // Demo user for bypass mode
  static final _demoUser = _DemoUser(
    name: 'Amina Kibao',
    username: 'aminakibao',
    bio: 'Content creator from Dar es Salaam 🇹🇿\nBongo Flava | Comedy | Lifestyle',
    followers: 12400,
    following: 890,
    posts: 48,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: context.colors.background,
            elevation: 0,
            pinned: true,
            leading: _isOwnProfile ? null : CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.back, color: AppColors.primary),
              onPressed: () => context.pop(),
            ),
            title: Text(_demoUser.username, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: context.colors.onBackground)),
            actions: _isOwnProfile ? [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Icon(CupertinoIcons.settings, color: AppColors.primary, size: 22),
                onPressed: () => context.push('/settings'),
              ),
            ] : null,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),
                CreatorAvatar(name: _demoUser.name, radius: 46),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_demoUser.name, style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: context.colors.onBackground)),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded, color: AppColors.verified, size: 18),
                ]),
                const SizedBox(height: 4),
                Text('@${_demoUser.username}', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(_demoUser.bio, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.colors.onSurface, height: 1.4)),
                ),
                const SizedBox(height: 20),
                // Stats row
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(label: 'Posts', value: _demoUser.posts),
                      _VertDivider(),
                      _Stat(label: 'Followers', value: _demoUser.followers),
                      _VertDivider(),
                      _Stat(label: 'Following', value: _demoUser.following),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isOwnProfile
                      ? Row(children: [
                          Expanded(child: _IosButton(label: 'Edit Profile', filled: false, onTap: () {})),
                          const SizedBox(width: 10),
                          Expanded(child: _IosButton(label: 'Go Live 🔴', filled: true, color: AppColors.live, onTap: () => context.push('/live/my_channel'))),
                        ])
                      : Row(children: [
                          Expanded(child: _IosButton(label: _isFollowing ? 'Following' : 'Follow', filled: !_isFollowing, onTap: () => setState(() => _isFollowing = !_isFollowing))),
                          const SizedBox(width: 10),
                          Expanded(child: _IosButton(label: 'Tip 💰', filled: false, onTap: () {})),
                        ]),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabDelegate(TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              dividerColor: AppColors.divider,
              tabs: const [Tab(icon: Icon(CupertinoIcons.grid, size: 20)), Tab(icon: Icon(CupertinoIcons.play_rectangle, size: 20))],
            )),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_Grid(count: _demoUser.posts), _Grid(count: _demoUser.posts ~/ 3)],
        ),
      ),
    );
  }
}

class _DemoUser {
  final String name, username, bio;
  final int followers, following, posts;
  const _DemoUser({required this.name, required this.username, required this.bio, required this.followers, required this.following, required this.posts});
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat({required this.label, required this.value});

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(_fmt(value), style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: context.colors.onBackground)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
        ],
      );
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 0.5, height: 36, color: AppColors.divider);
}

class _IosButton extends StatelessWidget {
  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  const _IosButton({required this.label, required this.filled, required this.onTap, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            border: filled ? null : Border.all(color: AppColors.divider, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: filled ? Colors.white : context.colors.onBackground)),
        ),
      );
}

class _Grid extends StatelessWidget {
  final int count;
  const _Grid({required this.count});

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(1),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.5, mainAxisSpacing: 1.5),
        itemCount: count,
        itemBuilder: (_, i) => Container(
          color: context.colors.surfaceVariant,
          child: Center(child: Icon(i % 3 == 0 ? CupertinoIcons.play_fill : CupertinoIcons.photo, color: AppColors.textTertiary, size: 24)),
        ),
      );
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(color: context.colors.background, child: tabBar);
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(_) => false;
}
