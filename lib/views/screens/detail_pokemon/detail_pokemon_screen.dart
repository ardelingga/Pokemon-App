import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/business_logic/providers/favorite_pokemon_provider.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/about_tab.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/base_stats_tab.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/notfound_tab.dart';
import 'package:pokemon_app/views/screens/home/widgets/img_loading_shimmer.dart';
import 'package:pokemon_app/views/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailPokemonScreen extends StatefulWidget {
  DetailPokemonScreen({Key? key, required this.pokemon, this.heroTag})
      : super(key: key);
  PokemonModel pokemon;
  String? heroTag;

  @override
  _DetailPokemonScreenState createState() => _DetailPokemonScreenState();
}

class _DetailPokemonScreenState extends State<DetailPokemonScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? scrollController;
  TabController? tabController;
  var pokemonCubit = PokemonCubit();
  double heightSliverbar = 20;
  FavoritePokemonProvider? favoritePokemonProvider;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 16);
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    // scrollController!.dispose();
    // tabController!.dispose();
  }

  Future<void> firstAction() async {
    await Future.delayed(const Duration(microseconds: 500));
    await favoritePokemonProvider!
        .findPokemonFavorit(widget.pokemon.id.toString());

    scrollController!.addListener(() {
      var scroll = scrollController!.position.pixels * 3;
      if (scroll >= 20 && scroll <= 60) {
        setState(() {
          heightSliverbar = scroll;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    favoritePokemonProvider = context.read<FavoritePokemonProvider>();
    Size size = MediaQuery.of(context).size;
    firstAction();
    return BlocProvider<PokemonCubit>(
      create: (context) => pokemonCubit,
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    // favoritePokemonProvider!.getListFavorite();
                    // favoritePokemonProvider!
                    //     .findPokemonFavorit(widget.pokemon.id.toString());
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Consumer<FavoritePokemonProvider>(
                    builder: (context, data, child) => IconButton(
                      icon: data.isFavorite!
                          ? const Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.favorite_border_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        var idPokemon = widget.pokemon.id.toString();
                        data.isFavorite!
                            ? await removeFromFavorite(idPokemon)
                            : await saveToFavorite(idPokemon);
                      },
                    ),
                  ),
                ),
              ],
              expandedHeight: 100.0,
              floating: true,
              pinned: true,
              snap: true,
              // collapsedHeight: 100,
              elevation: 0,
              backgroundColor: CommonWidget.getBackgoundColor(
                  widget.pokemon.types![0].name!),
              flexibleSpace: SizedBox(
                width: size.width,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      bottom: 10,
                      left: heightSliverbar,
                      child: Text(
                        widget.pokemon.name!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: CommonWidget.getBackgoundColor(
                        widget.pokemon.types![0].name!),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: (size.height / 2) - 100,
                              width: size.width,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -75,
                                    bottom: -60,
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                        PathAssets.icons + "icon_pokemon.svg",
                                        width: size.width / 1.4,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 70,
                                  ),
                                  TabBar(
                                    controller: tabController,
                                    indicatorColor: Colors.black45,
                                    tabs: const [
                                      Tab(
                                        child: Text(
                                          "About",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Base Stats",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Evolution",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Moves",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: (size.height / 2),
                                    child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        AboutTab(pokemon: widget.pokemon),
                                        BaseStatsTab(
                                          pokemon: widget.pokemon,
                                        ),
                                        const NotFoundTab(),
                                        const NotFoundTab(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width,
                          height: (size.height / 2) - 60,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Wrap(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "#0${widget.pokemon.id}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: ListView.builder(
                                        itemCount: widget.pokemon.types!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    widget.pokemon.types![i]
                                                        .name!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.drag_indicator_rounded,
                                      size: 80,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  Center(
                                    child: Hero(
                                      tag: widget.heroTag!,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.pokemon.img!,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                const ImgLoadingShimmer(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future saveToFavorite(String idPokemon) async {
    await favoritePokemonProvider!.saveToFavorite(idPokemon);
  }

  Future removeFromFavorite(String idPokemon) async {
    await favoritePokemonProvider!.removeFromFavorite(idPokemon);
  }
}
