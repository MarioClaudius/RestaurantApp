import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/services/local_notification_service.dart';
import 'package:restaurant_app/data/services/shared_preferences_service.dart';
import 'package:restaurant_app/data/services/sqlite_service.dart';
import 'package:restaurant_app/provider/index_nav_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/shared_preferences_provider.dart';
import 'package:restaurant_app/screen/detail_screen.dart';
import 'package:restaurant_app/screen/main_screen.dart';
import 'package:restaurant_app/screen/setting_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/theme/text_theme.dart';
import 'package:restaurant_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IndexNavProvider(),
        ),
        Provider(
          create: (context) => ApiService(),
        ),
        Provider(
          create: (context) => SqliteService(),
        ),
        Provider(
          create: (context) => SharedPreferencesService(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalDatabaseProvider(
            context.read<SqliteService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<ApiService>()
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<ApiService>()
          )
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferencesService>(),
          )
        ),
        Provider(
          create: (context) => LocalNotificationService()
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
      ],
      child: const MainApp(),
    )
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>()!;
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
      sharedPreferencesProvider.getIsDarkModeValue();
      sharedPreferencesProvider.getIsScheduleActive();
      final localNotificationProvider = context.read<LocalNotificationProvider>();
      if (localNotificationProvider.permission!) {
        localNotificationProvider.requestPermissions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPreferencesProvider>(
      builder: (context, sharedPreferencesProvider, child) {
        return MaterialApp(
          title: "Restaurant App",
          theme: ThemeData(
            colorScheme: MaterialTheme.lightScheme(),
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: MaterialTheme.darkScheme(),
            textTheme: textTheme,
          ),
          themeMode: sharedPreferencesProvider.isDarkMode! ? ThemeMode.dark : ThemeMode.light,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                restaurantId: ModalRoute.of(context)?.settings.arguments as String
            ),
            NavigationRoute.settingRoute.name: (context) => SettingScreen(),
          },
        );
      }
    );
  }
}