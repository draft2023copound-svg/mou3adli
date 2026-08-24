import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../../foundation/shadows.dart';

class TeacherInfoBanner extends StatelessWidget {
  final String teacher;
  final String subject;
  final bool online;
  final double rating;
  final String? avatar;
  final VoidCallback? onCall;
  final VoidCallback? onVideo;
  final VoidCallback? onMore;

  const TeacherInfoBanner({
    super.key,
    required this.teacher,
    required this.subject,
    required this.online,
    required this.rating,
    this.avatar,
    this.onCall,
    this.onVideo,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: RoyalRadius.lg,
        gradient: const LinearGradient(
          colors: [
            RoyalColors.royalBlue700,
            RoyalColors.royalBlue500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: RoyalShadows.glowBlue,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: RoyalColors.gold400,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: RoyalColors.gold400.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatar != null
                      ? Image.network(
                          avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultAvatar(),
                        )
                      : _defaultAvatar(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher,
                      style: RoyalTypography.titleLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject,
                      style: RoyalTypography.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: online
                                ? RoyalColors.success
                                : Colors.white54,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          online ? "Disponible" : "Hors ligne",
                          style: RoyalTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          color: RoyalColors.gold400,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: RoyalTypography.labelLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                icon: Icons.phone_rounded,
                label: "Appel",
                onTap: onCall,
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.videocam_rounded,
                label: "Vidéo",
                onTap: onVideo,
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.more_vert_rounded,
                label: "Plus",
                onTap: onMore,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: Colors.white24,
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: RoyalRadius.md,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: RoyalTypography.labelSmall.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}