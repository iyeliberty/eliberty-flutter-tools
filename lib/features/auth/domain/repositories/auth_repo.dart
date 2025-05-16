import 'package:dartz/dartz.dart';
import 'package:eliberty_flutter_tools/core/errors/failures.dart';
import 'package:eliberty_flutter_tools/features/auth/domain/entities/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> getUserFromCache();
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
    String endpoint,
  );
  Future<Either<Failure, Unit>> signOut();
}
