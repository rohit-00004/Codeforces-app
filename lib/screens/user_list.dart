import 'dart:convert';

import 'package:codeforces_vis/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({Key? key}) : super(key: key);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  
  Future<List<Cfuser>> fetchUserslist() async {
    String uri = "https://codeforces.com/api/user.ratedList?activeOnly=true";
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body)['result'];

      List<Cfuser> users = res.map((d) => Cfuser.fromJson(d)).toList();

      return users;
    } 
    else {
      throw Exception("Try again later");
    }
  }

  late Future<List<Cfuser>> userlist;

  @override
  void initState() {
    super.initState();
    userlist = fetchUserslist();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cfuser>>(
        future: userlist,
        builder: (context, allusers) {
          if (allusers.hasData) {
            return ActiveUsersList(users: allusers.data!);
          } 
          else if (allusers.hasError) {
            return Center(
              child: Text(allusers.error.toString()),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ActiveUsersList extends StatelessWidget {
  final List<Cfuser> users;
  const ActiveUsersList({Key? key, required this.users}) : super(key: key);

  void sortUsers() {
    users.sort(((a, b) => b.rating.compareTo(a.rating)));
  }

  Color choosecolor(String rank) {
    if (rank == "newbie") return const Color(0xff808185);
    if (rank == "pupil") {
      return const Color(0xff808080);
    }
    if (rank == "specialist") {
      return const Color(0xff03a89e);
    }
    if (rank == "expert") {
      return const Color(0xff0000ff);
    }
    if (rank == "candidate master") {
      return const Color.fromARGB(255, 156, 0, 184);
    }
    if (rank == "master") {
      return const Color(0xffff8c00);
    }
    if (rank == "international master") {
      return const Color(0xffff8c00);
    }
    if (rank == "grandmaster") {
      return const Color(0xffff0000);
    }
    if (rank == "international grandmaster") {
      return const Color(0xffff0000);
    }

    return const Color(0xffff0000);
  }


  @override
  Widget build(BuildContext context) {
    sortUsers();
    return ListView.builder(
      primary: false,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            title: users[index].rank[0] == 'l'  // legendary
                ? Row(
                    children: [
                      Text(users[index].handle[0],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(users[index].handle.substring(1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: choosecolor(users[index].rank),
                          )),
                    ],
                  )
                : Text(
                    users[index].handle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: choosecolor(users[index].rank),
                    ),
                  ),
            trailing: Text(
              users[index].rating.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: choosecolor(users[index].rank),
              ),
            ),
          );
        });
  }
}
