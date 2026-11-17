import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DatabaseService {
  Future<Connection> connectDatabase() async {
    final endpoint = Endpoint(
      host: dotenv.env['DB_HOST']!,
      database: dotenv.env['DB_NAME']!,
      username: dotenv.env['DB_USER']!,
      password: dotenv.env['DB_PASSWORD']!,
      port: int.parse(dotenv.env['DB_PORT'] ?? '5432'),
    );

    return Connection.open(
      endpoint,
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
  }
}
