import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // This is to prevent app rotation to screen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //Set up database
  DBProvider.db.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountsProvider>(
          create: (_) => AccountsProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<DashboardData>(
          create: (_) => DashboardData(),
        )
      ],
      child: MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData(
          colorSchemeSeed: Colors.blueAccent,
          appBarTheme: const AppBarTheme(elevation: 10),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        home: const MyHome(),
      ),
    );
  }
}
