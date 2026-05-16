enum PostType { image, video, text }

class PostModel {
  final String id;
  final String creatorId;
  final String creatorName;
  final String creatorUsername;
  final String? creatorAvatarUrl;
  final String? caption;
  final String? mediaUrl;
  final PostType type;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorUsername,
    this.creatorAvatarUrl,
    this.caption,
    this.mediaUrl,
    required this.type,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
        id: map['id'] as String,
        creatorId: map['creatorId'] as String,
        creatorName: map['creatorName'] as String,
        creatorUsername: map['creatorUsername'] as String,
        creatorAvatarUrl: map['creatorAvatarUrl'] as String?,
        caption: map['caption'] as String?,
        mediaUrl: map['mediaUrl'] as String?,
        type: PostType.values.firstWhere((e) => e.name == map['type']),
        likesCount: (map['likesCount'] as int?) ?? 0,
        commentsCount: (map['commentsCount'] as int?) ?? 0,
        sharesCount: (map['sharesCount'] as int?) ?? 0,
        isLiked: (map['isLiked'] as bool?) ?? false,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creatorUsername': creatorUsername,
        'creatorAvatarUrl': creatorAvatarUrl,
        'caption': caption,
        'mediaUrl': mediaUrl,
        'type': type.name,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'sharesCount': sharesCount,
        'isLiked': isLiked,
        'createdAt': createdAt.toIso8601String(),
      };

  PostModel copyWith({bool? isLiked, int? likesCount, int? commentsCount}) =>
      PostModel(
        id: id,
        creatorId: creatorId,
        creatorName: creatorName,
        creatorUsername: creatorUsername,
        creatorAvatarUrl: creatorAvatarUrl,
        caption: caption,
        mediaUrl: mediaUrl,
        type: type,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        sharesCount: sharesCount,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt,
      );
}
