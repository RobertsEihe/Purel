class Employee {
  //String id_no;
  String in_use;
  String location;

  Employee(
      {/*required this.id_no,*/ required this.in_use, required this.location});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      //id_no: json['id_no'] as String,
      in_use: json['in_use'] as String,
      location: json['location'] as String,
    );
  }
}

/*

class MyUse {
  //String id_no;
  String in_use;
  String location;

  MyUse(
      {/*required this.id_no,*/ required this.in_use, required this.location});

  factory MyUse.fromJson(Map<String, dynamic> json) {
    return MyUse(
      //id_no: json['id_no'] as String,
      in_use: json['in_use'] as String,
      location: json['location'] as String,
    );
  }
}
 */