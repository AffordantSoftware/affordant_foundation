import 'package:get_it/get_it.dart';

import 'auth_service.dart';

abstract class UserService<User> with Disposable {
  const UserService(this.authService);

  final AuthService<User> authService;

  User get user => authService.currentUser!;
}
