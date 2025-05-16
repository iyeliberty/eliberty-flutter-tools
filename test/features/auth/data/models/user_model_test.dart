import 'package:flutter_test/flutter_test.dart';
import 'package:eliberty_flutter_tools/features/auth/data/models/user_model.dart';

void main() {
  const userModel = UserModel(
    id: '123',
    name: 'Patrick',
    email: 'patrick@example.com',
  );

  const userMap = {
    'id': '123',
    'name': 'Patrick',
    'email': 'patrick@example.com',
  };

  group('UserModel', () {
    test('fromJson should return a valid model', () {
      // act
      final result = UserModel.fromJson(userMap);

      // assert
      expect(result, equals(userModel));
    });

    test('toJson should return a valid map', () {
      // act
      final result = userModel.toJson();

      // assert
      expect(result, equals(userMap));
    });
  });
}
