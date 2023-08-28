import 'package:affordant_view_model/affordant_view_model.dart';
import 'auth_service.dart';
import 'di.dart';

final class AuthViewModel extends ViewModel<User?> with Observer2, Auth {
  AuthViewModel() : super(null) {
    forEach(auth.authStateChanges, onData: (user) => user);
  }

  void signOut() {
    auth.signOut();
  }
}
