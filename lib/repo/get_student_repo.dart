import 'package:equitysoft_app/model/student.dart';
import 'package:equitysoft_app/util/api_provider.dart';
import 'package:flutter/material.dart';

class GetStudentRepo {

  GetStudentRepo._();

  static void fetchData({
    @required ValueChanged<Student> onSuccess,
    @required ValueChanged<String> onError,
  }) async {
    ApiProvider().getCall(
        url: 'getstudentList.json',
        onSuccess: (success) {
            onSuccess(Student.fromJson(success));
        },
        onError: (error) => onError(error)
    );
  }
}
