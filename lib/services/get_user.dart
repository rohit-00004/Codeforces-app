import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

Future<Cfuser> fetchCfuser(String handle) async {
  String uri = "https://codeforces.com/api/user.info?handles=$handle";
  
  final response = await http.get(Uri.parse(uri));
  
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Cfuser.fromJson(jsonDecode(response.body)['result'][0]);
  } 
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    
    throw Exception('Enter a valid handle');
  }
}


