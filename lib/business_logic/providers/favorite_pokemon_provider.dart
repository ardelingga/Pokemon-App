import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/services/sharedprefs_service.dart';

FavoritePokemonProvider? favoritePokemonProviderSpecial;

class FavoritePokemonProvider extends ChangeNotifier {
  List<String>? _listFavoritePokemon = [];
  List<String>? get listFavoritePokemon => _listFavoritePokemon;

  bool? _isFavorite = false;
  bool? get isFavorite => _isFavorite;

  Future saveListFavorite(List<String> listFavoritePokemon) async {
    await sharedprefsService.saveData(
        "myfavorites_pokemon", listFavoritePokemon);
    await getListFavorite();
  }

  Future saveToFavorite(String idPokemon) async {
    _listFavoritePokemon!.add(idPokemon);
    await saveListFavorite(_listFavoritePokemon!);
    await findPokemonFavorit(idPokemon);
    notifyListeners();
  }

  Future removeFromFavorite(String idPokemon) async {
    _listFavoritePokemon!.remove(idPokemon);
    await saveListFavorite(_listFavoritePokemon!);
    await findPokemonFavorit(idPokemon);
    notifyListeners();
  }

  Future getListFavorite() async {
    _listFavoritePokemon =
        await sharedprefsService.getData("myfavorites_pokemon");
    debugPrint(listFavoritePokemon.toString());
    notifyListeners();
  }

  Future findPokemonFavorit(String idPokemon) async {
    bool isFavorite = false;
    for (var element in listFavoritePokemon!) {
      if (element == idPokemon) {
        isFavorite = true;
      }
    }
    _isFavorite = isFavorite;
    notifyListeners();
  }
}
