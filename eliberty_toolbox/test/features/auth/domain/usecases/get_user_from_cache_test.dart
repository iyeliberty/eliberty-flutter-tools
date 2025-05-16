import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eliberty_toolbox/features/auth/data/models/user_model.dart';
import 'package:eliberty_toolbox/features/auth/domain/repositories/auth_repo.dart';
import 'package:eliberty_toolbox/features/auth/domain/usecases/get_user_from_cache.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late GetUserFromCache usecase;

  const testUser = UserModel(
    id: 'abc123',
    name: 'Patrick',
    email: 'test@example.com',
  );

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = GetUserFromCache(mockAuthRepo);
  });

  test('should call AuthRepo.getUserFromCache and return User', () async {
    // arrange
    when(
      () => mockAuthRepo.getUserFromCache(),
    ).thenAnswer((_) async => Right(testUser));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(Right(testUser)));
    verify(() => mockAuthRepo.getUserFromCache()).called(1);
  });
}
