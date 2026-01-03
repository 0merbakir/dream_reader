import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NebulaShareCard extends StatelessWidget {
  final String imageUrl;
  final String quote;
  final String date;

  const NebulaShareCard({
    super.key,
    required this.imageUrl,
    required this.quote,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00F0FF), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF00F0FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  "DREAM READER",
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          
          // Image
          if (imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            
          // Quote Area
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "\"$quote\"",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.white.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Get the App",
                        style: GoogleFonts.orbitron(color: const Color(0xFF00F0FF), fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
