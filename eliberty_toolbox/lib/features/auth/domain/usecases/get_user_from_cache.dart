import 'package:dartz/dartz.dart';
import 'package:eliberty_toolbox/features/auth/domain/repositories/auth_repo.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

class GetUserFromCache {
  final AuthRepo repository;

  GetUserFromCache(this.repository);

  Future<Either<Failure, User>> call() async {
    return repository.getUserFromCache();
  }
}
