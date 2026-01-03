import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dream_reader/features/subscription/user_subscription_provider.dart';
import 'package:dream_reader/presentation/widgets/subscription_overlay.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumGate extends ConsumerWidget {
  final Widget child;
  final Widget? lockedChild; // Optional: Show this instead of blurred child if provided

  const PremiumGate({
    super.key, 
    required this.child, 
    this.lockedChild
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(userSubscriptionProvider);

    if (isPremium) {
      return child.animate().fadeIn(duration: 500.ms);
    }

    return Stack(
      children: [
        // The content (blurred or hidden)
        lockedChild ?? child,
        
        // The Paywall Overlay
        const Positioned.fill(
          child: SubscriptionOverlay(),
        ),
      ],
    );
  }
}
