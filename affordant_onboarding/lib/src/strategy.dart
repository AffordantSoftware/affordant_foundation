class OnboardingDataReplicationStrategy {
  const OnboardingDataReplicationStrategy({
    required this.replicateOnDataChanged,
    required this.replicateOnStepChanged,
    this.waitForDataReplicatedBeforeDone = true,
  });

  const factory OnboardingDataReplicationStrategy.onStepChanged({
    bool waitForDataReplicatedBeforeDone,
  }) = ReplicateOnStepChangedStrategy;

  final bool replicateOnDataChanged;
  final bool replicateOnStepChanged;
  final bool waitForDataReplicatedBeforeDone;
}

class ReplicateOnStepChangedStrategy
    implements OnboardingDataReplicationStrategy {
  const ReplicateOnStepChangedStrategy({
    this.waitForDataReplicatedBeforeDone = true,
  });

  @override
  final bool replicateOnDataChanged = false;

  @override
  final bool replicateOnStepChanged = true;

  @override
  final bool waitForDataReplicatedBeforeDone;
}
