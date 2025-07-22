# kv_storage_shared_preferences

![coverage: xx%](https://img.shields.io/badge/coverage-91-green)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: PolyForm Free Trial](https://img.shields.io/badge/License-PolyForm%20Free%20Trial-blue)](https://polyformproject.org/licenses/free-trial/1.0.0)


A Flutter implementation of the `KVStorageService` interface using the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package.

This package provides a persistent key-value storage mechanism suitable for simple data, wrapping the `shared_preferences` plugin with a defined interface and robust error handling based on the `kv_storage_service` contract.

## Features

*   Implements the `KVStorageService` interface.
*   Uses `shared_preferences` for underlying storage on Android, iOS, Linux, macOS, Web, and Windows.
*   Provides methods for reading and writing `String`, `bool`, `int`, and `double` values.
*   Includes methods for deleting specific keys (`delete`) and clearing all data (`clearAll`).
*   Throws specific `StorageException` subtypes (e.g., `StorageWriteException`, `StorageReadException`, `StorageTypeMismatchException`) as defined in `kv_storage_service`.
*   Uses a singleton pattern (`getInstance`) for easy access to the storage instance.

## Getting started

This package depends on the `kv_storage_service` interface, which needs to be available in your project.

## Installation


```yaml
dependencies:
  kv_storage_shared_preferences:
    git:
      url: https://github.com/flutter-news-app-full-source-code/kv-storage-shared-preferences.git
      ref: main
  kv_storage_service:
    git:
      url: https://github.com/flutter-news-app-full-source-code/kv-storage-service.git
      ref: main
```

Then run `flutter pub get`.

## Usage

First, obtain an instance of the storage service. It's recommended to do this once during your app's initialization phase.

```dart
// Import the service interface AND the key definitions
import 'package:kv_storage_service/kv_storage_service.dart';
// Import the concrete implementation for initialization
import 'package:kv_storage_shared_preferences/kv_storage_shared_preferences.dart';

late KVStorageService storageService;

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Get the singleton instance
    storageService = await KVStorageSharedPreferences.getInstance();
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

The tests utilize `mocktail` to mock the `SharedPreferences` dependency, ensuring the logic within `KVStorageSharedPreferences` is tested in isolation.


## 🔑 Licensing

This package is source-available and licensed under the [PolyForm Free Trial 1.0.0](LICENSE). Please review the terms before use.

For commercial licensing options that grant the right to build and distribute unlimited applications, please visit the main [**Flutter News App - Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code) organization.
