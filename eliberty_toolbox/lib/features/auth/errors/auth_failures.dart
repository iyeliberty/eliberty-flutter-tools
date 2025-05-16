import '../../../../core/errors/failures.dart';

class AuthFailure extends Failure {
  AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  InvalidCredentialsFailure() : super('Email ou mot de passe non valide.');
}
