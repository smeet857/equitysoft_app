class Student {
  int s;
  String m;
  List<Rs> rs;

  Student({this.s, this.m, this.rs});

  Student.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    m = json['m'];
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
    if (this.rs != null) {
      data['rs'] = this.rs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rs {
  String id;
  String name;

  Rs({this.id, this.name});

  Rs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}