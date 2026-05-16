import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../supabase/supabase_client.dart';

class FeedProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FeedProvider() {
    fetchFeed();
  }

  Future<void> fetchFeed() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser?.id;

      final data = await supabase
          .from('posts')
          .select('''
            id, caption, media_url, type, likes_count, comments_count, shares_count, created_at,
            users!creator_id (id, name, username, avatar_url)
          ''')
          .order('created_at', ascending: false)
          .limit(30);

      final likedPostIds = <String>{};
      if (userId != null) {
        final likes = await supabase
            .from('post_likes')
            .select('post_id')
            .eq('user_id', userId);
        likedPostIds.addAll((likes as List).map((l) => l['post_id'] as String));
      }

      _posts = (data as List).map((row) {
        final creator = row['users'] as Map<String, dynamic>;
        return PostModel(
          id: row['id'] as String,
          creatorId: creator['id'] as String,
          creatorName: creator['name'] as String,
          creatorUsername: creator['username'] as String,
          creatorAvatarUrl: creator['avatar_url'] as String?,
          caption: row['caption'] as String?,
          mediaUrl: row['media_url'] as String?,
          type: PostType.values.firstWhere((e) => e.name == row['type'], orElse: () => PostType.image),
          likesCount: (row['likes_count'] as int?) ?? 0,
          commentsCount: (row['comments_count'] as int?) ?? 0,
          sharesCount: (row['shares_count'] as int?) ?? 0,
          isLiked: likedPostIds.contains(row['id']),
          createdAt: DateTime.parse(row['created_at'] as String),
        );
      }).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final nowLiked = !post.isLiked;

    // Optimistic update
    _posts[index] = post.copyWith(isLiked: nowLiked, likesCount: post.likesCount + (nowLiked ? 1 : -1));
    notifyListeners();

    try {
      if (nowLiked) {
        await supabase.from('post_likes').insert({'post_id': postId, 'user_id': userId});
        await supabase.from('posts').update({'likes_count': _posts[index].likesCount}).eq('id', postId);
      } else {
        await supabase.from('post_likes').delete().eq('post_id', postId).eq('user_id', userId);
        await supabase.from('posts').update({'likes_count': _posts[index].likesCount}).eq('id', postId);
      }
    } catch (_) {
      // Rollback on failure
      _posts[index] = post;
      notifyListeners();
    }
  }

  Future<void> createPost({required String creatorId, String? caption, String? mediaUrl, required PostType type}) async {
    await supabase.from('posts').insert({
      'creator_id': creatorId,
      'caption': caption,
      'media_url': mediaUrl,
      'type': type.name,
      'likes_count': 0,
      'comments_count': 0,
      'shares_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    await supabase.rpc('increment_posts_count', params: {'user_id': creatorId});
    await fetchFeed();
  }
}
