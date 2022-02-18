import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/business_logic/models/response_model.dart';
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

      listPokemon.add(PokemonModel(
        name: resDetailPokemon.data['name'],
        img: resDetailPokemon.data['sprites']['other']['home']['front_default'],
        weight: resDetailPokemon.data['weight'],
        height: resDetailPokemon.data['height'],
        types: List<TypePokemonModel>.generate(
            resDetailPokemon.data['types'].length,
            (j) => TypePokemonModel(
                name: resDetailPokemon.data['types'][j]['type']['name'])),
      ));
    }

    for (int k = 0; k > listPokemon.length; k++) {
      print(listPokemon[k].img);
    }
    emit(PokemonLoaded(listPokemon: listPokemon));
  }
}
