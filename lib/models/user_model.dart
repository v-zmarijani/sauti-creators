class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;
  final double totalEarnings;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    this.totalEarnings = 0.0,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        username: map['username'] as String,
        email: map['email'] as String,
        avatarUrl: map['avatar_url'] as String?,
        bio: map['bio'] as String?,
        followersCount: (map['followers_count'] as int?) ?? 0,
        followingCount: (map['following_count'] as int?) ?? 0,
        postsCount: (map['posts_count'] as int?) ?? 0,
        isVerified: (map['is_verified'] as bool?) ?? false,
        totalEarnings: ((map['total_earnings'] as num?) ?? 0).toDouble(),
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'avatar_url': avatarUrl,
        'bio': bio,
        'followers_count': followersCount,
        'following_count': followingCount,
        'posts_count': postsCount,
        'is_verified': isVerified,
        'total_earnings': totalEarnings,
        'created_at': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? username,
    String? avatarUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    double? totalEarnings,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount,
        postsCount: postsCount ?? this.postsCount,
        isVerified: isVerified ?? this.isVerified,
        totalEarnings: totalEarnings ?? this.totalEarnings,
        createdAt: createdAt,
      );
}
