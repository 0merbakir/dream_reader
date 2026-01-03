import 'package:dream_reader/features/subscription/premium_gate.dart';
import 'package:dream_reader/data/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Analytics Data
    final analytics = ref.watch(analyticsServiceProvider);
    final emotions = analytics.getDominantEmotions();
    final intensity = analytics.getDreamIntensity(); // Mock 1-10
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: PremiumGate(
        // Locked Content: Blurred Charts
        lockedChild: _buildContent(context, emotions, intensity, isLocked: true),
        // Unlocked Content: Sharp, Interactive Charts
        child: _buildContent(context, emotions, intensity, isLocked: false),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, double> emotions, int intensity, {required bool isLocked}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _SectionHeader(title: "PSYCHE RADAR"),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.3,
            child: _buildRadarChart(emotions, isLocked),
          ),
          const SizedBox(height: 30),
          _SectionHeader(title: "DREAM INTENSITY"),
          const SizedBox(height: 10),
          _buildIntensityMeter(context, intensity, isLocked),
           const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildRadarChart(Map<String, double> emotions, bool isLocked) {
    if (emotions.isEmpty) {
        return Center(child: Text("No Data", style: TextStyle(color: Colors.white54)));
    }
    
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: const Color(0xFF00F0FF).withValues(alpha: isLocked ? 0.1 : 0.4),
            borderColor: const Color(0xFF00F0FF).withValues(alpha: isLocked ? 0.2 : 1.0),
            entryRadius: isLocked ? 0 : 3,
            dataEntries: emotions.values.map((e) => RadarEntry(value: e > 0 ? e : 0.5)).toList(), // Min 0.5 for viz
            borderWidth: 2,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.white12),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10),
        getTitle: (index, angle) {
            if (index >= emotions.keys.length) return const RadarChartTitle(text: "");
            return RadarChartTitle(text: emotions.keys.elementAt(index));
        },
        tickCount: 3,
        ticksTextStyle: const TextStyle(color: Colors.transparent),
        gridBorderData: const BorderSide(color: Colors.white12, width: 1),
      ),
    );
  }

  Widget _buildIntensityMeter(BuildContext context, int intensity, bool isLocked) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
            children: [
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                       Text("Depth Score", style: GoogleFonts.roboto(color: Colors.white70)),
                       Text("$intensity/10", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                   ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                    value: intensity / 10,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF7B61FF).withValues(alpha: isLocked ? 0.3 : 1.0),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                )
            ],
        ),
      );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 14,
        color: const Color(0xFF00F0FF).withValues(alpha: 0.7),
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
