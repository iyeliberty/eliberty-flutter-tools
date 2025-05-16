import 'package:dartz/dartz.dart';
import 'package:eliberty_toolbox/features/auth/data/datasources/auth_local_ds.dart';
import 'package:eliberty_toolbox/features/auth/data/datasources/auth_remote_ds.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../../../core/errors/failures.dart';
import '../../errors/auth_failures.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;

  AuthRepoImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<Either<Failure, User>> getUserFromCache() async {
    final user = await localDatasource.getCachedUser();
    if (user != null) {
      return Right(user);
    } else {
      return Left(CacheFailure('No user found'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDatasource.login(email, password);
      await localDatasource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(InvalidCredentialsFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await localDatasource.clearCachedUser();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Logout failed'));
    }
  }
}
