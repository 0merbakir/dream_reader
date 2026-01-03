import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_subscription_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSubscription extends _$UserSubscription {
  @override
  bool build() {
    // Default to false (Free Tier)
    return false;
  }

  void togglePremium() {
    state = !state;
  }
  
  void setPremium(bool value) {
    state = value;
  }
}
