import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dream_reader/features/nebula/presentation/widgets/vision_card.dart';
import 'package:dream_reader/features/nebula/presentation/vision_detail_screen.dart';
import 'package:dream_reader/features/common/global_app_state.dart';
import 'package:dream_reader/core/services/language_service.dart';
import 'package:hive_flutter/hive_flutter.dart' as import_hive;

class NebulaScreen extends ConsumerWidget {
  const NebulaScreen({super.key});

  List<dynamic> _getFilteredDreams(
      List<dynamic> allDreams, String activeFilter) {
    if (activeFilter == 'all') return allDreams;

    return allDreams.where((d) {
      final dream = Map<String, dynamic>.from(d as Map);
      final title = (dream['title'] ?? '').toString().toLowerCase();
      final analysis = (dream['analysis'] ?? '').toString().toLowerCase();

      if (activeFilter == 'nightmare') {
        return title.contains('nightmare') ||
            analysis.contains('nightmare') ||
            analysis.contains('fear');
      }
      if (activeFilter == 'lucid') {
        return title.contains('lucid') ||
            analysis.contains('clarity') ||
            analysis.contains('aware');
      }
      if (activeFilter == 'ethereal') {
        return title.contains('ethereal') ||
            analysis.contains('spirit') ||
            analysis.contains('light');
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(globalAppStateProvider);
    final activeFilter = appState.currentVibeFilter;
    final locale = appState.currentLocale.languageCode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Atmosphere
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.5),
                  radius: 1.5,
                  colors: [Color(0xFF1A1A2E), Colors.black],
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 60),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LanguageService.getString(locale, 'nebula_title'),
                        style: GoogleFonts.orbitron(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: 16)),
                    const Icon(Icons.search, color: Colors.white54),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildFilterChip(ref, activeFilter, "all",
                        LanguageService.getString(locale, 'filter_all')),
                    _buildFilterChip(ref, activeFilter, "ethereal",
                        LanguageService.getString(locale, 'filter_ethereal')),
                    _buildFilterChip(ref, activeFilter, "nightmare",
                        LanguageService.getString(locale, 'filter_nightmare')),
                    _buildFilterChip(ref, activeFilter, "lucid",
                        LanguageService.getString(locale, 'filter_lucid')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Gallery
              Expanded(
                child: _buildGallery(ref, locale),
              ),
            ],
          ),

          // Mist Effect
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9)
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(WidgetRef ref, String locale) {
    return ValueListenableBuilder(
        valueListenable: import_hive.Hive.box('dreams').listenable(),
        builder: (context, box, _) {
          final appState = ref.watch(globalAppStateProvider);
          final activeFilter = appState.currentVibeFilter;
          final isPremium = appState.isPremium;

          if (box.isEmpty) {
            return Center(
                child: Text(LanguageService.getString(locale, 'empty_archive'),
                    style: GoogleFonts.rajdhani(color: Colors.white38)));
          }

          // 1. Prepare Data
          final rawDreams = box.values.toList().reversed.toList();
          final filteredDreams = _getFilteredDreams(rawDreams, activeFilter);

          final displayItems = <dynamic>[];

          for (var i = 0; i < filteredDreams.length; i++) {
            displayItems.add(filteredDreams[i]);
            // Inject Ad every 4 items if not premium
            if (!isPremium && (i + 1) % 4 == 0) {
              displayItems.add("AD_BANNER");
            }
          }

          return MasonryGridView.count(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: displayItems.length,
            itemBuilder: (context, index) {
              final item = displayItems[index];

              if (item == "AD_BANNER") {
                return _AdBanner(locale: locale);
              }

              final dreamMap = Map<String, dynamic>.from(item as Map);
              // CRITICAL: Unique Hero Tag
              final uniqueHeroTag =
                  'vision_${dreamMap['id'] ?? index}_${DateTime.now().millisecondsSinceEpoch}';

              return VisionCard(
                dreamData: dreamMap,
                index: index, // Visual index
                isBlurred: false, // NO BLUR requested
                heroTag: uniqueHeroTag,
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VisionDetailScreen(
                                dreamData: dreamMap, heroTag: uniqueHeroTag)));
                  } catch (e) {
                    debugPrint("Navigation Error: $e");
                  }
                },
              );
            },
          );
        });
  }

  Widget _buildFilterChip(
      WidgetRef ref, String currentFilter, String key, String label) {
    final isActive = currentFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          ref.read(globalAppStateProvider).setVibeFilter(key);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(label,
              style: GoogleFonts.rajdhani(
                  color: isActive ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _AdBanner extends StatelessWidget {
  final String locale;
  const _AdBanner({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border:
            Border.all(color: const Color(0xFF7B61FF).withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.star, color: Color(0xFF00F0FF)),
          const SizedBox(height: 8),
          Text(LanguageService.getString(locale, 'remove_ads'),
              style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(LanguageService.getString(locale, 'upgrade_premium'),
              style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
