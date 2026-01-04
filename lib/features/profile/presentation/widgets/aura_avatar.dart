import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuraAvatar extends StatelessWidget {
  final Color auraColor;
  final String imageUrl;
  final double size;

  const AuraAvatar({
    super.key,
    required this.auraColor,
    required this.imageUrl,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: auraColor.withValues(alpha: 0.6),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.15, 1.15),
                  duration: 2.seconds)
              .boxShadow(
                  begin: BoxShadow(
                      color: auraColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 0),
                  end: BoxShadow(
                      color: auraColor.withValues(alpha: 0.8),
                      blurRadius: 40,
                      spreadRadius: 10)),

          // Inner Ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: auraColor, width: 2),
            ),
          ),

          // Avatar Image
          Container(
            width: size - 10,
            height: size - 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
