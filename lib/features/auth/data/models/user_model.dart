import 'package:eliberty_flutter_tools/features/auth/domain/entities/user.dart';

import '../../../../core/storage/storable_model.dart';

class UserModel extends User implements StorableModel {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], name: json['name']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
