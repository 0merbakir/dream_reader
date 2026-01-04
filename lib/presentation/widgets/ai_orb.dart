import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AIOrb extends StatelessWidget {
  final bool isListening;
  final bool isLoading;
  final bool isTyping;
  final int textLength;

  const AIOrb({
    super.key,
    required this.isListening,
    required this.isLoading,
    this.isTyping = false,
    this.textLength = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic color based on state and length
    Color primaryColor = const Color(0xFF7B61FF);

    if (isLoading) {
      primaryColor = const Color(0xFFFF00FF);
    } else if (isListening) {
      primaryColor = const Color(0xFF00F0FF);
    } else if (isTyping) {
      // Shift from Gold to Cyan as length increases
      final factor = (textLength / 200).clamp(0.0, 1.0);
      primaryColor = Color.lerp(
        const Color(0xFFFFD700), // Gold
        const Color(0xFF00F0FF), // Cyan
        factor,
      )!;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double vh = MediaQuery.of(context).size.height;
        // Size shift slightly with text length
        final growth = (textLength / 500).clamp(0.0, 0.2);
        final double baseSize = (vh * 0.3).clamp(150.0, 400.0);
        final double size = baseSize * (1.0 + growth);
        final double orbSize = size * 0.6;

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Concentric Ripples when listening
                if (isListening) ...[
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: orbSize,
                      height: orbSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(2.0, 2.0),
                          duration: (1.5 + i * 0.5).seconds,
                          curve: Curves.easeOut,
                        )
                        .fadeOut(duration: (1.5 + i * 0.5).seconds),
                ],

                // The Main Orb
                Container(
                  width: orbSize,
                  height: orbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.9),
                        primaryColor.withValues(alpha: 0.6),
                        primaryColor,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.1, 0.3, 0.7, 1.0],
                      center: const Alignment(-0.2, -0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 0,
                      end: -20,
                      duration: 4.seconds,
                      curve: Curves.easeInOutSine,
                    )
                    .animate(target: isListening ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    )
                    .animate(target: isLoading ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.2),
                      duration: 100.ms,
                      curve: Curves.elasticIn,
                    )
                    .then()
                    .animate(
                      target: isLoading ? 1 : 0,
                      onPlay: (c) => c.repeat(reverse: true),
                    )
                    .shimmer(
                      duration: 1.seconds,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
