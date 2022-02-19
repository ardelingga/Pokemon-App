import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_app/business_logic/config/config.dart';
import 'package:pokemon_app/business_logic/providers/drawer_navigation_provider.dart';
import 'package:pokemon_app/business_logic/providers/favorite_pokemon_provider.dart';
import 'package:pokemon_app/business_logic/services/api_services.dart';
import 'package:pokemon_app/business_logic/services/sharedprefs_service.dart';
import 'package:pokemon_app/views/screens/main_navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await sharedprefsService.init();
  await apiService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerNavigationProvider>( create: (context) => DrawerNavigationProvider()),
        ChangeNotifierProvider<FavoritePokemonProvider>( create: (context) => FavoritePokemonProvider()),
      ],
      child: MaterialApp(
        title: Config.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
