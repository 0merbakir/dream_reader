import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A background widget that renders a deep space nebula effect.
///
/// This serves as the foundation of the "Antigravity" design system,
/// providing a dynamic, mood-setting backdrop with animated blobs
/// and glassmorphic filtering.
class NebulaBackground extends StatelessWidget {
  const NebulaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep Space Black Base
        Container(color: const Color(0xFF050510)),

        // Layer 1: Deep Purple/Blue Nebulas
        Positioned(
          top: -100,
          left: -50,
          child: _NebulaBlob(
            color: const Color(0xFF2E004F),
            size: 400,
            blur: 100,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(
                  duration: 20.seconds,
                  begin: const Offset(0, 0),
                  end: const Offset(20, 50))
              .scale(
                  duration: 30.seconds,
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2)),
        ),

        // Layer 2: Cosmic Cyan Highlights
        Positioned(
          bottom: 100,
          right: -50,
          child: _NebulaBlob(
            color: const Color(0xFF003366),
            size: 350,
            blur: 80,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(
                  duration: 25.seconds,
                  begin: const Offset(0, 0),
                  end: const Offset(-30, -30))
              .fadeIn(duration: 5.seconds),
        ),

        // Layer 3: Vibrant Accent
        Positioned(
          top: 200,
          left: 50,
          child: _NebulaBlob(
            color: const Color(0xFF7B61FF).withValues(alpha: 0.3),
            size: 250,
            blur: 90,
          ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
              duration: 18.seconds,
              begin: const Offset(0, 0),
              end: const Offset(40, -20)),
        ),

        // Backdrop Filter to blend everything smoothly
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class _NebulaBlob extends StatelessWidget {
  final Color color;
  final double size;
  final double blur;

  const _NebulaBlob({
    required this.color,
    required this.size,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: blur / 2,
          ),
        ],
      ),
    );
  }
}
