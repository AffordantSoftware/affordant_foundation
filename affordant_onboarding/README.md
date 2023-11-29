# Affordant onboarding
Affordant Onboarding is a comprehensive opinionated framework for creating onboarding experiences in Flutter apps. It is built on top of the go_router and bloc libraries.

To improve:
- Step.validate function is not clear
- Lack of way to fetch data based on current step (use step factory instead of step ?)
- Lack of way to change strategy for session data save
- Should use a more general approach instead of a go route
  - design it like a "guard" that show required pages (mixin that overload redirect function ?)
- Route file is outside the feature folder

## Concept

Onboarding is the process of guiding users through a series of screens when they first enter a specific section of the app. This onboarding sequence is shown only once, but if a user exits the onboarding before completing it, they will be prompted to start it again. This package supports both continuing a previous onboarding session and starting a new one each time the user enters the relevant section.

Onboarding is organized into steps, each of which defines an entry condition that determines whether the step should be presented to the user. These steps are evaluated sequentially, with the framework displaying the first step that matches its entry condition. Each step is given the opportunity to read and write data to an session data object, which holds the values of previous steps. This feature is particularly useful for setting flags to track whether the user has completed a step to meet its entry condition. The session data object is automatically synchronized with the backend by the framework.

The framework provides an API for navigating back and forth within the onboarding process through a view model.


## Usage

1. create an onboaridng model:
```dart
/// Session data object, hold all onboarding data
/// Each step is validated based on its data
class SessionData {}

/// Create a step class
sealed class MyStep with Step<SessionData> {

  /// Each step should have a unique id.
  /// Here we use runtimeType to automatically generated it.
  @override
  String get id => runtimeType.toString();

  /// This method is used to determine if user could move to the next step.
  @override
  bool validate(SessionData data) => true;
}

class Step1 extends MyStep {}

class Step2 extends MyStep {}

class MyOnboardingModel extends OnboardingModel<SessionData, MyStep> {
  MyOnboardingModel({
    required super.onboardingRepository,
  }) : super(
          /// instantiate new session data.
          /// this is used when user arrive on the onboarding for the first time.
          initialSessionData: () => SessionData(),
          config: [
            Step1(),
            Step2(),
          ],
        );
}
```

2. create an oboarding repository

Onboarding repository provides data storage api for the onborading model.
You onboarding repository should implement the OnboardingRepository interface

```dart
class ExampleOnboardingRepository implements OnboardingRepository<SessionData> {
  @override
  Future<SessionData?> getSessionData() async {
    return null;
  }

  @override
  Future<List<String>?> getVisitedSteps() async {
    return null;
  }

  @override
  Future<void> markStepVisited(String stepID, bool visited) async {}

  @override
  Future<void> setSessionData(data) async {}
}
```

3. define a ViewModel
```dart
class MyOnboardingViewModel extends OnboardingViewModel<SessionData, MyStep> {
  MyOnboardingViewModel({
    required super.onboardingModel,
    required super.navigationService,
    required super.redirection,
  });

  void setStep1Read() {
    onboardingModel.sessionData?.hasReadStep1 = true;
  }
}
```

4. create an onboarding route with `OnboardingRouteMixin` and return an `OnboardingView`
```dart
@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
)
class OnboardingRoute extends GoRouteData with OnboardingRouteMixin {
  @override
  final String redirection = '/';

  @override
  getModel(BuildContext context) => exampleModel;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingView(
      createViewModel: (_) => MyOnboardingViewModel(
        redirection: redirection,
        navigationService: router,
        onboardingModel: exampleModel,
      ),
      loadingBuilder: (_) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      stepBuilder: (BuildContext context, MyStep step) => switch (step) {
        Step1 s => Onboarding1Screen(step: s),
        Step2 s => Onboarding2Screen(step: s),
      },
    );
  }
}
```

5. call model.init()
The init method indicate to the model that it should retrieve previous session data from the repository.
You can call this method at app start or when the user enter the onboarding route from the view model
```dart
MyOnboaridngModel.init();
```