import 'package:codeforces_vis/screens/favorites.dart';
import 'package:codeforces_vis/screens/search_user.dart';
import 'package:codeforces_vis/screens/upcoming_contests.dart';
import 'package:codeforces_vis/screens/user_list.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int bottomIdx = 0;

  List<Widget> screens = [
    const SearchUser(), 
    const UpcomingContests(),
    const ActiveUsers(),
    const Favorites(),
  ];

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
          title: Row(children: [
            const Expanded(
                child: Image(
              image: AssetImage(
                'assets/images/cflogo2.png',
              ),
              fit: BoxFit.cover,
            )),
            Container(
              width: sz.width * .4,
            ),
          ]),
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: CurvedNavigationBar(
            index: bottomIdx,
            height: 60,
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: bottomIdx == 1 || bottomIdx == 2 ? const Color.fromARGB(255, 21, 132, 132) :const Color(0xff20124d),
            
            onTap: (value) {
              // Respond to item press.
              setState(() {
                bottomIdx = value;
              });
              
            },
            items: const[
              Icon(Icons.home_outlined),
              // Icon(Icons.favorite),
              Icon(Icons.upcoming_outlined),
              Icon(Icons.people_outline),
              // Icon(Icons.question_answer_rounded),
              Icon(Icons.compare_arrows),
            ],
         ),  
        body: screens[bottomIdx],
            
        
        );
  }
}


