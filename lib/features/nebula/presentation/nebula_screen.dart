import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NebulaScreen extends StatelessWidget {
  const NebulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final images = List.generate(20, (index) => "https://picsum.photos/seed/${index + 100}/400/600");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("NEBULA ARCHIVE", style: GoogleFonts.orbitron(letterSpacing: 2, color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _NebulaCard(imageUrl: images[index], index: index);
        },
      ),
    );
  }
}

class _NebulaCard extends StatelessWidget {
  final String imageUrl;
  final int index;

  const _NebulaCard({required this.imageUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          
          // Gradient Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                ),
              ),
            ),
          ),

          // Date / Info
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                   "Dream #${index + 42}", 
                   style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                 ),
                 Text(
                   "Dec ${index + 1}", 
                   style: GoogleFonts.roboto(color: Colors.white70, fontSize: 10),
                 ),
              ],
            ),
          ),

          // Share Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 16),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale();
  }
}
