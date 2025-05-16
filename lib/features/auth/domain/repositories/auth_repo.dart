import 'package:dartz/dartz.dart';
import 'package:eliberty_toolbox/core/errors/failures.dart';
import 'package:eliberty_toolbox/features/auth/domain/entities/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> getUserFromCache();
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, Unit>> signOut();
}
