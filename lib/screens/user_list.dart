import 'dart:convert';

import 'package:codeforces_vis/models/user_model.dart';
import 'package:codeforces_vis/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({Key? key}) : super(key: key);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  Future<List<Cfuser>> fetchUserslist() async {
    String uri =
        "https://codeforces.com/api/user.ratedList?activeOnly=true&includeRetired=true";
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body)['result'];

      List<Cfuser> users = res.map((d) => Cfuser.fromJson(d)).toList();

      return users;
    } else {
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
          } else if (allusers.hasError) {
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

// ignore: must_be_immutable
class ActiveUsersList extends StatefulWidget {
  List<Cfuser> users;
  ActiveUsersList({Key? key, required this.users}) : super(key: key);

  @override
  State<ActiveUsersList> createState() => _ActiveUsersListState();
}

class _ActiveUsersListState extends State<ActiveUsersList> {
  // GlobalKey<_ActiveUsersListState> _myKey = GlobalKey();
  
  late List<Cfuser> origList;
  Set<String> selectedHandles = {};

  @override
  void initState() {
    super.initState();

    origList = widget.users;
  }

  void sortUsers() =>
      widget.users.sort(((a, b) => b.rating.compareTo(a.rating)));

  Color choosecolor(String rank) {
    if (rank == "newbie") return const Color(0xff808185);
    if (rank == "pupil") {
      return const Color(0xff008000);
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

  void searchresult(String query) {
    String input = query.trim();

    setState(() {
      if (input.isEmpty) {
        widget.users = origList;
      } else {
        List<Cfuser> newlist;
        input = input.toLowerCase();

        newlist = widget.users.where((element) {
          String nameHere = element.handle.toLowerCase();
          String countryHere = element.country.toLowerCase();

          return nameHere.contains(input) || countryHere.contains(input);
        }).toList();

        widget.users = newlist;
      }
    });
  }

  void addToFavorites(Cfuser user) {

    final userHere = Cfuser(
      rating: user.rating, 
      friends: user.friends,
      maxrating: user.maxrating,
      contribution: user.contribution,
      handle: user.handle,
      rank: user.rank,
      maxrank: user.maxrank,
      avatar: user.avatar,
      country: user.country
    );

    final box = Hive.box<Cfuser>('FavoritesList');
    box.add(userHere);

  }

  @override
  Widget build(BuildContext context) {
    // sortUsers();
    var sz = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: sz.width * .1, right: sz.width * .1, top: sz.width * .05),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          height: sz.height * .1,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) {
              searchresult(value);
            },
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'Search by name/country'),
          ),
        ),
        Expanded(
          child: ListView.builder(
              primary: false,
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (() => Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return ShowUser(
                          handle: widget.users[index].handle,
                        );
                      })))),
                  leading: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  title: widget.users[index].rank[0] == 'l' // legendary
                      ? Row(
                          children: [
                            Text(widget.users[index].handle[0],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(widget.users[index].handle.substring(1),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: choosecolor(widget.users[index].rank),
                                )),
                            Expanded(
                              child: Text(
                                '  ${widget.users[index].country}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.users[index].handle,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: choosecolor(widget.users[index].rank),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '  ${widget.users[index].country}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                  trailing: SizedBox(
                    width: 100,

                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black)
                    // ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.users[index].rating.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: choosecolor(widget.users[index].rank),
                            ),
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedHandles
                                        .contains(widget.users[index].handle)) {
                                      selectedHandles
                                          .remove(widget.users[index].handle);
                                    } else {
                                      selectedHandles
                                          .add(widget.users[index].handle);
                                    }
                                    if(selectedHandles.contains(widget.users[index].handle) == true){
                                      addToFavorites(widget.users[index]);
                                    }
                                  });
                                },
                                icon: selectedHandles
                                        .contains(widget.users[index].handle)
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.amber[900],
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                      )))
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
