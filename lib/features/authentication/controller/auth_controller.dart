import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/features/authentication/model/auth_state.dart';
import 'package:conveneapp/features/authentication/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String nullUid = "nouser";
const String nullEmail = "nouser";

final currentUserController = StreamProvider<User>((ref) {
  return AuthApi().currentUser().map((user) => User(
        user?.uid ?? nullUid,
        user?.email ?? nullEmail,
      ));
});

final authStateController = Provider<AuthState>((ref) {
  final user = ref.watch(currentUserController);
  return user.when(
    data: (user) {
      if (user.uid == nullUid) {
        return AuthState.notAuthenticated;
      } else {
        return AuthState.authenticated;
      }
    },
    loading: () {
      return AuthState.unknown;
    },
    error: (err, stack) {
      return AuthState.notAuthenticated;
    },
  );
});
