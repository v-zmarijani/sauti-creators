import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: _isOwnProfile ? null : IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(_isOwnProfile ? (user?.username ?? '') : 'Profile'),
        actions: _isOwnProfile
            ? [
                IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push('/settings')),
                IconButton(icon: const Icon(Icons.bar_chart_outlined), onPressed: () => context.push('/earnings')),
              ]
            : null,
      ),
      body: user == null
          ? const SizedBox.shrink()
          : NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CreatorAvatar(avatarUrl: user.avatarUrl, name: user.name, radius: 48),
                      const SizedBox(height: 12),
                      Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('@${user.username}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      if (user.bio != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(user.bio!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.onSurface, fontSize: 14)),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _Stat(label: l10n.posts, value: user.postsCount),
                          _Divider(),
                          _Stat(label: l10n.followers, value: user.followersCount),
                          _Divider(),
                          _Stat(label: l10n.following, value: user.followingCount),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _isOwnProfile
                            ? OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                                child: Text(l10n.editProfile),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => setState(() => _isFollowing = !_isFollowing),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isFollowing ? AppColors.surfaceVariant : AppColors.primaryLight,
                                        minimumSize: const Size(0, 44),
                                      ),
                                      child: Text(_isFollowing ? l10n.unfollow : l10n.follow),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                                      child: Text(l10n.tipCreator),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 16),
                      if (_isOwnProfile)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/live/my_channel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.live,
                              minimumSize: const Size(double.infinity, 44),
                            ),
                            icon: const Icon(Icons.live_tv, size: 18),
                            label: Text(l10n.goLive),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabDelegate(TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primaryLight,
                    labelColor: AppColors.primaryLight,
                    unselectedLabelColor: AppColors.textSecondary,
                    tabs: const [Tab(icon: Icon(Icons.grid_on)), Tab(icon: Icon(Icons.video_collection_outlined))],
                  )),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _PostGrid(postCount: user.postsCount),
                  _PostGrid(postCount: user.postsCount ~/ 2),
                ],
              ),
            ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(_format(value), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      );

  String _format(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.divider);
}

class _PostGrid extends StatelessWidget {
  final int postCount;
  const _PostGrid({required this.postCount});

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: postCount,
        itemBuilder: (_, i) => Container(
          color: AppColors.surfaceVariant,
          child: Center(child: Icon(i % 3 == 0 ? Icons.play_circle_outline : Icons.image_outlined, color: AppColors.textSecondary, size: 28)),
        ),
      );
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabDelegate(this.tabBar);

  @override
  Widget build(_, __, ___) => Container(color: AppColors.background, child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_) => false;
}
