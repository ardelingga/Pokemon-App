class PokemonModel {
  String? name;
  String? species;
  String? img;
  int? weight;
  int? height;
  List<TypePokemonModel>? types;
  List<AbilityPokemonModel>? abilities;
  List<StatPokemonModel>? stats;
  List<GroupPokemonModel>? groups;
  PokemonModel({
    this.name,
    this.species,
    this.img,
    this.weight,
    this.height,
    this.types,
    this.abilities,
    this.stats,
    this.groups,
  });
}

class TypePokemonModel {
  String? name;
  TypePokemonModel({
    this.name,
  });
}

class AbilityPokemonModel {
  String? name;
  AbilityPokemonModel({
    this.name,
  });
}

class StatPokemonModel {
  String? name;
  int? amount;
  StatPokemonModel({
    this.name,
    this.amount,
  });
}

class GroupPokemonModel {
  String? moveLearnMethod;
  String? versionGroup;
  GroupPokemonModel({
    this.moveLearnMethod,
    this.versionGroup,
  });
}
