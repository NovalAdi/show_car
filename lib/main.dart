import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_car/ui/page/home_page.dart';
import 'package:show_car/ui/page/login_page.dart';

import 'cubit/home/home_cubit.dart';
import 'local/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SecureStorage.deleteDataLokal();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = '';

  @override
  void initState() {
    SecureStorage.getToken().then((value) {
      if (value == null) {
        setState(() {
          initialRoute = 'login';
        });
      } else {
        setState(() {
          initialRoute = 'home';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Rubik"
        ),
        home: initialRoute == 'login' ? const LoginPage() : const HomePage(),
      ),
    );
  }
}
