import 'package:flutter/material.dart';
import 'package:untitled3/home/myhomepage.dart';
import 'package:untitled3/onbording/splash.dart';
import 'package:untitled3/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/notificationprovider.dart';
import 'models/bookingmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
      ChangeNotifierProvider(
        create: (context) => ChatProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        '/home': (context) => MyHomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return MaterialPageRoute(builder: (_) => MyHomePage());
        }
        return null;
      },

    );
  }
}
