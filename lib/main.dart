import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/index_nav_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/detail_screen.dart';
import 'package:restaurant_app/screen/home_screen.dart';
import 'package:restaurant_app/screen/main_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/theme/text_theme.dart';
import 'package:restaurant_app/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => IndexNavProvider(),
        ),
        Provider(
            create: (context) => ApiService(),
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
      ],
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
          restaurantId: ModalRoute.of(context)?.settings.arguments as String
        ),
      },
    );
  }
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff5b5891),
  surfaceTint: Color(0xff5b5891),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffe3dfff),
  onPrimaryContainer: Color(0xff434078),
  secondary: Color(0xff5e5c71),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffe4dff9),
  onSecondaryContainer: Color(0xff464559),
  tertiary: Color(0xff7a5367),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffffd8e9),
  onTertiaryContainer: Color(0xff603b4f),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff93000a),
  surface: Color(0xfffcf8ff),
  onSurface: Color(0xff1c1b20),
  onSurfaceVariant: Color(0xff47464f),
  outline: Color(0xff787680),
  outlineVariant: Color(0xffc8c5d0),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff313036),
  inversePrimary: Color(0xffc4c0ff),
  primaryFixed: Color(0xffe3dfff),
  onPrimaryFixed: Color(0xff17134a),
  primaryFixedDim: Color(0xffc4c0ff),
  onPrimaryFixedVariant: Color(0xff434078),
  secondaryFixed: Color(0xffe4dff9),
  onSecondaryFixed: Color(0xff1b1a2c),
  secondaryFixedDim: Color(0xffc7c4dc),
  onSecondaryFixedVariant: Color(0xff464559),
  tertiaryFixed: Color(0xffffd8e9),
  onTertiaryFixed: Color(0xff2f1123),
  tertiaryFixedDim: Color(0xffebb9d0),
  onTertiaryFixedVariant: Color(0xff603b4f),
  surfaceDim: Color(0xffdcd8e0),
  surfaceBright: Color(0xfffcf8ff),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff6f2fa),
  surfaceContainer: Color(0xfff0ecf4),
  surfaceContainerHigh: Color(0xffebe7ef),
  surfaceContainerHighest: Color(0xffe5e1e9),
);
