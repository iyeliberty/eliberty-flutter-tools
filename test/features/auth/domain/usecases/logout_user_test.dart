import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/usecases/sign_out.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/repositories/auth_repo.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late SignOut usecase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = SignOut(mockAuthRepo);
  });

  test('should call AuthRepo.logout and return Unit', () async {
    // arrange
    when(
      () => mockAuthRepo.signOut(),
    ).thenAnswer((_) async => const Right(unit));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(unit)));
    verify(() => mockAuthRepo.signOut()).called(1);
  });
}
