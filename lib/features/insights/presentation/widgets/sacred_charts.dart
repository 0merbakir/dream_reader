import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArchetypeRadar extends StatelessWidget {
  final Map<String, double> data;

  const ArchetypeRadar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final ticks = [0.2, 0.4, 0.6, 0.8, 1.0];
    final features = data.keys.toList();

    return SizedBox(
      height: 300,
      child: RadarChart(
        RadarChartData(
          radarTouchData: RadarTouchData(enabled: false),
          tickCount: ticks.length,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          gridBorderData:
              BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: GoogleFonts.rajdhani(
              color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
          getTitle: (index, angle) {
            return RadarChartTitle(text: features[index]);
          },
          dataSets: [
            RadarDataSet(
              fillColor: const Color(0xFF7B61FF).withValues(alpha: 0.2),
              borderColor: const Color(0xFF7B61FF),
              entryRadius: 3,
              dataEntries:
                  features.map((f) => RadarEntry(value: data[f]!)).toList(),
              borderWidth: 2,
            ),
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: const Color(0xFF00F0FF).withValues(alpha: 0.5),
              entryRadius: 0,
              dataEntries: features
                  .map((f) => RadarEntry(value: 0.5))
                  .toList(), // Reference circle
              borderWidth: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class VibrationHorizon extends StatelessWidget {
  final List<double> data;

  const VibrationHorizon({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: data.length.toDouble() - 1,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFF00F0FF)],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7B61FF).withValues(alpha: 0.3),
                    const Color(0xFF00F0FF).withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
