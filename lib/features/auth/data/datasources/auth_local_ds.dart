import '../../../../core/services/cache_service.dart';
import '../models/user_model.dart';

class AuthLocalDatasource {
  final CacheService cacheService;

  AuthLocalDatasource(this.cacheService);

  Future<UserModel?> getCachedUser() async {
    final userMap = cacheService.readModel('user');
    if (userMap != null) {
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> cacheUser(UserModel user) async {
    await cacheService.writeModel('user', user);
  }

  Future<void> clearCachedUser() async {
    await cacheService.removeKey('user');
  }
}
