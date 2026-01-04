import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/data/services/mock_data_service.dart'; // MOCK DATA
import 'package:dream_reader/features/subscription/user_subscription_provider.dart';
import 'package:dream_reader/features/insights/presentation/widgets/clarity_gauge.dart';
import 'package:dream_reader/features/insights/presentation/widgets/sacred_charts.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(userSubscriptionProvider);
    // Use Mock Data for the Simulation
    final mockVisions = MockDataService.getMockDreams();

    // Aggregating mock data for charts
    // Radar: Average of all archetypes in mock data
    Map<String, double> archetypeData = {
      "The Shadow": 0.0,
      "The Sage": 0.0,
      "The Traveler": 0.0,
      "The Guardian": 0.0,
      "The Eternal": 0.0
    };

    for (var v in mockVisions) {
      final Map<String, double> archs = v['archetypes'];
      archs.forEach((k, value) {
        archetypeData[k] = (archetypeData[k] ?? 0) + value;
      });
    }
    // Normalize
    archetypeData.updateAll((key, val) => val / mockVisions.length);

    // Line: Map vibration levels
    final vibrationData = mockVisions
        .take(7)
        .map((v) => (v['vibrationLevel'] as int).toDouble())
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ambient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF0F0F1A), Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text("THE SACRED MAP",
                    style: GoogleFonts.orbitron(
                        color: Colors.white, fontSize: 16, letterSpacing: 3)),
                const SizedBox(height: 40),

                // 1. The Clarity Gauge
                const ClarityGauge(
                    percentage: 0.88), // Hardcoded for aesthetics

                const SizedBox(height: 50),

                // 2. Symbolic Totems
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 20),
                      _TotemIcon(icon: Icons.waves, label: "Water"),
                      _TotemIcon(icon: Icons.air, label: "Flight"),
                      _TotemIcon(icon: Icons.nightlight_round, label: "Moon"),
                      _TotemIcon(icon: Icons.visibility, label: "Eye"),
                      _TotemIcon(icon: Icons.forest, label: "Nature"),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. The Sacred Charts (Gnosis)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          _ChartHeader(title: "SUBCONSCIOUS ARCHETYPES"),
                          const SizedBox(height: 20),
                          ArchetypeRadar(data: archetypeData),
                          const SizedBox(height: 40),
                          _ChartHeader(title: "VIBRATION HORIZON"),
                          const SizedBox(height: 20),
                          VibrationHorizon(data: vibrationData),
                          const SizedBox(height: 100), // Bottom padding
                        ],
                      ),

                      // Paywall Blur
                      if (!isPremium)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.2),
                                alignment: Alignment.center,
                                child: _AwakenButton(ref: ref),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotemIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TotemIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Icon(icon, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.rajdhani(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  final String title;
  const _ChartHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF7B61FF)),
          const SizedBox(width: 8),
          Text(title,
              style: GoogleFonts.orbitron(
                  color: Colors.white54, fontSize: 12, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _AwakenButton extends StatelessWidget {
  final WidgetRef ref;
  const _AwakenButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(userSubscriptionProvider.notifier).togglePremium(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF7B61FF), Color(0xFF00F0FF)],
          ),
          boxShadow: [
            const BoxShadow(
                color: Color(0xFF7B61FF), blurRadius: 20, spreadRadius: 1),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open, color: Colors.white),
            const SizedBox(width: 12),
            Text("AWAKEN YOUR FULL SIGHT",
                style: GoogleFonts.orbitron(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
