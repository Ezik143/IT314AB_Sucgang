import 'package:my_first_flutter_app/Models/student.dart';

/// Students in their original (insertion) order.
///
/// This list is deliberately unsorted so we can demonstrate how Dart
/// reorders items inside a `List`.
const List<Student> _studentsInOriginalOrder = [
  Student(
    imagePath: 'asset/images/Cat.jpg',
    name: 'John the Cat',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Watching football',
    studentId: '2021-001',
    email: 'john.the.cat@student.edu',
    favoriteSubject: 'Mathematics',
  ),
  Student(
    imagePath: 'asset/images/cat2.jpg',
    name: 'Mittens',
    course: 'BSIT',
    yearLevel: '2nd Year',
    age: 20,
    hobby: 'Playing with yarn',
    studentId: '2021-002',
    email: 'mittens@student.edu',
    favoriteSubject: 'Physics',
  ),
  Student(
    imagePath: 'asset/images/cat3.jpg',
    name: 'Whiskers',
    course: 'BSCS',
    yearLevel: '1st Year',
    age: 19,
    hobby: 'Sleeping in boxes',
    studentId: '2021-003',
    email: 'whiskers@student.edu',
    favoriteSubject: 'Computer Science',
  ),
  Student(
    imagePath: 'asset/images/cat4.jpg',
    name: 'Shadow',
    course: 'BSIS',
    yearLevel: '4th Year',
    age: 22,
    hobby: 'Chasing laser pointers',
    studentId: '2021-004',
    email: 'shadow@student.edu',
    favoriteSubject: 'Information Systems',
  ),
  Student(
    imagePath: 'asset/images/cat5.jpg',
    name: 'Milo',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Bird watching',
    studentId: '2021-005',
    email: 'milo@student.edu',
    favoriteSubject: 'Mathematics',
  ),
  Student(
    imagePath: 'asset/images/cat2.jpg',
    name: 'New Student',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'New hobby',
    studentId: '2021-006',
    email: 'new.student@student.edu',
    favoriteSubject: 'Statistics',
  ),
];

/// Students sorted alphabetically by name.
///
/// Dart's [`List.sort`](https://api.dart.dev/stable/dart-core/List/sort.html)
/// rearranges the items inside the list **in place** using a comparison
/// function. To avoid mutating the original insertion order, we first copy
/// the base list with `List.of(...)`, then sort the copy with a comparator
/// that compares each student's `name`.
final List<Student> students = List.of(_studentsInOriginalOrder)
  ..sort((a, b) => a.name.compareTo(b.name));