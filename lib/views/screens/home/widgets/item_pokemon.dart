import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/detail_pokemon_screen.dart';
import 'package:pokemon_app/views/screens/home/widgets/img_loading_shimmer.dart';
import 'package:pokemon_app/views/widgets/common_widgets.dart';

// ignore: must_be_immutable
class ItemPokemon extends StatelessWidget {
  ItemPokemon({Key? key, required this.pokemon, required this.i})
      : super(key: key);
  PokemonModel? pokemon;
  int? i;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPokemonScreen(
                      pokemon: pokemon!,
                      heroTag: "imgHeroTag#$i",
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: CommonWidget.getBackgoundColor(pokemon!.types![0].name!),
        ),
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: SizedBox(
                    child: SvgPicture.asset(
                      PathAssets.icons + "icon_pokemon.svg",
                      width: size.width / 3,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon!.name!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: SizedBox(
                            width: size.width,
                            height: size.width,
                            child: ListView.builder(
                              itemCount: pokemon!.types!.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, j) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Center(
                                        child: Text(
                                          pokemon!.types![j].name!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: SizedBox(
                            width: size.width,
                            height: size.width,
                            child: Hero(
                              tag: "imgHeroTag#$i",
                              child: CachedNetworkImage(
                                imageUrl: pokemon!.img!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const ImgLoadingShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
