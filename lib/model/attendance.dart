class Attendance {
  int s;
  String m;
  int pCount;
  int lCount;
  int aCount;
  List<Rs> rs;

  Attendance({this.s, this.m, this.pCount, this.lCount, this.aCount, this.rs});

  Attendance.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    m = json['m'];
    pCount = json['p_count'];
    lCount = json['l_count'];
    aCount = json['a_count'];
    if (json['rs'] != null) {
      rs = new List<Rs>();
      json['rs'].forEach((v) {
        rs.add(new Rs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['s'] = this.s;
    data['m'] = this.m;
    data['p_count'] = this.pCount;
    data['l_count'] = this.lCount;
    data['a_count'] = this.aCount;
    if (this.rs != null) {
      data['rs'] = this.rs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rs {
  String d;
  String s;

  Rs({this.d, this.s});

  Rs.fromJson(Map<String, dynamic> json) {
    d = json['d'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['d'] = this.d;
    data['s'] = this.s;
    return data;
  }
}