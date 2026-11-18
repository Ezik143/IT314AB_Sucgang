import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseService {
  static Connection? _sharedConnection;

  Future<Connection> connectDatabase() async {
    if (_sharedConnection != null && _sharedConnection!.isOpen) {
      return _sharedConnection!;
    }

    final endpoint = Endpoint(
      host: dotenv.env['DB_HOST']!,
      database: dotenv.env['DB_NAME']!,
      username: dotenv.env['DB_USER']!,
      password: dotenv.env['DB_PASSWORD']!,
      port: int.parse(dotenv.env['DB_PORT'] ?? '5432'),
    );

    _sharedConnection = await Connection.open(
      endpoint,
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
    return _sharedConnection!;
  }

  Future<bool> testConnection() async {
    try {
      final connection = await connectDatabase();
      await connection.execute('SELECT 1');
      return true;
    } catch (_) {
      if (_sharedConnection != null) {
        await _sharedConnection!.close();
        _sharedConnection = null;
      }
      return false;
    }
  }
}
