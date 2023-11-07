import 'package:example/model.dart';
import 'package:example/router.dart';
import 'package:flutter/material.dart';

void main() async {
  print("test");
  await exampleModel.init();
  runApp(const OnboardingExample());
}

class OnboardingExample extends StatelessWidget {
  const OnboardingExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
