import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
  static const ROOT = 'http://192.168.101.8/roberts.php';
  static const _GET_ALL_INFO_ACTION = 'GET_ALL_INFO';
  static const _GET_USE_ACTION = 'GET_USE';
  static const _GET_EMAIL_ACTION = 'GET_EMAIL';
  static const _ADD_EMAIL_ACTION = 'ADD_EMAIL';
  static const _UPDATE_EMAIL_ACTION = 'UPDATE_EMAIL';
  static const _DELETE_EMAIL_ACTION = 'DELETE_EMAIL';
  static const _GET_TIMER_ACTION = 'GET_TIMER';
  static const _UPDATE_TIMER_START_ACTION = 'UPDATE_TIMER_START';
  static const _UPDATE_USE_ACTION = 'UPDATE_USE';
  static const _CALC_PRICE_ACTION = 'CALC_PRICE';

  // _GET_ALL

  static Future<String> getAllInfo(String id_no) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_INFO_ACTION;
    map['id_no'] = id_no;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    return data;
  }

  static Future<String> getUseSimple(String id_no) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_USE_ACTION;
    map['id_no'] = id_no;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    return data;
  }

  static Future<String> getTimer(String email) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_TIMER_ACTION;
    map['email'] = email;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    return data;
  }

  static Future<String> updateTimerStart(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_TIMER_START_ACTION;
      map['email'] = email;
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> getEmail(String email) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _GET_EMAIL_ACTION;
    map['email'] = email;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    return data;
  }

  static Future<String> addEmail(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMAIL_ACTION;
      map['email'] = email;

      final response = await http.post(Uri.parse(ROOT), body: map);

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> updateEmail(
    String email_new,
    String email_old,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMAIL_ACTION;
      map['email_new'] = email_new;
      map['email_old'] = email_old;
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> deleteEmail(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMAIL_ACTION;
      map['email'] = email;
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
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
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> calcPrice(String timeSpent, String id_no) async {
    String data;
    var map = Map<String, dynamic>();
    map['action'] = _CALC_PRICE_ACTION;
    map['timeSpent'] = timeSpent;
    map['id_no'] = id_no;
    var response = await http.post(Uri.parse(ROOT), body: map);
    data = response.body.toString();
    return data;
  }
}
