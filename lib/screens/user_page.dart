import 'package:codeforces_vis/models/user_model.dart';
import 'package:codeforces_vis/services/get_problemtags.dart';
import 'package:codeforces_vis/services/get_user.dart';
import 'package:flutter/material.dart';

class ShowUser extends StatefulWidget {
  final String handle;
  const ShowUser({Key? key, required this.handle}) : super(key: key);

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  late Future<Cfuser> futureuser;

  @override
  void initState() {
    super.initState();
    futureuser = fetchCfuser(widget.handle);
    // subResult = getProblemdetails(widget.handle);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 109, 149),
      appBar: AppBar(
        title: Text(widget.handle, overflow: TextOverflow.ellipsis,),
        backgroundColor: const Color.fromARGB(255, 15, 70, 97),
      ),
      body: Column(
        children: [
          FutureBuilder<Cfuser>(
            future: futureuser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return UserDetails(
                  rating: snapshot.data!.rating,
                  maxrating: snapshot.data!.maxrating,
                  friends: snapshot.data!.friends,
                  contribution: snapshot.data!.contribution,
                  handle: snapshot.data!.handle,
                  rank: snapshot.data!.rank,
                  maxrank: snapshot.data!.maxrank,
                  avatar: snapshot.data!.avatar,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}', style: const TextStyle(color: Colors.white, fontSize: 18),),
                );
              }

              return Container();
            },
          ),
          ProblemTags(handle: widget.handle),
        ],
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  final int rating, maxrating, friends, contribution;
  final String handle, rank, maxrank, avatar;

  const UserDetails({
    Key? key,
    required this.rating,
    required this.maxrating,
    required this.friends,
    required this.contribution,
    required this.handle,
    required this.rank,
    required this.maxrank,
    required this.avatar,
  }) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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
    var sz = MediaQuery.of(context).size;
    String tmp1 = widget.handle[0], tmp2 = widget.handle.substring(1);

    return Column(
      children: [
        Container(
          height: sz.height * .25,
          width: sz.width,
          margin: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.rank[0] == 'l'
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                          children: [
                            Text(
                              tmp1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tmp2,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                          widget.handle,
                          style: TextStyle(
                              color: choosecolor(widget.rank),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.rank,
                    style: TextStyle(
                        fontSize: 18,
                        color: choosecolor(widget.rank),
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              children: [
                                const Text('(max.'),
                                Text(
                                  '${widget.maxrank}, ${widget.maxrating}',
                                  style: TextStyle(
                                      color: choosecolor(widget.maxrank),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Text(')'),
                              ],
                            ),
                            SizedBox(
                              height: sz.height * .025,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Contest rating: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                Text(
                                  widget.rating.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: choosecolor(widget.rank)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Friend of: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                Text(
                                  '${widget.friends} users',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                          Expanded(
                          child: SizedBox(
                            height: sz.height * .15,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  widget.avatar,
                                )),
                          ),
                        ),
                      ]),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
