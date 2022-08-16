import 'package:codeforces_vis/models/user_model.dart';
import 'package:codeforces_vis/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
                                                                                                                
                                                                    
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(CfuserAdapter());
  await Hive.openBox<Cfuser>('FavoritesList');

  runApp(const MyApp());                        
}
                                                                                   
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
      
  @override                                     
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}