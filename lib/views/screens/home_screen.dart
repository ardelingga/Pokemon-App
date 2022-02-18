import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? scrollController;
  var pokemonCubit = PokemonCubit();
  double heightSliverbar = 20;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 16);
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
        body: Stack(
          children: [
            Positioned(
              right: -132,
              top: -110,
              child: SizedBox(
                child: SvgPicture.asset(
                  PathAssets.icons + "icon_pokemon.svg",
                  width: size.width / 1.2,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
            CustomScrollView(
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
                        // Do something
                      },
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: const Icon(
                          Icons.list_outlined,
                          size: 30,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                      ),
                    ),
                  ],
                  expandedHeight: 100.0,
                  floating: true,
                  pinned: true,
                  snap: true,
                  // collapsedHeight: 100,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  flexibleSpace: SizedBox(
                    width: size.width,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -132,
                          top: -110,
                          child: SizedBox(
                            child: SvgPicture.asset(
                              PathAssets.icons + "icon_pokemon.svg",
                              width: size.width / 1.2,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 100),
                          bottom: 10,
                          left: heightSliverbar,
                          child: const Text(
                            "Pokedex",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<PokemonCubit, PokemonState>(
                  builder: (context, state) {
                    if (state is PokemonLoading || state is PokemonInitial) {
                      return const SliverPadding(
                        padding: EdgeInsets.all(8.0),
                      );
                    } else if (state is PokemonLoaded) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              var type = state.listPokemon[i].types![0].name;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: getBackgoundColor(type!),
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
                                              PathAssets.icons +
                                                  "icon_pokemon.svg",
                                              width: size.width / 3,
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 16, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.listPokemon[i].name!,
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
                                                      itemCount: state
                                                          .listPokemon[i]
                                                          .types!
                                                          .length,
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, j) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 2),
                                                              child: Center(
                                                                child: Text(
                                                                  state
                                                                      .listPokemon[
                                                                          i]
                                                                      .types![j]
                                                                      .name!,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
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
                                                    child: CachedNetworkImage(
                                                      imageUrl: state
                                                          .listPokemon[i].img!,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                          color: Colors.grey,
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Column(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.only(
                                    //           top: 8, left: 8),
                                    //       child: Text(
                                    //         state.listPokemon[i].name!,
                                    //         style: const TextStyle(
                                    //           color: Colors.white,
                                    //           fontSize: 16,
                                    //           fontWeight: FontWeight.w900,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.start,
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         Flexible(
                                    //           flex: 1,
                                    //           child: Container(
                                    //             width: 90,
                                    //             height: 80,
                                    //             color: Colors.green,
                                    //             child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                 left: 10,
                                    //               ),
                                    //               child: Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment.start,
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment
                                    //                         .start,
                                    //                 children: [
                                    //                   ListView.builder(
                                    //                     itemCount: state
                                    //                         .listPokemon[i]
                                    //                         .types!
                                    //                         .length,
                                    //                     shrinkWrap: true,
                                    //                     physics:
                                    //                         const NeverScrollableScrollPhysics(),
                                    //                     itemBuilder:
                                    //                         (context, j) =>
                                    //                             Padding(
                                    //                       padding:
                                    //                           const EdgeInsets
                                    //                               .only(top: 5),
                                    //                       child: Container(
                                    //                         decoration:
                                    //                             BoxDecoration(
                                    //                           borderRadius:
                                    //                               BorderRadius
                                    //                                   .circular(
                                    //                                       5),
                                    //                           color: Colors
                                    //                               .white
                                    //                               .withOpacity(
                                    //                                   0.2),
                                    //                         ),
                                    //                         child: Padding(
                                    //                           padding: const EdgeInsets
                                    //                                   .symmetric(
                                    //                               vertical: 2,
                                    //                               horizontal:
                                    //                                   5),
                                    //                           child: Text(
                                    //                             state
                                    //                                 .listPokemon[
                                    //                                     i]
                                    //                                 .types![j]
                                    //                                 .name!,
                                    //                             style:
                                    //                                 const TextStyle(
                                    //                               color: Colors
                                    //                                   .white,
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .normal,
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Flexible(
                                    //           flex: 1,
                                    //           child: Center(
                                    //             child: CachedNetworkImage(
                                    //               imageUrl:
                                    //                   state.listPokemon[i].img!,
                                    //               progressIndicatorBuilder: (context,
                                    //                       url,
                                    //                       downloadProgress) =>
                                    //                   CircularProgressIndicator(
                                    //                       value:
                                    //                           downloadProgress
                                    //                               .progress),
                                    //               errorWidget: (context, url,
                                    //                       error) =>
                                    //                   const Icon(Icons.error),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              );
                            },
                            childCount: state.listPokemon.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 4 / 3,
                          ),
                        ),
                      );
                    }
                    return const SliverPadding(
                      padding: EdgeInsets.all(8),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return BlocProvider(
    //   create: (context) => pokemonCubit,
    //   child: Scaffold(
    //     key: _scaffoldKey,
    //     endDrawer: const DrawerNavigationWidget(),
    //     body: SizedBox(
    //       width: size.width,
    //       height: size.height,
    //       child: Stack(
    //         children: [
    //           Positioned(
    //             right: -132,
    //             top: -95,
    //             child: SizedBox(
    //               child: SvgPicture.asset(
    //                 PathAssets.icons + "icon_pokemon.svg",
    //                 width: size.width / 1.2,
    //                 color: Colors.grey.withOpacity(0.5),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding:
    //                 EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //             child: Column(
    //               children: [
    //                 Padding(
    //                   padding:
    //                       const EdgeInsets.only(left: 5, right: 5, top: 20),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           IconButton(
    //                             onPressed: () {},
    //                             padding: EdgeInsets.zero,
    //                             icon: const Icon(
    //                               Icons.arrow_back,
    //                               size: 26,
    //                             ),
    //                           ),
    //                           IconButton(
    //                             onPressed: () {
    //                               _scaffoldKey.currentState!.openEndDrawer();
    //                             },
    //                             padding: EdgeInsets.zero,
    //                             icon: const Icon(
    //                               Icons.list_outlined,
    //                               size: 30,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       const SizedBox(
    //                         height: 10,
    //                       ),
    //                       const Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 16),
    //                         child: Text(
    //                           "Pokedex",
    //                           style: TextStyle(
    //                             color: Colors.black87,
    //                             fontSize: 26,
    //                             fontWeight: FontWeight.w900,
    //                           ),
    //                         ),
    //                       ),
    //                       const SizedBox(
    //                         height: 10,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Flexible(
    //                   child: SingleChildScrollView(
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 16),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           BlocBuilder<PokemonCubit, PokemonState>(
    //                             builder: (context, state) {
    //                               if (state is PokemonLoading ||
    //                                   state is PokemonInitial) {
    //                                 return SizedBox(
    //                                   width: size.width,
    //                                   height: size.height,
    //                                   child: const Center(
    //                                     child: CircularProgressIndicator(),
    //                                   ),
    //                                 );
    //                               } else if (state is PokemonLoaded) {
    //                                 return GridView.builder(
    //                                   itemCount: state.listPokemon.length,
    //                                   scrollDirection: Axis.vertical,
    //                                   physics:
    //                                       const NeverScrollableScrollPhysics(),
    //                                   reverse: false,
    //                                   shrinkWrap: true,
    //                                   gridDelegate:
    //                                       const SliverGridDelegateWithMaxCrossAxisExtent(
    //                                     maxCrossAxisExtent: 200,
    //                                     childAspectRatio: 4 / 3,
    //                                     crossAxisSpacing: 11,
    //                                     mainAxisSpacing: 10,
    //                                   ),
    //                                   itemBuilder: (context, index) =>
    //                                       Container(
    //                                     decoration: BoxDecoration(
    //                                       borderRadius:
    //                                           BorderRadius.circular(16),
    //                                       color: Colors.green,
    //                                     ),
    //                                   ),
    //                                 );
    //                               }
    //                               return Container();
    //                             },
    //                           ),
    //                           const SizedBox(
    //                             height: 16,
    //                           ),
    //                           // ElevatedButton(
    //                           //   onPressed: () async {
    //                           //     var params = {'offset': 0, 'limit': 20};
    //                           //     List<PokemonModel> listPokemon = [];

    //                           //     ResponseModel resListPokemon = await apiService
    //                           //         .getRequest("pokemon", params: params);

    //                           //     for (int i = 0; i < resListPokemon.data.length; i++) {
    //                           //       var urlDetail =
    //                           //           resListPokemon.data["results"][i]["url"];

    //                           //       ResponseModel resDetailPokemon =
    //                           //           await apiService.getRequest(urlDetail);

    //                           //       listPokemon.add(PokemonModel(
    //                           //         name: resDetailPokemon.data['name'],
    //                           //         img: resDetailPokemon.data['sprites']['other']
    //                           //             ['home']['front_default'],
    //                           //         weight: resDetailPokemon.data['weight'],
    //                           //         height: resDetailPokemon.data['height'],
    //                           //         types: List<TypePokemonModel>.generate(
    //                           //             resDetailPokemon.data['types'].length,
    //                           //             (j) => TypePokemonModel(
    //                           //                 name: resDetailPokemon.data['types'][j]
    //                           //                     ['type']['name'])),
    //                           //       ));
    //                           //       print('MAKAN BESAR');
    //                           //       print(resDetailPokemon.data['name']);

    //                           //       break;
    //                           //     }

    //                           //     print(listPokemon[0].types?[1].name.toString());

    //                           //     await pokemonCubit.getListPokemon();
    //                           //   },
    //                           //   child: const Text("TEST API"),
    //                           // ),
    //                           // ElevatedButton(
    //                           //   onPressed: () async {
    //                           //     // ResponseModel responseModel =
    //                           //     //     await apiService.getRequest("pokemon/4");
    //                           //     // print(responseModel.data['name']);

    //                           //     print(120.abs());
    //                           //   },
    //                           //   child: const Text("TEST API DETAIL"),
    //                           // ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Color getBackgoundColor(String type) {
    Color bgColor = Colors.white;

    if (type == "grass") {
      bgColor = Colors.lightGreen;
    } else if (type == "fire") {
      bgColor = Colors.orange;
    } else if (type == "water") {
      bgColor = Colors.blue;
    } else if (type == "bug") {
      bgColor = Colors.cyan;
    } else {
      bgColor = Colors.purpleAccent;
    }

    return bgColor;
  }
}
