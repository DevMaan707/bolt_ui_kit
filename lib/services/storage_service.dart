import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late final GetStorage _box;
  static const String _namespace = 'flutter_kit_storage';

  Future<StorageService> init() async {
    await GetStorage.init(_namespace);
    _box = GetStorage(_namespace);
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  bool hasKey(String key) {
    return _box.hasData(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }

  Future<void> writeObject(String key, Object value) async {
    try {
      final String jsonString = json.encode(value);
      await write(key, jsonString);
    } catch (e) {
      print('Error storing object: $e');
    }
  }

  T? readObject<T>(String key, T Function(Map<String, dynamic> json) fromJson) {
    try {
      final String? jsonString = read<String>(key);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return fromJson(jsonMap);
    } catch (e) {
      print('Error reading object: $e');
      return null;
    }
  }

  Future<void> writeObjectList<T>(
    String key,
    List<T> objects,
    dynamic Function(T obj) toJson,
  ) async {
    try {
      final List<dynamic> jsonList = objects.map((obj) => toJson(obj)).toList();
      final String jsonString = json.encode(jsonList);
      await write(key, jsonString);
    } catch (e) {
      print('Error storing object list: $e');
    }
  }

  List<T> readObjectList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    try {
      final String? jsonString = read<String>(key);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error reading object list: $e');
      return [];
    }
  }
}
