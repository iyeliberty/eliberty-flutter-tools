import '../models/user_model.dart';

class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password) async {
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
  }
}
