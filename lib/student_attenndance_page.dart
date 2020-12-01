import 'dart:convert';

import 'package:date_util/date_util.dart';
import 'package:equitysoft_app/model/attendance.dart';
import 'package:equitysoft_app/model/student.dart';
import 'package:equitysoft_app/repo/get_student_repo.dart';
import 'package:equitysoft_app/util/common_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'model/student_attendance.dart';

class StudentAttendancePage extends StatefulWidget {
  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Student student;
  bool isFetching = true;
  String loadingStatus = "Fetching Students....";
  List<StudentAttendance> listStudentAttendance;

  void fetchStudent() async {
    if (!await isInternetConnected()) {
      snackBarAlert(_scaffoldKey, "No internet connection");
    } else {
      setState(() {
        isFetching = true;
      });
      GetStudentRepo.fetchData(onSuccess: (object) async {
        if (object.s == 1) {
          student = object;
          setState(() {
            loadingStatus = "Fetching Attendance....";
          });
          await fetchAttendance();
        } else {
          setState(() {
            isFetching = false;
          });
          snackBarAlert(_scaffoldKey, object.m);
        }
      }, onError: (error) {
        setState(() {
          isFetching = false;
        });
        snackBarAlert(_scaffoldKey, "Data fetch fail");
        print("api student error ===> $error");
      });
    }
  }

  Future<void> fetchAttendance() async {
    listStudentAttendance = List<StudentAttendance>();
    for (var i in student.rs) {
      try {
        var result = await get(
            "https://equitysofttechnologies.com/practical/${i.id}.json");
        var attendance = Attendance.fromJson(jsonDecode(result.body));
        if (attendance.s == 1) {
          var sa = StudentAttendance();
          sa.id = i.id;
          sa.attendance = attendance;
          listStudentAttendance.add(sa);
        } else {
          snackBarAlert(_scaffoldKey, attendance.m);
        }
      } catch (error) {
        setState(() {
          isFetching = false;
        });
        print("error on attendance api ===> $error");
        break;
      }
      if (i.id == student.rs[student.rs.length - 1].id) {
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }

  @override
  Widget build(BuildContext context) {
    final novDaysCount = DateUtil().daysInMonth(DateTime.september, 2020);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text("Student Attendance"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                fetchStudent();
              })
        ],
      ),
      body: isFetching
          ? Center(
              child: loadingView(),
            )
          :
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        student.rs.length + 1,
                        (index) => Container(
                          color: index == 0 ? Colors.black12 : null,
                          alignment: Alignment.center,
                          width: 120.0,
                          height: 60.0,
                          child: index > 0
                              ? Text(
                                  student.rs[index - 1].name,
                            textAlign: TextAlign.center,
                                )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sep 2020",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Students",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          student.rs.length + 1,
                          (pos) {
                            return Row(
                              children: List.generate(
                                novDaysCount,
                                    (index) {
                                      return Container(
                                        color: pos == 0 ? Colors.black12 : null,
                                        alignment: Alignment.center,
                                        width: 60.0,
                                        height: 60.0,
                                        child: pos > 0
                                            ? Text(
                                          getStatus(index +1, listStudentAttendance[pos -1].attendance),
                                        )
                                            : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getWeekName(index + 1),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10,),
                                            Text(
                                              index+1 <= 9 ? "0${index +1}":"${index +1}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget loadingView(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 10,),
        Text(loadingStatus)
      ],
    );
  }
  String getStatus(int day ,Attendance attendance){
    String str = "-";
    var date = DateTime(2020,9,day);
    for(var i in attendance.rs){
      var date2 = DateTime.parse(i.d);
      print("date===> ${date2.day}/${date2.month}/${date2.year}");

      if(date.day == date2.day){
        str = i.s;
        break;
      }
    }
    return str;
  }
  String getWeekName(int day) {
    var dateTime = DateTime(2020, 9, day);
    var formatWeek = DateFormat("EEE");
    String str = formatWeek.format(dateTime);
    return str;
  }
}
