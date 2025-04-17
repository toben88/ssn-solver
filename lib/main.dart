import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/provisions_provider.dart';
import 'providers/selected_provisions_provider.dart';
import 'screens/provisions_screen.dart';
import 'screens/actuarial_provisions_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(
          create: (_) => SelectedProvisionsProvider(),
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
          // Optimize typography for different screen sizes
          textTheme: Typography.material2018().black.copyWith(
            titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            bodyLarge: const TextStyle(fontSize: 16),
            bodyMedium: const TextStyle(fontSize: 14),
            bodySmall: const TextStyle(fontSize: 12),
          ),
        ),
        // Set responsive design constraints
        builder: (context, child) {
          return MediaQuery(  
            // Apply a slight text scaling factor limit for better readability
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
            ),
            child: child!,
          );
        },
        routes: {
          '/': (context) => const ProvisionsScreen(),
          '/actuarial': (context) => const ActuarialProvisionsScreen(),
        },
        initialRoute: '/',
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
