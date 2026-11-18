import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

/// Reads database settings from compile-time `--dart-define` values.
///
/// Nothing is bundled as an asset, so credentials never ship inside the app
/// package. Provide them when running or building:
///
/// ```
/// flutter run --dart-define-from-file=dart_defines.json
/// ```
///
/// `dart_defines.example.json` shows the expected keys.
class DatabaseService {
  static const String _host = String.fromEnvironment('DB_HOST');
  static const String _name = String.fromEnvironment('DB_NAME');
  static const String _user = String.fromEnvironment('DB_USER');
  static const String _password = String.fromEnvironment('DB_PASSWORD');
  static const int _port = int.fromEnvironment('DB_PORT', defaultValue: 5432);

  static Connection? _sharedConnection;
  static Future<Connection>? _pendingConnection;

  /// Whether credentials were supplied at build time.
  static bool get isConfigured =>
      _host.isNotEmpty &&
      _name.isNotEmpty &&
      _user.isNotEmpty &&
      _password.isNotEmpty;

  /// Returns the single shared connection used by every repository.
  ///
  /// If a connection attempt is already in flight it is reused, so opening a
  /// screen that loads several lists at once does not open several sockets.
  Future<Connection> connectDatabase() async {
    final existing = _sharedConnection;
    if (existing != null && existing.isOpen) {
      return existing;
    }

    final pending = _pendingConnection;
    if (pending != null) {
      return pending;
    }

    final attempt = _openConnection();
    _pendingConnection = attempt;
    try {
      return await attempt;
    } finally {
      _pendingConnection = null;
    }
  }

  Future<Connection> _openConnection() async {
    if (!isConfigured) {
      throw StateError(
        'Database credentials are missing. Run the app with '
        '--dart-define-from-file=dart_defines.json (see '
        'dart_defines.example.json).',
      );
    }

    final endpoint = Endpoint(
      host: _host,
      database: _name,
      username: _user,
      password: _password,
      port: _port,
    );

    final connection = await Connection.open(
      endpoint,
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
    _sharedConnection = connection;
    return connection;
  }

  /// The error from the most recent failed connection attempt, if any.
  static String? lastError;

  Future<bool> testConnection() async {
    lastError = null;
    // Neon suspends idle databases; the first attempt after a pause can fail
    // while the compute wakes up, so give it one more chance.
    for (var attempt = 1; attempt <= 2; attempt++) {
      try {
        final connection = await connectDatabase();
        await connection.execute('SELECT 1');
        lastError = null;
        return true;
      } catch (error) {
        lastError = error.toString();
        debugPrint('Database connection attempt $attempt failed: $error');
        await _resetConnection();
        if (attempt < 2) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }
      }
    }
    return false;
  }

  Future<void> _resetConnection() async {
    final connection = _sharedConnection;
    _sharedConnection = null;
    if (connection != null && connection.isOpen) {
      await connection.close();
    }
  }
}
