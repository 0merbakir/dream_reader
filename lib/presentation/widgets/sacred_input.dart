import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dream_reader/presentation/widgets/audio_waveform.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/core/widgets/glass_container.dart';
import 'package:dream_reader/application/dream_controller.dart';

class SacredInput extends ConsumerStatefulWidget {
  final bool isListening;
  final bool isLoading;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;
  final TextEditingController controller;

  const SacredInput({
    super.key,
    required this.isListening,
    required this.isLoading,
    required this.onStartListening,
    required this.onStopListening,
    required this.controller,
  });

  @override
  ConsumerState<SacredInput> createState() => _SacredInputState();
}

class _SacredInputState extends ConsumerState<SacredInput> {
  bool _isManualMode = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _submitManual() {
    if (widget.controller.text.trim().isNotEmpty) {
      final controller = ref.read(dreamControllerProvider.notifier);
      controller.analyzeDream(widget.controller.text);
      widget.controller.clear();
      FocusScope.of(context).unfocus();
      setState(() => _isManualMode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sw = size.width * 0.01; // 1% of screen width

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isListening) ...[
          Padding(
            padding: EdgeInsets.only(bottom: sw * 4),
            child: const Center(child: AudioWaveform(isListening: true)),
          ),
          Text(
            "Listening...",
            style: GoogleFonts.orbitron(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 2.0,
              fontSize: (sw * 3).clamp(10.0, 14.0),
              fontWeight: FontWeight.w300,
            ),
          ).animate().fadeIn(),
          SizedBox(height: sw * 4),
        ],
        if (widget.isLoading) ...[
          Text(
            "Analyzing...",
            style: GoogleFonts.orbitron(
              color: const Color(0xFFFF00FF),
              letterSpacing: 2.0,
              fontSize: (sw * 3).clamp(10.0, 14.0),
              fontWeight: FontWeight.w300,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn()
              .shimmer(duration: 1.seconds),
          SizedBox(height: sw * 4),
        ],
        if (_isManualMode && !widget.isLoading && !widget.isListening) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 6),
            child: GlassContainer(
              opacity: 0.1,
              child: TextField(
                controller: widget.controller,
                autofocus: true,
                maxLines: 4,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (sw * 4).clamp(14.0, 18.0),
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.inputPlaceholder,
                  hintStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(sw * 4),
                ),
                onSubmitted: (_) => _submitManual(),
              ),
            ),
          ),
          SizedBox(height: sw * 3),

          // REACTIVE FAB SECTION
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              final bool hasText = value.text.trim().isNotEmpty;
              return Row(
                mainAxisAlignment: MainAxisAlignment
                    .end, // Align FAB to right or center? Center is safer for balance.
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      setState(() => _isManualMode = false);
                      widget.controller.clear();
                    },
                    child: Text(
                      "CANCEL",
                      style: GoogleFonts.orbitron(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: (sw * 2.5).clamp(10.0, 12.0),
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedScale(
                    scale: hasText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: FloatingActionButton(
                      onPressed: hasText ? _submitManual : null,
                      backgroundColor: const Color(0xFF7B61FF),
                      child:
                          const Icon(Icons.auto_awesome, color: Colors.white),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)),
                  ),
                ],
              );
            },
          ),
        ] else if (!widget.isListening && !widget.isLoading) ...[
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onStartListening,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  minWidth: (sw * 50).clamp(200.0, 400.0),
                  maxWidth: (sw * 80).clamp(200.0, 400.0),
                  minHeight: (sw * 15).clamp(50.0, 80.0),
                  maxHeight: (sw * 20).clamp(60.0, 100.0),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color(0xFF7B61FF).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B61FF).withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: (sw * 5).clamp(18.0, 24.0),
                      ),
                      SizedBox(width: sw * 4),
                      Flexible(
                        child: Text(
                          "Record Dream",
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w400,
                            fontSize: (sw * 3).clamp(11.0, 14.0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              .animate()
              .shimmer(delay: 800.ms, duration: 2.seconds)
              .fadeIn(duration: 800.ms)
              .scale(delay: 800.ms),
          SizedBox(height: sw * 3),
          TextButton(
            onPressed: () => setState(() => _isManualMode = true),
            child: Text(
              "OR TYPE YOUR VISION",
              style: GoogleFonts.orbitron(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: (sw * 2.5).clamp(10.0, 12.0),
                letterSpacing: 2,
              ),
            ),
          ),
        ] else if (widget.isListening) ...[
          GestureDetector(
            onTap: widget.onStopListening,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: (sw * 20).clamp(70.0, 90.0),
              height: (sw * 20).clamp(70.0, 90.0),
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.stop,
                  color: const Color(0xFF00F0FF),
                  size: (sw * 7).clamp(24.0, 32.0),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
