import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/detail_pokemon_screen.dart';
import 'package:pokemon_app/views/screens/home/widgets/img_loading_shimmer.dart';
import 'package:pokemon_app/views/widgets/common_widgets.dart';

class ItemFavorite extends StatelessWidget {
  ItemFavorite({Key? key, required this.pokemon, required this.i})
      : super(key: key);

  PokemonModel? pokemon;
  int? i;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPokemonScreen(
                pokemon: pokemon!,
                heroTag: "imgHeroTag#$i",
              ),
            ),
          );
        },
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CommonWidget.getBackgoundColor(pokemon!.types![0].name!),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: -40,
                child: SizedBox(
                  child: SvgPicture.asset(
                    PathAssets.icons + "icon_pokemon.svg",
                    width: size.width / 2,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
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
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        SizedBox(
                          width: size.width / 4,
                          child: ListView.builder(
                            itemCount: pokemon!.types!.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, j) {
                              return Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        child: Center(
                                          child: Text(
                                            pokemon!.types![j].name!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
