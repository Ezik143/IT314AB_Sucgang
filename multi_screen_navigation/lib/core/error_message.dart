import 'package:postgres/postgres.dart';

/// Converts low-level database errors into messages that are safe and useful
/// to show in the UI.
String friendlyError(Object error) {
  if (error is ServerException) {
    switch (error.constraintName) {
      case 'uq_student_email':
        return 'A student with this email address already exists.';
      case 'uq_student_student_number':
        return 'A student with this student number already exists.';
      case 'uq_subject_subject_code':
        return 'A subject with this subject code already exists.';
      case 'uq_grades_enrollment_id':
        return 'This enrollment already has a grade. Edit the existing grade instead.';
      case 'chk_grades_grade_value':
        return 'Grade must be between 1.00 and 5.00.';
      case 'chk_subject_units':
        return 'Units must be between 1 and 12.';
      case 'chk_student_year_level':
        return 'Year level must be between 1 and 4.';
      case 'chk_schedule_time':
        return 'End time must be later than the start time.';
      case 'chk_schedule_day':
        return 'Day must be Monday to Sunday.';
      case 'chk_schedule_slot_capacity':
        return 'Slot capacity must be greater than zero.';
      case 'uq_enrollment_student_subject':
        return 'The student is already enrolled in this subject.';
    }

    switch (error.code) {
      case '23505':
        return 'This record already exists.';
      case '23503':
        return 'This record is still referenced by other records.';
      case '23514':
        return 'The values entered violate a database rule.';
      case '22P02':
      case '22007':
        return 'One of the values entered has an invalid format.';
    }
  }
  return error.toString();
}
