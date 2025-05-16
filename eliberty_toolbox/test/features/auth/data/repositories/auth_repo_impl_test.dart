import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eliberty_toolbox/core/errors/failures.dart';
import 'package:eliberty_toolbox/features/auth/data/datasources/auth_local_ds.dart';
import 'package:eliberty_toolbox/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:eliberty_toolbox/features/auth/data/models/user_model.dart';
import 'package:eliberty_toolbox/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:eliberty_toolbox/features/auth/errors/auth_failures.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  setUpAll(() {
    // Used to prevent crash on verify any
    registerFallbackValue(
      const UserModel(id: 'dummy', name: 'dummy', email: 'dummy@example.com'),
    );
  });
  late AuthRepoImpl repository;
  late MockAuthLocalDatasource mockLocalDatasource;
  late MockAuthRemoteDatasource mockRemoteDatasource;

  const testUserModel = UserModel(
    id: 'abc123',
    name: 'Patrick',
    email: 'test@example.com',
  );
  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    repository = AuthRepoImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
    );
  });

  group('login', () {
    const email = 'test@example.com';
    const password = 'password';

    test('should return User on successful login', () async {
      // arrange
      when(
        () => mockRemoteDatasource.login(email, password),
      ).thenAnswer((_) async => testUserModel);
      when(
        () => mockLocalDatasource.cacheUser(testUserModel),
      ).thenAnswer((_) async => {});

      // act
      final result = await repository.signInWithEmail(email, password);

      // assert
      expect(result, equals(Right(testUserModel)));
      verify(() => mockRemoteDatasource.login(email, password)).called(1);
      verify(() => mockLocalDatasource.cacheUser(testUserModel)).called(1);
    });

    test('should return InvalidCredentialsFailure on failed login', () async {
      // arrange
      when(
        () => mockRemoteDatasource.login(email, password),
      ).thenThrow(Exception('Invalid credentials'));

      // act
      final result = await repository.signInWithEmail(email, password);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Expected a failure, got success'),
      );
      verify(() => mockRemoteDatasource.login(email, password)).called(1);
      verifyNever(() => mockLocalDatasource.cacheUser(any()));
    });
  });

  group('getUserFromCache', () {
    test('should return User on successful cache retrieval', () async {
      // arrange
      when(
        () => mockLocalDatasource.getCachedUser(),
      ).thenAnswer((_) async => testUserModel);

      // act
      final result = await repository.getUserFromCache();

      // assert
      expect(result, equals(Right(testUserModel)));
      verify(() => mockLocalDatasource.getCachedUser()).called(1);
    });

    test('should return CacheFailure when no user found', () async {
      // arrange
      when(
        () => mockLocalDatasource.getCachedUser(),
      ).thenAnswer((_) async => null);

      // act
      final result = await repository.getUserFromCache();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a failure, got success'),
      );
      verify(() => mockLocalDatasource.getCachedUser()).called(1);
    });
  });
  group('logout', () {
    test('should return Right(Unit) when cache cleared successfully', () async {
      // arrange
      when(
        () => mockLocalDatasource.clearCachedUser(),
      ).thenAnswer((_) async => {});

      // act
      final result = await repository.signOut();

      // assert
      expect(result, equals(const Right(unit)));
      verify(() => mockLocalDatasource.clearCachedUser()).called(1);
    });

    test('should return CacheFailure when clearing cache fails', () async {
      // arrange
      when(
        () => mockLocalDatasource.clearCachedUser(),
      ).thenThrow(Exception('Cache clear error'));

      // act
      final result = await repository.signOut();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a failure, got success'),
      );
      verify(() => mockLocalDatasource.clearCachedUser()).called(1);
    });
  });
}

// The above code is a test suite for the AuthRepoImpl class, which implements the AuthRepo interface.
