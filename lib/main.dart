import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizzlr/home.dart';
import 'package:rizzlr/pages/loginScreen.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/themeprov.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Initialize LoginProvider before running the app
  final loginProvider = LoginProvider()..loadAuthStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Themeprov()),
        ChangeNotifierProvider(create: (context) => loginProvider), // Pass the initialized provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<Themeprov>(context).themeData,
          home: loginProvider.isAuthenticated ? Home() : const LoginScreen(),
        );
      },
    );
  }
}
