import 'dart:ui' as ui;
import 'package:dream_reader/application/dream_controller.dart';
import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/presentation/widgets/ai_orb.dart';
import 'package:dream_reader/presentation/widgets/analysis_feed.dart';
import 'package:dream_reader/presentation/widgets/lottie_loading.dart';
import 'package:dream_reader/presentation/widgets/nebula_background.dart';
import 'package:dream_reader/presentation/widgets/sacred_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/core/extensions/l10n_extension.dart';

class DreamScreen extends ConsumerStatefulWidget {
  const DreamScreen({super.key});

  @override
  ConsumerState<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends ConsumerState<DreamScreen> {
  final GlobalKey _shareKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _captureAndShare() async {
    try {
      final boundary = _shareKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Share Error: Boundary not found");
        return;
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        ref.read(dreamControllerProvider.notifier).shareResult(pngBytes);
      }
    } catch (e) {
      debugPrint("Share Capture Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dreamState = ref.watch(dreamControllerProvider);
    final controller = ref.read(dreamControllerProvider.notifier);
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= 1024;
    final double horizontalPadding = size.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const NebulaBackground(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // 1. Adaptive Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: Center(
                          child: Text(
                            context.l10n.appTitle,
                            style: GoogleFonts.orbitron(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: (size.width * 0.03).clamp(12.0, 18.0),
                              letterSpacing: 8,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. Responsive Content Layout
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      sliver: SliverToBoxAdapter(
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left: AI Orb & Visuals
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        _buildOrbSection(size, dreamState),
                                      ],
                                    ),
                                  ),
                                  // Right: Interpretation Feed
                                  Expanded(
                                    flex: 6,
                                    child: _buildAnalysisSection(dreamState),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildOrbSection(size, dreamState),
                                  _buildAnalysisSection(dreamState),
                                ],
                              ),
                      ),
                    ),

                    // 3. Spacing for Input
                    SliverToBoxAdapter(
                        child: SizedBox(height: size.height * 0.15)),
                  ],
                ),
              ),
            ),
          ),

          // 4. Fixed Input Area (Floating at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: horizontalPadding,
                right: horizontalPadding,
                top: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SacredInput(
                    isListening: dreamState.isListening,
                    isLoading: dreamState.isLoading,
                    controller: _textController,
                    onStartListening: () {
                      final locale = Localizations.localeOf(context);
                      final localeId =
                          "${locale.languageCode}-${locale.countryCode ?? locale.languageCode.toUpperCase()}";
                      controller.startVoiceInput(localeId);
                    },
                    onStopListening: () => controller.stopVoiceInput(),
                  ),
                ),
              ),
            ),
          ),
          // 5. Sharing Loading Overlay
          if (dreamState.isSharingImage)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF7B61FF),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '✨ Preparing your dream card...',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrbSection(Size size, DreamState dreamState) {
    final double orbSize = (size.height * 0.35).clamp(150.0, 400.0);
    return SizedBox(
      height: orbSize,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _textController,
        builder: (context, value, _) {
          return AIOrb(
            isListening: dreamState.isListening,
            isLoading: dreamState.isLoading,
            isTyping: value.text.isNotEmpty,
            textLength: value.text.length,
          );
        },
      ),
    );
  }

  Widget _buildAnalysisSection(DreamState dreamState) {
    if (dreamState.isLoading) return const LottieLoading();
    if (dreamState.analysis == null) return const SizedBox.shrink();

    return AnalysisFeed(
      analysis: dreamState.analysis,
      imageUrl: dreamState.imageUrl,
      imageError: dreamState.imageError,
      isImageLoading: dreamState.isImageLoading,
      onShare: _captureAndShare,
    );
  }
}
