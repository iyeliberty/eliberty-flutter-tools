import 'package:dartz/dartz.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/repositories/auth_repo.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

class SignInWithEmail {
  final AuthRepo repository;

  SignInWithEmail(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String endpoint,
  }) async {
    return repository.signInWithEmail(email, password, endpoint);
  }
}
