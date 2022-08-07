import 'package:codeforces_vis/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController _handlecontroller = TextEditingController();
  bool show = false;
  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff20124d),
      // appBar: AppBar(title: const Text('Search user'), centerTitle: true,),

      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: sz.height * .1,
                  child: Row(
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Be\nConsistent',
                            textStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Agne', 
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold
                              ),
                          speed: const Duration(milliseconds: 500),
                          cursor: '_',
                          ),
                        ],
                        // pause: const Duration(milliseconds: 1000),
                        totalRepeatCount: 1,
                        onFinished: () async{
                          await Future.delayed(const Duration(microseconds: 10));
                          show = true;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      show == false ? Container() :
                      AnimatedTextKit(
                        animatedTexts: [
                          animatedText('Eat'),
                          animatedText('Code'),
                          animatedText('Repeat'),
                        ],
                        
                        totalRepeatCount: 2,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                        onFinished: (){
                          setState(() {
                            show = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'Search for a user',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: sz.height * .01),
              SizedBox(
                width: sz.width * .7,
                child: TextField(
                  controller: _handlecontroller,
                  cursorColor: Colors.purple,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle:
                        const TextStyle(fontSize: 17, color: Colors.white),
                    hintText: 'Enter a CF handle',
                    suffixIcon: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return ShowUser(
                              handle: _handlecontroller.text.trim(),
                            );
                          })));
                        },
                        icon: const Icon(Icons.search)),
                    // border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue.shade600, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  RotateAnimatedText animatedText(String s) {
    return RotateAnimatedText(
      s,
      textStyle: const TextStyle(
        fontSize: 60.0,
        fontFamily: 'Canterbury',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
      // scalingFactor: 1.5,
      duration: const Duration(milliseconds: 1000),
    );
  }
}
