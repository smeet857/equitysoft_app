import 'attendance.dart';

class StudentAttendance {
  String id;
  Attendance attendance;

  StudentAttendance({this.id, this.attendance});

  StudentAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attendance != null) {
      data['attendance'] = this.attendance.toJson();
    }
    return data;
  }
}