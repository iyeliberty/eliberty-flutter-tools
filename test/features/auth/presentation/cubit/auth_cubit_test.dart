import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eliberty_flutter_tools/core/errors/failures.dart';
import 'package:eliberty_flutter_tools/features/auth/data/models/user_model.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/usecases/get_user_from_cache.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/usecases/sign_out.dart';
import 'package:eliberty_flutter_tools/features/auth/errors/auth_failures.dart';
import 'package:eliberty_flutter_tools/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:eliberty_flutter_tools/features/auth/presentation/cubit/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserFromCache extends Mock implements GetUserFromCache {}

class MockLoginUser extends Mock implements SignInWithEmail {}

class MockLogoutUser extends Mock implements SignOut {}

void main() {
  late MockGetUserFromCache mockGetUserFromCache;
  late MockLoginUser mockLoginUser;
  late MockLogoutUser mockLogoutUser;
  late AuthCubit authCubit;

  const testUser = UserModel(
    id: 'abc123',
    name: 'Patrick',
    email: 'test@example.com',
  );

  setUp(() {
    mockGetUserFromCache = MockGetUserFromCache();
    mockLoginUser = MockLoginUser();
    mockLogoutUser = MockLogoutUser();

    authCubit = AuthCubit(
      getUserFromCache: mockGetUserFromCache,
      loginUser: mockLoginUser,
      logoutUser: mockLogoutUser,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('checkAuthStatus', () {
    test(
      'should emit [AuthLoading, AuthAuthenticated] when user found',
      () async {
        when(
          () => mockGetUserFromCache(),
        ).thenAnswer((_) async => Right(testUser));

        final expected = [isA<AuthLoading>(), isA<AuthAuthenticated>()];

        expectLater(authCubit.stream, emitsInOrder(expected));

        authCubit.checkAuthStatus();
      },
    );

    test(
      'should emit [AuthLoading, AuthUnauthenticated] when no user found',
      () async {
        when(
          () => mockGetUserFromCache(),
        ).thenAnswer((_) async => Left(CacheFailure('No user found')));

        final expected = [isA<AuthLoading>(), isA<AuthUnauthenticated>()];

        expectLater(authCubit.stream, emitsInOrder(expected));

        authCubit.checkAuthStatus();
      },
    );
  });

  group('login', () {
    const email = 'test@example.com';
    const password = 'password';

    test('should emit [AuthLoading, AuthAuthenticated] on success', () async {
      when(
        () => mockLoginUser(email, password),
      ).thenAnswer((_) async => Right(testUser));

      final expected = [isA<AuthLoading>(), isA<AuthAuthenticated>()];

      expectLater(authCubit.stream, emitsInOrder(expected));

      authCubit.login(email, password);
    });

    test('should emit [AuthLoading, AuthError] on failure', () async {
      when(
        () => mockLoginUser(email, password),
      ).thenAnswer((_) async => Left(InvalidCredentialsFailure()));

      final expected = [isA<AuthLoading>(), isA<AuthError>()];

      expectLater(authCubit.stream, emitsInOrder(expected));

      authCubit.login(email, password);
    });
  });

  group('logout', () {
    test('should emit [AuthLoading, AuthUnauthenticated] on success', () async {
      when(() => mockLogoutUser()).thenAnswer((_) async => const Right(unit));

      final expected = [isA<AuthLoading>(), isA<AuthUnauthenticated>()];

      expectLater(authCubit.stream, emitsInOrder(expected));

      authCubit.logout();
    });

    test('should emit [AuthLoading, AuthError] on failure', () async {
      when(
        () => mockLogoutUser(),
      ).thenAnswer((_) async => Left(CacheFailure('Logout failed')));

      final expected = [isA<AuthLoading>(), isA<AuthError>()];

      expectLater(authCubit.stream, emitsInOrder(expected));

      authCubit.logout();
    });
  });
}
