import 'package:dartz/dartz.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/repositories/auth_repo.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

class SignInWithEmail {
  final AuthRepo repository;

  SignInWithEmail(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return repository.signInWithEmail(email, password);
  }
}
