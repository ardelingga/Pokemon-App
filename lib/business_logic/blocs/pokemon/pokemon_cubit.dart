import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/business_logic/models/response_model.dart';
import 'package:pokemon_app/business_logic/providers/favorite_pokemon_provider.dart';
import 'package:pokemon_app/business_logic/services/api_services.dart';

part 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  PokemonCubit() : super(PokemonInitial());

  Future<void> getListPokemon() async {
    emit(PokemonLoading());

    var params = {'offset': 0, 'limit': 20};
    List<PokemonModel> listPokemon = [];

    ResponseModel resListPokemon =
        await apiService.getRequest("pokemon", params: params);

    for (int i = 0; i < resListPokemon.data["results"].length; i++) {
      var urlDetail = resListPokemon.data["results"][i]["url"];

      ResponseModel resDetailPokemon = await apiService.getRequest(urlDetail);

      listPokemon.add(
        PokemonModel(
          id: resDetailPokemon.data['id'],
          name: resDetailPokemon.data['name'],
          species: resDetailPokemon.data['species']['name'],
          img: resDetailPokemon.data['sprites']['other']['home']
              ['front_default'],
          weight: resDetailPokemon.data['weight'],
          height: resDetailPokemon.data['height'],
          types: List<TypePokemonModel>.generate(
            resDetailPokemon.data['types'].length,
            (j) => TypePokemonModel(
              name: resDetailPokemon.data['types'][j]['type']['name'],
            ),
          ),
          abilities: List<AbilityPokemonModel>.generate(
            resDetailPokemon.data['abilities'].length,
            (k) => AbilityPokemonModel(
                name: resDetailPokemon.data['abilities'][k]['ability']['name']),
          ),
          stats: List<StatPokemonModel>.generate(
            resDetailPokemon.data['stats'].length,
            (l) => StatPokemonModel(
              name: resDetailPokemon.data['stats'][l]['stat']['name'],
              amount: resDetailPokemon.data['stats'][l]['base_stat'],
            ),
          ),
          groups: List<GroupPokemonModel>.generate(
            resDetailPokemon.data['moves'][0]['version_group_details'].length,
            (m) => GroupPokemonModel(
              moveLearnMethod: resDetailPokemon.data['moves'][0]
                  ['version_group_details'][m]['move_learn_method']['name'],
              versionGroup: resDetailPokemon.data['moves'][0]
                  ['version_group_details'][m]['version_group']['name'],
            ),
          ),
        ),
      );
    }
    emit(PokemonLoaded(listPokemon: listPokemon));
  }

  Future<void> getListFavoritePokemon() async {
    emit(PokemonLoading());

    List<PokemonModel> listPokemon = [];
    List<String>? listFavorite =
        favoritePokemonProviderSpecial!.listFavoritePokemon;
    debugPrint("SPECIAL => " + listFavorite.toString());

    for (int i = 0; i < listFavorite!.length; i++) {
      var idPokemon = listFavorite[i];

      ResponseModel resDetailPokemon =
          await apiService.getRequest("pokemon/$idPokemon");
      listPokemon.add(
        PokemonModel(
          id: resDetailPokemon.data['id'],
          name: resDetailPokemon.data['name'],
          species: resDetailPokemon.data['species']['name'],
          img: resDetailPokemon.data['sprites']['other']['home']
              ['front_default'],
          weight: resDetailPokemon.data['weight'],
          height: resDetailPokemon.data['height'],
          types: List<TypePokemonModel>.generate(
            resDetailPokemon.data['types'].length,
            (j) => TypePokemonModel(
              name: resDetailPokemon.data['types'][j]['type']['name'],
            ),
          ),
          abilities: List<AbilityPokemonModel>.generate(
            resDetailPokemon.data['abilities'].length,
            (k) => AbilityPokemonModel(
                name: resDetailPokemon.data['abilities'][k]['ability']['name']),
          ),
          stats: List<StatPokemonModel>.generate(
            resDetailPokemon.data['stats'].length,
            (l) => StatPokemonModel(
              name: resDetailPokemon.data['stats'][l]['stat']['name'],
              amount: resDetailPokemon.data['stats'][l]['base_stat'],
            ),
          ),
          groups: List<GroupPokemonModel>.generate(
            resDetailPokemon.data['moves'][0]['version_group_details'].length,
            (m) => GroupPokemonModel(
              moveLearnMethod: resDetailPokemon.data['moves'][0]
                  ['version_group_details'][m]['move_learn_method']['name'],
              versionGroup: resDetailPokemon.data['moves'][0]
                  ['version_group_details'][m]['version_group']['name'],
            ),
          ),
        ),
      );
    }
    emit(PokemonLoaded(listPokemon: listPokemon));
  }
}
