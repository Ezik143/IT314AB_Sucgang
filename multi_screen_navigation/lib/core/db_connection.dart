import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:multi_screen_navigation/Models/student.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  Connection? _connection;

  Future<Connection> getConnection() async {
    if (_connection != null) {
      return _connection!;
    }

    _connection = await _openConnection();
    return _connection!;
  }

  Future<Connection> _openConnection() async {
    final host = dotenv.env['DB_HOST'];
    final database = dotenv.env['DB_NAME'];
    final username = dotenv.env['DB_USER'];
    final password = dotenv.env['DB_PASSWORD'];
    final port = int.tryParse(dotenv.env['DB_PORT'] ?? '5432') ?? 5432;

    if ([
      host,
      database,
      username,
      password,
    ].any((value) => value == null || value.isEmpty)) {
      throw StateError(
        'Database configuration is incomplete. Set DB_HOST, DB_NAME, '
        'DB_USER, and DB_PASSWORD in .env.',
      );
    }

    return Connection.open(
      Endpoint(
        host: host!,
        database: database!,
        username: username!,
        password: password!,
        port: port,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
  }

  Future<List<Student>> fetchStudents() async {
    final connection = await getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT student_id, name, year_level, course, email, hobby,
               favorite_subject, status
        FROM students
        ORDER BY student_id
      '''),
    );
    return result
        .map(
          (row) =>
              Student.fromRow(Map<String, dynamic>.from(row.toColumnMap())),
        )
        .toList();
  }

  Future<void> addStudent({
    required String studentId,
    required String name,
    required int yearLevel,
    required String course,
    required String email,
  }) async {
    final connection = await getConnection();
    await connection.execute(
      Sql.named('''
        INSERT INTO students (student_id, name, year_level, course, email)
        VALUES (@studentId, @name, @yearLevel, @course, @email)
      '''),
      parameters: {
        'studentId': studentId,
        'name': name,
        'yearLevel': yearLevel,
        'course': course,
        'email': email,
      },
    );
  }
}
