part of 'pokemon_cubit.dart';

@immutable
abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

// ignore: must_be_immutable
class PokemonLoaded extends PokemonState {
  List<PokemonModel> listPokemon;
  PokemonLoaded({required this.listPokemon});
}
