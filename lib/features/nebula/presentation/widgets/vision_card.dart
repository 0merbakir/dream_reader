import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VisionCard extends StatelessWidget {
  final Map<String, dynamic> dreamData;
  final int index;
  final String heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isBlurred;

  const VisionCard({
    super.key,
    required this.dreamData,
    required this.index,
    required this.heroTag,
    this.onTap,
    this.onLongPress,
    this.isBlurred = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = dreamData['imageUrl'] as String? ?? '';
    final title = dreamData['title'] as String? ?? 'Silent Dream';
    final dateStr =
        dreamData['date'] as String? ?? DateTime.now().toIso8601String();
    final DateTime? date = DateTime.tryParse(dateStr);
    final displayDate = date != null ? "${date.month}/${date.day}" : "?";

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: heroTag,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            fit: StackFit.loose,
            children: [
              // 1. Image (Bottom Layer)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        filterQuality:
                            FilterQuality.medium, // High priority quality
                        placeholder: (context, url) =>
                            const _FadingStarPlaceholder(),
                        errorWidget: (context, url, e) => const Icon(
                            Icons.broken_image,
                            color: Colors.white24),
                      )
                    : const _FadingStarPlaceholder(),
              ),

              // 2. Blur Effect (Middle Layer - Only blurs image)
              if (isBlurred)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 3.0, sigmaY: 3.0), // Subtle mysterious blur
                      child: Container(color: Colors.transparent),
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                ),

              // 3. Gradient Overlay (For Text Readability)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8)
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // 4. Date & Title (Top Layer - Clear & Readable)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayDate,
                      style: GoogleFonts.rajdhani(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }
}

class _FadingStarPlaceholder extends StatelessWidget {
  const _FadingStarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Icon(Icons.auto_awesome,
                color: Colors.white.withValues(alpha: 0.1), size: 32)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fade(begin: 0.2, end: 0.6, duration: 2.seconds),
      ),
    );
  }
}
