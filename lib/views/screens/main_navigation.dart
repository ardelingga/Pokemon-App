import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/providers/drawer_navigation_provider.dart';
import 'package:pokemon_app/business_logic/providers/favorite_pokemon_provider.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    favoritePokemonProviderSpecial = context.read<FavoritePokemonProvider>();
    context.read<FavoritePokemonProvider>().getListFavorite();
    return Consumer<DrawerNavigationProvider>(
        builder: (context, data, chid) => data.currentScreen);
  }
}
