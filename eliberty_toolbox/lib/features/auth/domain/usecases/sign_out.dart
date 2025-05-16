import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repo.dart';

class SignOut {
  final AuthRepo repository;

  SignOut(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return repository.signOut();
  }
}
