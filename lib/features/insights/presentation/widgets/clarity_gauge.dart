import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClarityGauge extends StatelessWidget {
  final double percentage; // 0.0 to 1.0

  const ClarityGauge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.1)),
              ),
              // Foreground Gradient Circle
              ShaderMask(
                shaderCallback: (rect) {
                  return const SweepGradient(
                    startAngle: 0.0,
                    endAngle: 3.14 * 2,
                    colors: [
                      Color(0xFF7B61FF), // Deep Purple
                      Color(0xFF00F0FF), // Electric Blue
                      Color(0xFF7B61FF), // Loop back
                    ],
                    transform: GradientRotation(3.14 / 2),
                  ).createShader(rect);
                },
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white), // Color is ignored due to ShaderMask
                ),
              ),
              // Center Text
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${(percentage * 100).toInt()}%",
                      style: GoogleFonts.orbitron(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const BoxShadow(
                                color: Color(0xFF00F0FF), blurRadius: 20)
                          ]),
                    ),
                    Text(
                      "CLARITY",
                      style: GoogleFonts.rajdhani(
                        fontSize: 12,
                        color: Colors.white54,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "CONNECTION TO THE VOID",
          style: GoogleFonts.orbitron(
            fontSize: 12,
            color: const Color(0xFF7B61FF),
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
