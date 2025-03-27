# ht_kv_storage_shared_preferences

A Flutter implementation of the `HtKVStorageService` interface using the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package.

This package provides a persistent key-value storage mechanism suitable for simple data, wrapping the `shared_preferences` plugin with a defined interface and robust error handling based on the `ht_kv_storage_service` contract.

## Features

*   Implements the `HtKVStorageService` interface.
*   Uses `shared_preferences` for underlying storage on Android, iOS, Linux, macOS, Web, and Windows.
*   Provides methods for reading and writing `String`, `bool`, `int`, and `double` values.
*   Includes methods for deleting specific keys (`delete`) and clearing all data (`clearAll`).
*   Throws specific `StorageException` subtypes (e.g., `StorageWriteException`, `StorageReadException`, `StorageTypeMismatchException`) as defined in `ht_kv_storage_service`.
*   Uses a singleton pattern (`getInstance`) for easy access to the storage instance.

## Getting started

This package depends on the `ht_kv_storage_service` interface, which needs to be available in your project.

## Installation


```yaml
dependencies:
  ht_kv_storage_shared_preferences:
    git:
      url: https://github.com/headlines-toolkit/ht-kv-storage-shared-preferences.git
      ref: main
  ht_kv_storage_service:
    git:
      url: https://github.com/headlines-toolkit/ht-kv-storage-service.git
      ref: main
```

Then run `flutter pub get`.

## Usage

First, obtain an instance of the storage service. It's recommended to do this once during your app's initialization phase.

```dart
// Import the service interface AND the key definitions
import 'package:ht_kv_storage_service/ht_kv_storage_service.dart';
// Import the concrete implementation for initialization
import 'package:ht_kv_storage_shared_preferences/ht_kv_storage_shared_preferences.dart';

late HtKVStorageService storageService;

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Get the singleton instance
    storageService = await HtKvStorageSharedPreferences.getInstance();
  } on StorageInitializationException catch (e) {
    // Handle initialization error (e.g., log, show error message)
    print('Failed to initialize storage: $e');
    // Potentially exit or fallback
    return;
  }

  runApp(MyApp());
}

// Example usage within a widget or service:
Future<void> markOnboardingComplete() async {
  try {
    // Use the key constant's string value
    await storageService.writeBool(
      key: StorageKey.hasSeenOnboarding.stringValue,
      value: true,
    );
    print('Onboarding status saved successfully.');
  } on StorageWriteException catch (e) {
    print('Failed to save onboarding status: $e');
  }
}

Future<bool> checkIfOnboardingComplete() async {
  try {
    // Use the key constant's string value
    // Default to false if not found
    final hasSeen = await storageService.readBool(
      key: StorageKey.hasSeenOnboarding.stringValue,
      defaultValue: false,
    );
    print('Onboarding seen: $hasSeen');
    return hasSeen;
  } on StorageReadException catch (e) {
    print('Failed to read onboarding status: $e');
    return false; // Assume not seen on error
  } on StorageTypeMismatchException catch (e) {
    print('Stored value for onboarding status is not a bool: $e');
    // Optionally delete the invalid entry
    // await storageService.delete(key: StorageKey.hasSeenOnboarding.stringValue);
    return false; // Assume not seen on type mismatch
  }
}

Future<void> resetOnboardingStatus() async {
  try {
    // Use the key constant's string value
    await storageService.delete(key: StorageKey.hasSeenOnboarding.stringValue);
    print('Onboarding status deleted.');
  } on StorageDeleteException catch (e) {
    print('Failed to delete onboarding status: $e');
  }
}
```

## Testing

This package includes a comprehensive suite of unit tests. To run the tests and check coverage:

```bash
very_good test --coverage --min-coverage 90
```

The tests utilize `mocktail` to mock the `SharedPreferences` dependency, ensuring the logic within `HtKvStorageSharedPreferences` is tested in isolation.
