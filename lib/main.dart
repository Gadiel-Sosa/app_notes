import 'package:app_notes/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //* Oculta la etiqueta de "debug"
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        //* visualDensity ajusta automáticamente el espacio entre los
        //*elementos según la plataforma (Android, iOS, etc.)
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //* appBarTheme define el estilo de la barra superior de la
        //*app (AppBar), aquí le damos un color oscuro
        appBarTheme: AppBarTheme(color: Colors.black87),
      ),
      home: HomeScreen(),
    );
  }
}
