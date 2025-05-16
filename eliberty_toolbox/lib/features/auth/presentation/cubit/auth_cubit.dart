import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eliberty_toolbox/features/auth/domain/usecases/sign_out.dart';
import '../../domain/usecases/get_user_from_cache.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetUserFromCache getUserFromCache;
  final SignInWithEmail loginUser;
  final SignOut logoutUser;

  AuthCubit({
    required this.getUserFromCache,
    required this.loginUser,
    required this.logoutUser,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getUserFromCache();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUser(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUser();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
