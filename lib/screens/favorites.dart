import 'package:codeforces_vis/models/user_model.dart';
import 'package:codeforces_vis/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<Box<Cfuser>>(
        valueListenable: Hive.box<Cfuser>('FavoritesList').listenable(),
        builder: (context, box, _) {
          final favusers = box.values.toList().cast<Cfuser>();

          return favusers.isEmpty
                    ? const Center(
                        child: Text(
                          "No users added yet!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 24),
                        ),
                      )
                    :  ListView.builder(
              itemCount: favusers.length,
              itemBuilder: (context, index) {
                return ListTile(
                      leading: Text((index+1).toString()),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return ShowUser(
                              handle: favusers[index].handle,
                            );
                          })));
                        },
                        title: favusers[index].rank[0] == 'l' // legendary
                            ? Row(
                                children: [
                                  Text(favusers[index].handle[0],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(favusers[index].handle.substring(1),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        // color: choosecolor(favusers[index].rank),
                                        color:
                                            choosecolor(favusers[index].rank),
                                      )),
                                  Expanded(
                                    child: Text(
                                      '  ${favusers[index].country}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      favusers[index].handle,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            choosecolor(favusers[index].rank),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '  ${favusers[index].country}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ),
                        trailing: IconButton(
                            onPressed: () {
                              favusers[index].delete();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      );
              });
        },
      ),
    );
  }
}
