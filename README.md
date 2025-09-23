<div align="center">
  <img src="https://avatars.githubusercontent.com/u/202675624?s=400&u=dc72a2b53e8158956a3b672f8e52e39394b6b610&v=4" alt="Flutter News App Toolkit Logo" width="220">
  <h1>KV Storage SharedPreferences</h1>
  <p><strong>A Flutter implementation of the `KVStorageService` interface using the `shared_preferences` package for the Flutter News App Toolkit.</strong></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/coverage-91%25-green?style=for-the-badge" alt="coverage: 91%">
  <a href="https://flutter-news-app-full-source-code.github.io/docs/"><img src="https://img.shields.io/badge/LIVE_DOCS-VIEW-slategray?style=for-the-badge" alt="Live Docs: View"></a>
  <a href="https://github.com/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/MAIN_PROJECT-BROWSE-purple?style=for-the-badge" alt="Main Project: Browse"></a>
</p>

This `kv_storage_shared_preferences` package provides a concrete Flutter implementation of the `KVStorageService` interface within the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). It leverages the popular `shared_preferences` package to offer a persistent key-value storage mechanism suitable for simple data across Android, iOS, Linux, macOS, Web, and Windows platforms. This package wraps the underlying `shared_preferences` plugin with a defined interface and robust error handling based on the `kv_storage_service` contract, ensuring consistent and reliable local data management.

## ⭐ Feature Showcase: Cross-Platform Persistent Storage

This package offers a comprehensive set of features for managing local key-value data using `shared_preferences`.

<details>
<summary><strong>🧱 Core Functionality</strong></summary>

### 🚀 `KVStorageService` Implementation
- **`KVStorageSharedPreferences` Class:** A concrete implementation of the `KVStorageService` interface, providing a standardized way to interact with `shared_preferences`.
- **Cross-Platform Support:** Utilizes `shared_preferences` for underlying storage, supporting Android, iOS, Linux, macOS, Web, and Windows.
- **Singleton Access:** Provides a convenient singleton pattern (`getInstance`) for easy and consistent access to the storage instance throughout the application.

### 🌐 Comprehensive Data Operations
- **Read/Write Operations:** Implements methods for reading and writing `String`, `bool`, `int`, and `double` values.
- **Data Deletion:** Includes methods for deleting specific keys (`delete`) and clearing all stored data (`clearAll`).

### 🛡️ Standardized Error Handling
- **Custom `StorageException` Propagation:** Throws specific `StorageException` subtypes (e.g., `StorageWriteException`, `StorageReadException`, `StorageTypeMismatchException`, `StorageInitializationException`) as defined in `kv_storage_service`, ensuring predictable and consistent error management across the application layers.

### 💉 Interface-Driven Design
- **Decoupled Logic:** By implementing the `KVStorageService` interface, this package ensures that application logic remains decoupled from the specific `shared_preferences` implementation, allowing for future flexibility and testability.

> **💡 Your Advantage:** You get a meticulously designed, production-quality `shared_preferences` implementation that simplifies local data management, ensures type safety, provides robust error handling, and offers cross-platform compatibility. This package accelerates development by providing a solid foundation for persistent local data storage.

</details>

## 🔑 Licensing

This `kv_storage_shared_preferences` package is an integral part of the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). For comprehensive details regarding licensing, including trial and commercial options for the entire toolkit, please refer to the main toolkit organization page.
