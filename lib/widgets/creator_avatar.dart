import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
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
          padding: isLive ? const EdgeInsets.all(2) : EdgeInsets.zero,
          decoration: isLive
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [AppColors.live, Color(0xFFFF6B35)]),
                )
              : null,
          child: Container(
            padding: isLive ? const EdgeInsets.all(2) : EdgeInsets.zero,
            decoration: isLive ? BoxDecoration(color: context.colors.surface, shape: BoxShape.circle) : null,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: GoogleFonts.dmSans(fontSize: radius * 0.65, fontWeight: FontWeight.w700, color: AppColors.primary),
                    )
                  : null,
            ),
          ),
        ),
        if (isLive)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(4)),
                child: Text('LIVE', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ),
            ),
          ),
      ],
    );
  }
}
