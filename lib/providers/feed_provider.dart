import 'package:flutter/material.dart';
import '../models/post_model.dart';

class FeedProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    fetchFeed();
  }

  Future<void> fetchFeed() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data — replace with Firestore query
    _posts = List.generate(
      10,
      (i) => PostModel(
        id: 'post_$i',
        creatorId: 'user_$i',
        creatorName: ['Amina Kibao', 'John Mwita', 'Fatuma Said', 'Peter Njoroge'][i % 4],
        creatorUsername: ['aminakibao', 'johnmwita', 'fatumasaid', 'peternjoroge'][i % 4],
        creatorAvatarUrl: null,
        caption: [
          'Habari za leo! New tutorial imetoka 🎬 #ContentCreator #Tanzania',
          'Just dropped a new beat 🎵 #BongoFlava #Music',
          'Cooking tutorial inaendelea live saa 3! #Cooking #Dar',
          'Football analysis ya mechi ya usiku 🔥 #Football #EPL',
        ][i % 4],
        type: i % 3 == 0 ? PostType.video : PostType.image,
        likesCount: (i + 1) * 234,
        commentsCount: (i + 1) * 12,
        sharesCount: (i + 1) * 5,
        createdAt: DateTime.now().subtract(Duration(hours: i * 2)),
      ),
    );

    _isLoading = false;
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = _posts[index];
    _posts[index] = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    notifyListeners();
  }
}
