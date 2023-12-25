# affordant_foundation
Unstable, experimental and wip
do not use in production

## V0.0.1
### [X] remove foundation package
Makes working with packages hard, and give less flexibility regarding packages version

### [X] remove form
The package as not been developed yet and we will use reactive_forms instead

### [X] remove navigation service
This package just re-export go_router, it doesn't bring value and it has maintenance cost.

### [ ] migrate to the new architecture
Update terminology and move to new standards

### [ ] use Result instead of exceptions
    - [X] auth
    - [X] firebase auth
    - [ ] onboarding 
    - [ ] query

### view model simplification
The ViewModel abstraction doesn't had value and introduce undocumented code that is hard to grasp for new developers
We will use Cubit directly instead.
The actual utils mixin for ViewModel changes for Cubit mixin instead
Bind widget will be removed in favor of the Provider package (not flutter_bloc, because its gave use the option of using other ViewModel than cubit)

### Auth package cleanup
Refactor the code to better match the new code standards (mvvm)
UserService are confusing and overengeenred

### Refactor onboarding
Simplify and migrate to new code standards