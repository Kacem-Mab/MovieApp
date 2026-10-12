import 'package:flutter/material.dart';

import 'package:workshop_flutter__4ei3/screens/MyFavorites.dart';
import 'package:workshop_flutter__4ei3/screens/BottomNavBar.dart';
import 'package:workshop_flutter__4ei3/screens/GStoreGridView.dart';
import 'package:workshop_flutter__4ei3/screens/GStoreListView.dart';
import 'package:workshop_flutter__4ei3/screens/MyCart.dart';
import 'package:workshop_flutter__4ei3/screens/Profile.dart';
import 'package:workshop_flutter__4ei3/screens/SignIn.dart';
import 'package:workshop_flutter__4ei3/screens/SignUp.dart';
import 'package:workshop_flutter__4ei3/screens/TabBarNav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/profile': (context) => const Profile(),
        '/myfilmslistview': (context) => const GStoreListView(),
        '/myfilmsgridview': (context) => const GStoreGridView(),
        '/mycart': (context) => const MyCart(),
        '/myfavorites': (context) => const MyFavorites(),
        '/bottomnavbar': (context) => const BottomNavBar(),
        '/tabbarnav': (context) => const TabBarNav(),
      },
    );
  }
}
