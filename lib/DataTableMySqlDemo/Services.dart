import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Employee.dart';

class Services {
  //static const ROOT = 'http://localhost/Employees/roberts.php';
  static const ROOT = 'http://192.168.101.8/roberts.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_USE_ACTION = 'GET_USE';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _UPDATE_USE_ACTION = 'UPDATE_USE';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // _GET_ALL

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getEmployees REsponse: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        //return List<Employee>();
        return List.empty();
      }
    } catch (e) {
      //return List<Employee>(); // return empty list on exception/error
      return List.empty();
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

/* // šis GET_USE atgriež sarakstu
  static Future<List<Employee>> getUse(String id_no) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_USE_ACTION;
      map['id_no'] = id_no;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getEmployees REsponse: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        //return List<Employee>();
        return List.empty();
      }
    } catch (e) {
      //return List<Employee>(); // return empty list on exception/error
      return List.empty();
    }
  }
*/ // šis GET_USE atgriež single item string

  static Future<String> getUse(String id_no) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_USE_ACTION;
      map['id_no'] = id_no;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getEmployees REsponse body: ${response.body}');
      if (200 == response.statusCode) {
        //String status = parseSingleResponse(response.body);
        String status = response.toString();
        return status;
        //return response.body;
      } else {
        //return List<Employee>();
        return 'lol';
      }
    } catch (e) {
      //return List<Employee>(); // return empty list on exception/error
      return 'lol';
    }
  }

  static String parseSingleResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed;
  }

  static Future<String> getUseSimple(String id_no) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_USE_ACTION;
    map['id_no'] = id_no;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    //print('useSimple:');
    //print(response.body);
    return data;
  }

  static refreshData(String id_no) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_USE_ACTION;
    map['id_no'] = id_no;
    var result = await http.post(Uri.parse(ROOT), body: map);
    data = result.body.toString();
    if (data == '[{"in_use":"NN"}]') {
      print('šeit strādā');
    } else {
      print('šeit nestrādā');
    }
    return true;
  }
/*
  static String getInString(String id_no) {
    String data;
    data = refreshData(id_no).toString();
    print(data);
    //if(data )
    return 'lol';
  }
*/
  // return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
/*
  Future<MyUse> fetchMyUse(String id_no) async {
    var map = Map<String, dynamic>();
    map['action'] = _GET_USE_ACTION;
    map['id_no'] = id_no;
    final response = await http.post(Uri.parse(ROOT), body: map);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return MyUse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
*/
  // Method to add employee to the database...

  static Future<String> addEmployee(String in_use, String location) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['in_use'] = in_use;
      map['location'] = location;
      print('-- 3');
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('-- 4');
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // return empty list on exception/error
    }
  }

  // Method to update an Employee in Database..

  static Future<String> updateEmployee(
      String id_no, String in_use, String location) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id_no'] = id_no;
      map['in_use'] = in_use;
      map['location'] = location;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // return empty list on exception/error
    }
  }

  static Future<String> updateUse(
    String id_no,
    String in_use,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_USE_ACTION;
      map['id_no'] = id_no;
      map['in_use'] = in_use;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // return empty list on exception/error
    }
  }

  // Method to delete an Employee in Database..

  static Future<String> deleteEmployee(int id_no) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['id_no'] = id_no;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // return empty list on exception/error
    }
  }
}
