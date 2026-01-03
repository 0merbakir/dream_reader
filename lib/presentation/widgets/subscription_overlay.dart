import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionOverlay extends StatelessWidget {
  const SubscriptionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Frosted Glass Effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),

        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Color(0xFF7B61FF), size: 48)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
                    .then()
                    .shake(duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  "UNLOCK INSIGHTS",
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                _FeatureItem(icon: Icons.image, text: "Unlimited HD DALL-E Images"),
                _FeatureItem(icon: Icons.record_voice_over, text: "Human-like AI Voice"),
                _FeatureItem(icon: Icons.psychology, text: "Deep Psychological Analysis"),
                _FeatureItem(icon: Icons.block, text: "Ad-free Experience"),
                
                const SizedBox(height: 32),
                
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B61FF), Color(0xFF00F0FF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B61FF).withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {}, // Trigger purchase flow
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "GO PRO • \$4.99/mo",
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .shimmer(duration: 3.seconds, delay: 1.seconds),
                 
                 const SizedBox(height: 16),
                 Text(
                   "Restore Purchases",
                   style: GoogleFonts.roboto(
                     color: Colors.white54,
                     fontSize: 12,
                     decoration: TextDecoration.underline,
                   ),
                 ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00F0FF), size: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.roboto(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
