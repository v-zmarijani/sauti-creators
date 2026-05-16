import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class CreatorAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double radius;
  final bool isLive;

  const CreatorAvatar({super.key, this.avatarUrl, required this.name, this.radius = 24, this.isLive = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: isLive
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.live, width: 2),
                )
              : null,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: TextStyle(fontSize: radius * 0.7, fontWeight: FontWeight.bold, color: Colors.white))
                : null,
          ),
        ),
        if (isLive)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(4)),
                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }
}
