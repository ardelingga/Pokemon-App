import 'package:flutter/material.dart';
import 'package:pokemon_app/views/screens/favorite_pokemon/favorite_pokemon_screen.dart';
import 'package:pokemon_app/views/screens/home/home_screen.dart';

class DrawerNavigationProvider extends ChangeNotifier {
  int? _currentMenu = 0;
  int? get currentMenu => _currentMenu;

  List<Widget> screens = const [
    HomeScreen(),
    FavoritePokemonScreen(),
  ];

  Widget get currentScreen => screens[_currentMenu!];

  Future setCurrentMenu(int i) async{
    _currentMenu = i;
    notifyListeners();
  }
}
