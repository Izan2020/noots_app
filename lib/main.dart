import 'package:flutter/material.dart';
import 'package:noots_app/interface/screen/home/home.dart';
import 'package:noots_app/provider/interface_provider.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => InterfaceProvider())
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
