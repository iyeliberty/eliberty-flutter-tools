import '../models/user_model.dart';

class AuthRemoteDatasource {
  Future<UserModel> login(
    String email,
    String password,
    String endpoint,
  ) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Fake API response
    if (email == 'test@example.com' && password == 'password') {
      return UserModel(id: 'abc123', email: email, name: 'Patrick');
    } else {
      // Here we are just throwing a generic exception for simplicity
      // In a real-world scenario, you would throw specific exceptions based on the API response
      // For example, you might throw a NetworkException or an InvalidCredentialsException
      // depending on the error you receive from the API.

      throw Exception('Invalid credentials');
    }
    // TODO : Implement real login
    // try {
    //   final response = await http.post(
    //     Uri.parse(endpoint),
    //     body: {'email': email, 'password': password},
    //   );

    //   final statusCode = response.statusCode;

    //   if (statusCode >= 200 && statusCode < 300) {
    //     final data = jsonDecode(response.body);
    //     return Right(User(id: data['id'], email: data['email']));
    //   }

    //   // Gestion des erreurs HTTP
    //   switch (statusCode) {
    //     case 400:
    //       return Left(ClientFailure("Requête invalide"));
    //     case 401:
    //     case 403:
    //       return Left(AuthFailure("Identifiants incorrects"));
    //     case 404:
    //       return Left(ServerFailure("Endpoint introuvable"));
    //     case 500:
    //     default:
    //       return Left(ServerFailure("Erreur serveur ($statusCode)"));
    //   }
    // } catch (e) {
    //   return Left(ServerFailure("Exception : ${e.toString()}"));
    // }
  }
}
