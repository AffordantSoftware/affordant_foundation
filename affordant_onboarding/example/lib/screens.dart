import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/router.dart';
import 'package:flutter/material.dart' hide Step;

import 'model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen(
    this.name, {
    super.key,
    required this.body,
    required this.step,
  });

  final String name;
  final Widget body;
  final Step step;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          body,
          Row(
            children: [
              ElevatedButton(
                onPressed: context.watch<MyOnboardingViewModel>().prev,
                child: const Text("back"),
              ),
              ElevatedButton(
                onPressed: () {
                  // final model = context.read<MyOnboardingViewModel>();

                  context.read<MyOnboardingViewModel>().next();
                },
                child: const Text("continue"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({
    super.key,
    required this.step,
  });

  final Step1 step;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      "1",
      step: step,
      body: const Center(
        child: Text("Step 1"),
      ),
    );
  }
}

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({
    super.key,
    required this.step,
  });

  final Step2 step;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      "2",
      step: step,
      body: const Center(
        child: Text("Step 2"),
      ),
    );
  }
}

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({
    super.key,
    required this.step,
  });

  final Step2 step;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      "3",
      step: step,
      body: const Center(
        child: Text("Step 3"),
      ),
    );
  }
}
