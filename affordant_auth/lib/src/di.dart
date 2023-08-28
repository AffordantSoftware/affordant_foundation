import 'package:affordant_core/affordant_core.dart';
import 'auth_service.dart';

base mixin Auth on DependencyInjection {
  AuthService get auth => di.get();
}
