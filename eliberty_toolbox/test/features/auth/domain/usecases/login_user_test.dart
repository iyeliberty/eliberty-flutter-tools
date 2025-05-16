import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eliberty_toolbox/features/auth/data/models/user_model.dart';
import 'package:eliberty_toolbox/features/auth/domain/repositories/auth_repo.dart';
import 'package:eliberty_toolbox/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late SignInWithEmail usecase;

  const testEmail = 'test@example.com';
  const testPassword = 'password';
  const testUser = UserModel(id: 'abc123', name: 'Patrick', email: testEmail);

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = SignInWithEmail(mockAuthRepo);

    registerFallbackValue(testUser); // For mocktail safety
  });

  test('should call AuthRepo.login and return User', () async {
    // arrange
    when(
      () => mockAuthRepo.signInWithEmail(testEmail, testPassword),
    ).thenAnswer((_) async => Right(testUser));

    // act
    final result = await usecase(testEmail, testPassword);

    // assert
    expect(result, equals(Right(testUser)));
    verify(
      () => mockAuthRepo.signInWithEmail(testEmail, testPassword),
    ).called(1);
  });
}
