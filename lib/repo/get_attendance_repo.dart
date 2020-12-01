import 'package:equitysoft_app/model/attendance.dart';
import 'package:equitysoft_app/util/api_provider.dart';
import 'package:flutter/material.dart';

class GetAttendanceRepo {

  GetAttendanceRepo._();

  static void fetchData({
    @required String id,
    @required ValueChanged<Attendance> onSuccess,
    @required ValueChanged<String> onError,
  }) async {
    ApiProvider().getCall(
        url: '$id.json',
        onSuccess: (success) {
          onSuccess(Attendance.fromJson(success));
        },
        onError: (error) => onError(error)
    );
  }
}
