import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';
import 'package:pokemon_app/views/screens/detail_pokemon/detail_pokemon_screen.dart';
import 'package:pokemon_app/views/widgets/common_widgets.dart';
import 'package:pokemon_app/views/widgets/drawer_navigation_widget.dart';

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
        endDrawer: const DrawerNavigationWidget(),
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
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPokemonScreen(
                                                pokemon: state.listPokemon[i],
                                                heroTag: "imgHeroTag#$i",
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        CommonWidget.getBackgoundColor(type!),
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
                                                color: Colors.white
                                                    .withOpacity(0.3),
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
                                                        padding:
                                                            EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, j) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
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
                                                                    horizontal:
                                                                        4,
                                                                    vertical:
                                                                        2),
                                                                child: Center(
                                                                  child: Text(
                                                                    state
                                                                        .listPokemon[
                                                                            i]
                                                                        .types![
                                                                            j]
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
                                                      child: Hero(
                                                        tag: "imgHeroTag#$i",
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: state
                                                              .listPokemon[i]
                                                              .img!,
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
                                                              color:
                                                                  Colors.grey,
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
  }
}
