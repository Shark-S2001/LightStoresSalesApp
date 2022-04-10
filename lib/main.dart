import 'package:flutter/material.dart';
import 'package:projects/view/Dashboard.dart';
import 'package:projects/view/welcome_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "LightStores App",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
