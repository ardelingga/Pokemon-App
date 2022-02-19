import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/about_tab.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/base_stats_tab.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/widgets/notfound_tab.dart';
import 'package:pokemon_app/views/screens/home/widgets/img_loading_shimmer.dart';

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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 16);
    tabController = TabController(length: 4, vsync: this);
    firstAction();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController!.dispose();
  }

  Future<void> firstAction() async {
    await pokemonCubit.getListPokemon();
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
    Size size = MediaQuery.of(context).size;
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
                    color: Colors.black87,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      size: 30,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
              expandedHeight: 100.0,
              floating: true,
              pinned: true,
              snap: true,
              // collapsedHeight: 100,
              elevation: 0,
              backgroundColor: Colors.green,
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
                    color: Colors.green,
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
                                  Column(
                                    children: [],
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
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "#01",
                                        style: TextStyle(
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
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Container(
                  //   height: 100,
                  //   color: Colors.yellow,
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Container(
                  //   height: 100,
                  //   color: Colors.yellow,
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Container(
                  //   height: 100,
                  //   color: Colors.yellow,
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Container(
                  //   height: 100,
                  //   color: Colors.yellow,
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Container(
                  //   height: 100,
                  //   color: Colors.yellow,
                  // ),
                  // Container(
                  //   color: Colors.green,
                  //   width: size.width,
                  //   child: Stack(
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Stack(
                  //             children: [
                  //               Positioned(
                  //                 right: -70,
                  //                 bottom: -60,
                  //                 child: SizedBox(
                  //                   child: SvgPicture.asset(
                  //                     PathAssets.icons + "icon_pokemon.svg",
                  //                     width: size.width / 1.2,
                  //                     color: Colors.white.withOpacity(0.5),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 20),
                  //                 child: Container(
                  //                   height: (size.height / 2) - 100.0,
                  //                   child: Center(
                  //                     child: Column(
                  //                       children: [
                  //                         Align(
                  //                           alignment: Alignment.topRight,
                  //                           child: Text(
                  //                             "#01",
                  //                             style: TextStyle(
                  //                               color: Colors.white,
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w900,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Align(
                  //                           alignment: Alignment.topLeft,
                  //                           child: Container(
                  //                             decoration: BoxDecoration(
                  //                               color: Colors.white
                  //                                   .withOpacity(0.2),
                  //                               borderRadius:
                  //                                   BorderRadius.circular(30),
                  //                             ),
                  //                             child: Padding(
                  //                               padding:
                  //                                   const EdgeInsets.symmetric(
                  //                                       horizontal: 10,
                  //                                       vertical: 5),
                  //                               child: Text(
                  //                                 "Pokedex",
                  //                                 style: TextStyle(
                  //                                   color: Colors.white,
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.w900,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         const SizedBox(
                  //                           height: 20,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Container(
                  //             height: 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.red,
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(30),
                  //                 topRight: Radius.circular(30),
                  //               ),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 const SizedBox(
                  //                   height: 50,
                  //                 ),
                  //                 Container(
                  //                   height: 100,
                  //                   color: Colors.yellow,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 50,
                  //                 ),
                  //                 Container(
                  //                   height: 100,
                  //                   color: Colors.yellow,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 50,
                  //                 ),
                  //                 Container(
                  //                   height: 100,
                  //                   color: Colors.yellow,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 50,
                  //                 ),
                  //                 Container(
                  //                   height: 100,
                  //                   color: Colors.yellow,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Center(
                  //         child: Container(
                  //           // color: Colors.red,
                  //           height: (size.height / 2) - 70,
                  //           child: CachedNetworkImage(
                  //             imageUrl: widget.pokemon.img!,
                  //             progressIndicatorBuilder:
                  //                 (context, url, downloadProgress) => SizedBox(
                  //               height: 30,
                  //               width: 30,
                  //               child: CircularProgressIndicator(
                  //                 value: downloadProgress.progress,
                  //                 color: Colors.grey,
                  //                 backgroundColor: Colors.grey,
                  //               ),
                  //             ),
                  //             errorWidget: (context, url, error) =>
                  //                 const Icon(Icons.error),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
