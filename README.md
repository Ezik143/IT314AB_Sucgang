# IT314AB Final Project — Student Management System

A Flutter (Android/Windows) student management system backed by a **Neon PostgreSQL** database. The app is a continuation of the CTF 1–8 activities and follows the **MVVM** pattern (Model · Repository · ViewModel · View).

## Modules

| Module | List | Create | Read | Update | Delete |
|---|---|---|---|---|---|
| Students | `StudentListPage` (search) | `AddStudentPage` | `StudentDetailsPage` | `EditStudentPage` | Soft delete |
| Subjects | `SubjectListPage` | `AddSubjectPage` | `SubjectDetailsPage` (incl. its schedules) | `EditSubjectPage` | Marked unavailable |
| Schedules | `ScheduleListPage` | `AddSchedulePage` | `ScheduleDetailsPage` | `EditSchedulePage` | Delete |
| Enrollments | `EnrollmentListPage` (search) | `AddEnrollmentPage` | `EnrollmentDetailsPage` | `EditEnrollmentPage` | Drop (status update) |
| Grades | `GradeListPage` (search) | `AddGradePage` | `GradeDetailsPage` | `EditGradePage` | Delete |

Business rules enforced before an enrollment is written:

- The student must exist, the subject must be available and the schedule must belong to that subject.
- A student cannot be enrolled twice in the same subject.
- A schedule's slot capacity cannot be exceeded.
- A student cannot hold two overlapping schedules on the same day.
- A dropped enrollment is reactivated instead of duplicated when the student re-enrolls (the database keeps a unique `(student_id, subject_id)` pair).
- A grade can only be attached to an existing `Enrolled` record and must be between 1.00 and 5.00.

## Architecture

```
lib/
  core/          db_connection.dart (shared SSL connection), error_message.dart, formatting.dart
  model/         plain Dart entities + row mapping
  repositories/  all SQL (parameterized with Sql.named)
  viewmodels/    state (ChangeNotifier): loading / error / data
  widgets/       pages and form fields — no SQL
```

- One shared `postgres` connection is reused by every repository (`DatabaseService`).
- SSL is required (`SslMode.require`).
- Every query uses named parameters; no user input is concatenated into SQL.
- The home screen runs a `SELECT 1` connection test and shows a retryable status card.

## Setup

1. Install Flutter (stable) and connect an Android device or enable Windows desktop.
2. Fetch dependencies:

   ```bash
   cd multi_screen_navigation
   flutter pub get
   ```

3. Create the credentials file (never commit it):

   ```bash
   cp dart_defines.example.json dart_defines.json
   ```

   Fill in the Neon host, database, user, password and port.

4. Run:

   ```bash
   flutter run --dart-define-from-file=dart_defines.json
   ```

   For a release build:

   ```bash
   flutter build apk --dart-define-from-file=dart_defines.json
   ```

   Credentials are injected at compile time, not bundled as an asset, and
   `dart_defines.json` is git-ignored.

   In VS Code, select the **multi_screen_navigation (debug)** launch
   configuration, which already passes `--dart-define-from-file`.

   If the home screen reports *Database connection failed*, it now shows the
   underlying error. The most common cause is launching without the
   `--dart-define-from-file=dart_defines.json` flag (credentials are then
   missing), followed by a suspended Neon instance or no internet.

> **Do not run on Flutter Web.** The `postgres` package needs raw TCP sockets;
> use Android or Windows desktop.

## Database

Five tables: `student`, `subject`, `schedule`, `enrollment`, `grades`, with
sequence-backed primary keys, `created_at`/`enrolled_at` defaults, FK
constraints between enrollments/grades and their parents, and CHECK/UNIQUE
constraints for grade range, units, year level, schedule times and student
email/number.

## Project status

- Branch: `feature/final_project`
- Static analysis: `flutter analyze` — no issues.
