import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VisionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> dreamData;
  final String heroTag;

  const VisionDetailScreen(
      {super.key, required this.dreamData, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final imageUrl = dreamData['imageUrl'] as String?;
    final title = dreamData['title'] as String? ?? "Untethered Vision";
    final description =
        dreamData['description'] as String? ?? "No memory recorded...";
    final dateStr = dreamData['date'] as String? ?? "";
    final date = DateTime.tryParse(dateStr);
    final displayDate =
        date != null ? "${date.month}/${date.day}/${date.year}" : "";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Image
          Positioned.fill(
            child: Hero(
              tag: heroTag,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(color: const Color(0xFF1A1A2E)),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayDate,
                  style: GoogleFonts.rajdhani(
                      color: Colors.white70, letterSpacing: 2),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 8),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const BoxShadow(color: Color(0xFF7B61FF), blurRadius: 20)
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: GoogleFonts.lora(
                    // Sergeant typography replacement -> Lora or similar serif
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 30),

                // Actions
                Row(
                  children: [
                    _ActionButton(icon: Icons.share, label: "MANIFEST"),
                    const SizedBox(width: 16),
                    _ActionButton(icon: Icons.delete_outline, label: "BANISH"),
                  ],
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),

          // Close Button
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.rajdhani(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
