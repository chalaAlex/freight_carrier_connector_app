import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenLocalDataSourceImpl implements TokenLocalDataSource {
  final FlutterSecureStorage storage;

  TokenLocalDataSourceImpl(this.storage);

  static const _key = 'access_token';

  @override
  Future<void> saveToken(String token) =>
      storage.write(key: _key, value: token);

  @override
  Future<String?> getToken() =>
      storage.read(key: _key);

  @override
  Future<void> clearToken() =>
      storage.delete(key: _key);
}
