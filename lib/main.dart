import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_app.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  // This is to prevent app rotation to screen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //Set up database and data providers
  await DBProvider.db.initDB();
  await Categories.provider.init();
  await Accounts.provider.init();

  //Run app
  print("Starting App...");
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
        ChangeNotifierProvider<DashboardData>(
          create: (_) => DashboardData.init(),
        ),
        ChangeNotifierProvider<Accounts>(
          create: (_) => Accounts.provider,
        ),
        ChangeNotifierProvider<Categories>(
          create: (_) => Categories.provider,
        ),
        ChangeNotifierProvider<RefreshPeriodReport>(
          create: (_) => RefreshPeriodReport(),
        ),
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
