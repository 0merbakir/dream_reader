import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final bool isPremium;
  final int dailyDreamCount;

  const UserState({this.isPremium = false, this.dailyDreamCount = 0});

  UserState copyWith({bool? isPremium, int? dailyDreamCount}) {
    return UserState(
      isPremium: isPremium ?? this.isPremium,
      dailyDreamCount: dailyDreamCount ?? this.dailyDreamCount,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  void togglePremium() {
    state = state.copyWith(isPremium: !state.isPremium);
  }

  void incrementDailyCount() {
    state = state.copyWith(dailyDreamCount: state.dailyDreamCount + 1);
  }

  void resetdailyCount() {
    state = state.copyWith(dailyDreamCount: 0);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
