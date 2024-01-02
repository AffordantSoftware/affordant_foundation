import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:affordant_onboarding/affordant_onboarding.dart';

class SessionData {
  final bool hasReadStep1;
  final bool hasReadStep2;

  SessionData({required this.hasReadStep1, required this.hasReadStep2});

  SessionData copyWith({
    bool? hasReadStep1,
    bool? hasReadStep2,
  }) =>
      SessionData(
        hasReadStep1: hasReadStep1 ?? this.hasReadStep1,
        hasReadStep2: hasReadStep2 ?? this.hasReadStep2,
      );
}

final class MyOnboardingRepo extends OnboardingRepository<SessionData> {
  @override
  late final ReplicatedReactive<SessionData?> sessionData = replicatedReactive(
    fetch: () => null,
    write: (_) {},
  );

  @override
  late final ReplicatedReactive<List<String>?> visitedSteps =
      replicatedReactive(
    fetch: () => null,
    write: (_) {},
  );
}

final exampleModel = MyOnboardingRepo();
