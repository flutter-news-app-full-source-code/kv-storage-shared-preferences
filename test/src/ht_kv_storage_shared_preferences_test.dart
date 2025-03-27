// ignore_for_file: prefer_const_constructors, deprecated_member_use_from_same_package, lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:ht_kv_storage_service/ht_kv_storage_service.dart';
import 'package:ht_kv_storage_shared_preferences/src/ht_kv_storage_shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock SharedPreferences using mocktail
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(''); // for key
    registerFallbackValue(''); // for value (String)
    registerFallbackValue(0); // for value (int)
    registerFallbackValue(0.0); // for value (double)
    registerFallbackValue(false); // for value (bool)
  });

  group('HtKvStorageSharedPreferences', () {
    late MockSharedPreferences mockPrefs;
    late HtKvStorageSharedPreferences storage;

    // Test data
    const testKey = 'test_key';
    const testStringValue = 'test_value';
    const testBoolValue = true;
    const testIntValue = 123;
    const testDoubleValue = 123.45;
    final testException = Exception('Mock SharedPreferences Error');

    setUp(() {
      // Reset the singleton instance before each test
      // This is a bit hacky, ideally the singleton pattern would be more testable
      // or we'd rely solely on the test constructor.
      // Setting SharedPreferences.setMockInitialValues({}) helps reset the underlying static plugin instance.
      SharedPreferences.setMockInitialValues({});
      mockPrefs = MockSharedPreferences();
      // Use the test constructor for dependency injection
      storage = HtKvStorageSharedPreferences.test(mockPrefs);
    });

    // --- getInstance Tests ---
    // Note: Testing the static getInstance is tricky because it involves static
    // state and the actual SharedPreferences plugin. These tests might be
    // better suited as integration tests or require more complex setup.
    // We primarily rely on the test constructor for unit testing.
    // Basic check if it returns an instance (requires plugin setup)
    // test('getInstance returns an instance', () async {
    //   SharedPreferences.setMockInitialValues({'some_key': 'some_value'});
    //   final instance = await HtKvStorageSharedPreferences.getInstance();
    //   expect(instance, isA<HtKvStorageSharedPreferences>());
    // });
    // test('getInstance throws StorageInitializationException on failure', () async {
    //   // How to reliably mock SharedPreferences.getInstance() throwing is complex
    //   // and might depend on the plugin's internal implementation.
    //   // This test is omitted due to complexity in a pure unit test setup.
    // });

    // --- Write Operations ---
    group('writeString', () {
      test('completes successfully when setString succeeds', () async {
        when(
          () => mockPrefs.setString(testKey, testStringValue),
        ).thenAnswer((_) async => true);

        await expectLater(
          storage.writeString(key: testKey, value: testStringValue),
          completes,
        );
        verify(() => mockPrefs.setString(testKey, testStringValue)).called(1);
      });

      test(
        'throws StorageWriteException when setString returns false',
        () async {
          when(
            () => mockPrefs.setString(testKey, testStringValue),
          ).thenAnswer((_) async => false);

          await expectLater(
            storage.writeString(key: testKey, value: testStringValue),
            throwsA(isA<StorageWriteException>()),
          );
          verify(() => mockPrefs.setString(testKey, testStringValue)).called(1);
        },
      );

      test(
        'throws StorageWriteException with cause when setString throws exception',
        () async {
          when(
            () => mockPrefs.setString(testKey, testStringValue),
          ).thenThrow(testException);

          await expectLater(
            storage.writeString(key: testKey, value: testStringValue),
            throwsA(
              isA<StorageWriteException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
          verify(() => mockPrefs.setString(testKey, testStringValue)).called(1);
        },
      );
    });

    group('writeBool', () {
      test('completes successfully when setBool succeeds', () async {
        when(
          () => mockPrefs.setBool(testKey, testBoolValue),
        ).thenAnswer((_) async => true);
        await expectLater(
          storage.writeBool(key: testKey, value: testBoolValue),
          completes,
        );
        verify(() => mockPrefs.setBool(testKey, testBoolValue)).called(1);
      });

      test('throws StorageWriteException when setBool returns false', () async {
        when(
          () => mockPrefs.setBool(testKey, testBoolValue),
        ).thenAnswer((_) async => false);
        await expectLater(
          storage.writeBool(key: testKey, value: testBoolValue),
          throwsA(isA<StorageWriteException>()),
        );
      });

      test(
        'throws StorageWriteException with cause when setBool throws exception',
        () async {
          when(
            () => mockPrefs.setBool(testKey, testBoolValue),
          ).thenThrow(testException);
          await expectLater(
            storage.writeBool(key: testKey, value: testBoolValue),
            throwsA(
              isA<StorageWriteException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
        },
      );
    });

    group('writeInt', () {
      test('completes successfully when setInt succeeds', () async {
        when(
          () => mockPrefs.setInt(testKey, testIntValue),
        ).thenAnswer((_) async => true);
        await expectLater(
          storage.writeInt(key: testKey, value: testIntValue),
          completes,
        );
        verify(() => mockPrefs.setInt(testKey, testIntValue)).called(1);
      });

      test('throws StorageWriteException when setInt returns false', () async {
        when(
          () => mockPrefs.setInt(testKey, testIntValue),
        ).thenAnswer((_) async => false);
        await expectLater(
          storage.writeInt(key: testKey, value: testIntValue),
          throwsA(isA<StorageWriteException>()),
        );
      });

      test(
        'throws StorageWriteException with cause when setInt throws exception',
        () async {
          when(
            () => mockPrefs.setInt(testKey, testIntValue),
          ).thenThrow(testException);
          await expectLater(
            storage.writeInt(key: testKey, value: testIntValue),
            throwsA(
              isA<StorageWriteException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
        },
      );
    });

    group('writeDouble', () {
      test('completes successfully when setDouble succeeds', () async {
        when(
          () => mockPrefs.setDouble(testKey, testDoubleValue),
        ).thenAnswer((_) async => true);
        await expectLater(
          storage.writeDouble(key: testKey, value: testDoubleValue),
          completes,
        );
        verify(() => mockPrefs.setDouble(testKey, testDoubleValue)).called(1);
      });

      test(
        'throws StorageWriteException when setDouble returns false',
        () async {
          when(
            () => mockPrefs.setDouble(testKey, testDoubleValue),
          ).thenAnswer((_) async => false);
          await expectLater(
            storage.writeDouble(key: testKey, value: testDoubleValue),
            throwsA(isA<StorageWriteException>()),
          );
        },
      );

      test(
        'throws StorageWriteException with cause when setDouble throws exception',
        () async {
          when(
            () => mockPrefs.setDouble(testKey, testDoubleValue),
          ).thenThrow(testException);
          await expectLater(
            storage.writeDouble(key: testKey, value: testDoubleValue),
            throwsA(
              isA<StorageWriteException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
        },
      );
    });

    // --- Read Operations ---
    group('readString', () {
      test('returns value when key exists and value is String', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(testStringValue);
        final result = await storage.readString(key: testKey);
        expect(result, testStringValue);
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test('returns null when key does not exist', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(null);
        final result = await storage.readString(key: testKey);
        expect(result, isNull);
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test(
        'throws StorageTypeMismatchException when value is not String',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn(123); // Not a String
          await expectLater(
            storage.readString(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', String)
                  .having((e) => e.actualType, 'actualType', int),
            ),
          );
          verify(() => mockPrefs.get(testKey)).called(1);
        },
      );

      test('throws StorageReadException when get throws exception', () async {
        when(() => mockPrefs.get(testKey)).thenThrow(testException);
        await expectLater(
          storage.readString(key: testKey),
          throwsA(
            isA<StorageReadException>().having(
              (e) => e.cause,
              'cause',
              testException,
            ),
          ),
        );
        verify(() => mockPrefs.get(testKey)).called(1);
      });
    });

    group('readBool', () {
      test('returns value when key exists and value is bool', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(testBoolValue);
        final result = await storage.readBool(key: testKey);
        expect(result, testBoolValue);
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test(
        'returns defaultValue when key does not exist (default false)',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn(null);
          final result = await storage.readBool(key: testKey);
          expect(result, false); // Default value
          verify(() => mockPrefs.get(testKey)).called(1);
        },
      );

      test('returns provided defaultValue when key does not exist', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(null);
        final result = await storage.readBool(key: testKey, defaultValue: true);
        expect(result, true); // Provided default value
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test(
        'throws StorageTypeMismatchException when value is not bool',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn('not a bool');
          await expectLater(
            storage.readBool(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', bool)
                  .having((e) => e.actualType, 'actualType', String),
            ),
          );
        },
      );

      test('throws StorageReadException when get throws exception', () async {
        when(() => mockPrefs.get(testKey)).thenThrow(testException);
        await expectLater(
          storage.readBool(key: testKey),
          throwsA(
            isA<StorageReadException>().having(
              (e) => e.cause,
              'cause',
              testException,
            ),
          ),
        );
      });
    });

    group('readInt', () {
      test('returns value when key exists and value is int', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(testIntValue);
        final result = await storage.readInt(key: testKey);
        expect(result, testIntValue);
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test(
        'returns int value when key exists and value is double representing int',
        () async {
          when(
            () => mockPrefs.get(testKey),
          ).thenReturn(123.0); // Double representing int
          final result = await storage.readInt(key: testKey);
          expect(result, 123);
          verify(() => mockPrefs.get(testKey)).called(1);
        },
      );

      test('returns null when key does not exist', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(null);
        final result = await storage.readInt(key: testKey);
        expect(result, isNull);
      });

      test(
        'throws StorageTypeMismatchException when value is not int or compatible double',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn('not an int');
          await expectLater(
            storage.readInt(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', int)
                  .having((e) => e.actualType, 'actualType', String),
            ),
          );
        },
      );

      test(
        'throws StorageTypeMismatchException when value is double not representing int',
        () async {
          when(
            () => mockPrefs.get(testKey),
          ).thenReturn(123.45); // Double not representing int
          await expectLater(
            storage.readInt(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', int)
                  .having((e) => e.actualType, 'actualType', double),
            ),
          );
        },
      );

      test('throws StorageReadException when get throws exception', () async {
        when(() => mockPrefs.get(testKey)).thenThrow(testException);
        await expectLater(
          storage.readInt(key: testKey),
          throwsA(
            isA<StorageReadException>().having(
              (e) => e.cause,
              'cause',
              testException,
            ),
          ),
        );
      });
    });

    group('readDouble', () {
      test('returns value when key exists and value is double', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(testDoubleValue);
        final result = await storage.readDouble(key: testKey);
        expect(result, testDoubleValue);
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test('returns double value when key exists and value is int', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(testIntValue); // int
        final result = await storage.readDouble(key: testKey);
        expect(result, testIntValue.toDouble()); // Convert int to double
        verify(() => mockPrefs.get(testKey)).called(1);
      });

      test(
        'returns double value when key exists and value is String representing double',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn('123.45'); // String
          final result = await storage.readDouble(key: testKey);
          expect(result, 123.45);
          verify(() => mockPrefs.get(testKey)).called(1);
        },
      );

      test('returns null when key does not exist', () async {
        when(() => mockPrefs.get(testKey)).thenReturn(null);
        final result = await storage.readDouble(key: testKey);
        expect(result, isNull);
      });

      test(
        'throws StorageTypeMismatchException when value is not double or compatible type',
        () async {
          when(() => mockPrefs.get(testKey)).thenReturn(true); // bool
          await expectLater(
            storage.readDouble(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', double)
                  .having((e) => e.actualType, 'actualType', bool),
            ),
          );
        },
      );

      test(
        'throws StorageTypeMismatchException when value is String not representing double',
        () async {
          when(
            () => mockPrefs.get(testKey),
          ).thenReturn('not a double'); // String
          await expectLater(
            storage.readDouble(key: testKey),
            throwsA(
              isA<StorageTypeMismatchException>()
                  .having((e) => e.expectedType, 'expectedType', double)
                  .having((e) => e.actualType, 'actualType', String),
            ),
          );
        },
      );

      test('throws StorageReadException when get throws exception', () async {
        when(() => mockPrefs.get(testKey)).thenThrow(testException);
        await expectLater(
          storage.readDouble(key: testKey),
          throwsA(
            isA<StorageReadException>().having(
              (e) => e.cause,
              'cause',
              testException,
            ),
          ),
        );
      });
    });

    // --- Delete Operations ---
    group('delete', () {
      test('completes successfully when remove succeeds', () async {
        when(() => mockPrefs.remove(testKey)).thenAnswer((_) async => true);
        await expectLater(storage.delete(key: testKey), completes);
        verify(() => mockPrefs.remove(testKey)).called(1);
      });

      test('throws StorageDeleteException when remove returns false', () async {
        when(() => mockPrefs.remove(testKey)).thenAnswer((_) async => false);
        await expectLater(
          storage.delete(key: testKey),
          throwsA(isA<StorageDeleteException>()),
        );
        verify(() => mockPrefs.remove(testKey)).called(1);
      });

      test(
        'throws StorageDeleteException with cause when remove throws',
        () async {
          when(() => mockPrefs.remove(testKey)).thenThrow(testException);
          await expectLater(
            storage.delete(key: testKey),
            throwsA(
              isA<StorageDeleteException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
          verify(() => mockPrefs.remove(testKey)).called(1);
        },
      );
    });

    // --- Clear Operation ---
    group('clearAll', () {
      test('completes successfully when clear succeeds', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);
        await expectLater(storage.clearAll(), completes);
        verify(() => mockPrefs.clear()).called(1);
      });

      test('throws StorageClearException when clear returns false', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => false);
        await expectLater(
          storage.clearAll(),
          throwsA(isA<StorageClearException>()),
        );
        verify(() => mockPrefs.clear()).called(1);
      });

      test(
        'throws StorageClearException with cause when clear throws',
        () async {
          when(() => mockPrefs.clear()).thenThrow(testException);
          await expectLater(
            storage.clearAll(),
            throwsA(
              isA<StorageClearException>().having(
                (e) => e.cause,
                'cause',
                testException,
              ),
            ),
          );
          verify(() => mockPrefs.clear()).called(1);
        },
      );
    });
  });
}
