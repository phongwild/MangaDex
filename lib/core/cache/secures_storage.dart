import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true)
);

Future<void> writeSecureData(String key, String value) async {
  await storage.write(key: key, value: value);
}

Future<String?> readSecureData(String key) async {
  return await storage.read(key: key);
}

Future<void> deleteSecureData(String key) async {
  await storage.delete(key: key);
}

Future<void> deleteAllSecureData() async {
  await storage.deleteAll();
}