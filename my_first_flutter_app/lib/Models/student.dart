import 'dart:ffi';

class Student {
  String imagePath;
  String name;
  String course;
  String yearLevel;
  int age;
  String hobby;
  String studentId;
  String email;
  String favoriteSubject;
  bool isFavorite;

  Student({
    required this.imagePath,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    required this.isFavorite,
  });
}
