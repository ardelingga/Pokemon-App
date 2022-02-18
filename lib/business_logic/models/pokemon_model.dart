class PokemonModel {
  String? name;
  String? img;
  int? weight;
  int? height;
  List<TypePokemonModel>? types;
  PokemonModel({
    this.name,
    this.img,
    this.weight,
    this.height,
    this.types,
  });
}

class TypePokemonModel {
  String? name;
  TypePokemonModel({
    this.name,
  });
}
