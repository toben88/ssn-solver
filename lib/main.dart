import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/provisions_provider.dart';
import 'screens/provisions_screen.dart';

void main() {
  runApp(const SSNCalculatorApp());
}

class SSNCalculatorApp extends StatelessWidget {
  const SSNCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProvisionsProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'SSN Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: const CardTheme(
            margin: EdgeInsets.zero,
          ),
        ),
        home: const ProvisionsScreen(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Security Calculator'),
      ),
      body: const Center(
        child: Text('Welcome to SSN Calculator'),
      ),
    );
  }
}
