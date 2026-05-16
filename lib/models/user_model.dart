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
        avatarUrl: map['avatarUrl'] as String?,
        bio: map['bio'] as String?,
        followersCount: (map['followersCount'] as int?) ?? 0,
        followingCount: (map['followingCount'] as int?) ?? 0,
        postsCount: (map['postsCount'] as int?) ?? 0,
        isVerified: (map['isVerified'] as bool?) ?? false,
        totalEarnings: ((map['totalEarnings'] as num?) ?? 0).toDouble(),
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'postsCount': postsCount,
        'isVerified': isVerified,
        'totalEarnings': totalEarnings,
        'createdAt': createdAt.toIso8601String(),
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
