import 'package:kv_storage_service/kv_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template kv_storage_shared_preferences}
/// An implementation of [KVStorageService] using the `shared_preferences`
/// package.
///
/// This class provides a persistent key-value storage mechanism suitable for
/// simple data.
/// {@endtemplate}
class KVStorageSharedPreferences implements KVStorageService {
  /// Creates an instance with a provided [SharedPreferences] instance.
  ///
  /// Visible for testing purposes only.
  /// Allows injecting a mock SharedPreferences.
  /// Use [getInstance] for production code.
  @Deprecated('Use getInstance() for production code. Only for testing.')
  KVStorageSharedPreferences.test(SharedPreferences prefs) : _prefs = prefs {
    // Assign to the static instance for consistency if needed by tests,
    // though ideally tests should manage their own instances.
    _instance = this;
  }

  /// Private constructor to prevent direct instantiation.
  /// Use [getInstance] to obtain an instance.
  KVStorageSharedPreferences._(this._prefs);

  /// The underlying [SharedPreferences] instance.
  final SharedPreferences _prefs;

  /// A static instance variable to hold the singleton instance.
  static KVStorageSharedPreferences? _instance;

  /// Returns the singleton instance of [KVStorageSharedPreferences].
  ///
  /// Initializes the instance asynchronously if it hasn't been created yet.
  /// Throws a [StorageInitializationException] if initialization fails.
  static Future<KVStorageSharedPreferences> getInstance() async {
    if (_instance == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _instance = KVStorageSharedPreferences._(prefs);
      } catch (e) {
        // Consider logging the stackTrace here
        throw StorageInitializationException(
          message: 'Failed to initialize SharedPreferences.',
          cause: e,
        );
      }
    }
    return _instance!;
  }

  @override
  Future<void> writeString({required String key, required String value}) async {
    try {
      final success = await _prefs.setString(key, value);
      if (!success) {
        // Although setString usually returns true, handle the case where it
        // might indicate failure in some edge cases or future versions.
        throw StorageWriteException(key, value);
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageWriteException(key, value, cause: e);
    }
  }

  @override
  Future<String?> readString({required String key}) async {
    try {
      final value = _prefs.get(key);
      if (value == null) {
        return null; // Key not found
      }
      if (value is String) {
        return value;
      }
      throw StorageTypeMismatchException(key, String, value.runtimeType);
    } catch (e) {
      if (e is StorageTypeMismatchException) {
        rethrow; // Avoid wrapping known storage exceptions
      }
      // Consider logging the stackTrace here
      throw StorageReadException(key, cause: e);
    }
  }

  @override
  Future<void> writeBool({required String key, required bool value}) async {
    try {
      final success = await _prefs.setBool(key, value);
      if (!success) {
        throw StorageWriteException(key, value);
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageWriteException(key, value, cause: e);
    }
  }

  @override
  Future<bool> readBool({
    required String key,
    bool defaultValue = false,
  }) async {
    try {
      final value = _prefs.get(key);
      if (value == null) {
        return defaultValue; // Key not found, return default
      }
      if (value is bool) {
        return value;
      }
      throw StorageTypeMismatchException(key, bool, value.runtimeType);
    } catch (e) {
      if (e is StorageTypeMismatchException) {
        rethrow;
      }
      // Consider logging the stackTrace here
      throw StorageReadException(key, cause: e);
    }
  }

  @override
  Future<void> writeInt({required String key, required int value}) async {
    try {
      final success = await _prefs.setInt(key, value);
      if (!success) {
        throw StorageWriteException(key, value);
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageWriteException(key, value, cause: e);
    }
  }

  @override
  Future<int?> readInt({required String key}) async {
    try {
      final value = _prefs.get(key);
      if (value == null) {
        return null; // Key not found
      }
      if (value is int) {
        return value;
      }
      // SharedPreferences on some platforms might store ints as doubles
      if (value is double && value == value.toInt()) {
        return value.toInt();
      }
      throw StorageTypeMismatchException(key, int, value.runtimeType);
    } catch (e) {
      if (e is StorageTypeMismatchException) {
        rethrow;
      }
      // Consider logging the stackTrace here
      throw StorageReadException(key, cause: e);
    }
  }

  @override
  Future<void> writeDouble({required String key, required double value}) async {
    try {
      final success = await _prefs.setDouble(key, value);
      if (!success) {
        throw StorageWriteException(key, value);
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageWriteException(key, value, cause: e);
    }
  }

  @override
  Future<double?> readDouble({required String key}) async {
    try {
      final value = _prefs.get(key);
      if (value == null) {
        return null; // Key not found
      }
      if (value is double) {
        return value;
      }
      // SharedPreferences might store doubles as Strings or ints
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
      if (value is int) {
        return value.toDouble();
      }
      throw StorageTypeMismatchException(key, double, value.runtimeType);
    } catch (e) {
      if (e is StorageTypeMismatchException) {
        rethrow;
      }
      // Consider logging the stackTrace here
      throw StorageReadException(key, cause: e);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      // Check if key exists before attempting removal to potentially avoid
      // unnecessary exceptions on some platforms, though remove() itself
      // should ideally handle non-existent keys gracefully.
      // However, the contract allows for StorageKeyNotFoundException.
      // SharedPreferences.remove() returns true if successful, false otherwise.
      // It doesn't typically throw for non-existent keys.
      final success = await _prefs.remove(key);
      if (!success) {
        // This might indicate a more general failure if the key did exist.
        // If the key didn't exist, remove usually returns true.
        // We'll throw StorageDeleteException for consistency if remove fails.
        // Note: We don't throw StorageKeyNotFoundException here as remove()
        // doesn't distinguish between failure and key not found.
        throw StorageDeleteException(key, message: 'Failed to remove key.');
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageDeleteException(key, cause: e);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final success = await _prefs.clear();
      if (!success) {
        throw const StorageClearException();
      }
    } catch (e) {
      // Consider logging the stackTrace here
      throw StorageClearException(cause: e);
    }
  }
}
