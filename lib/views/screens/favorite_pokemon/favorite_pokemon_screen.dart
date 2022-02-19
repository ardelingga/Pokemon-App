import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/providers/drawer_navigation_provider.dart';
import 'package:pokemon_app/views/screens/favorite_pokemon/widgets/favorite_shimmer.dart';
import 'package:pokemon_app/views/screens/favorite_pokemon/widgets/item_favorite.dart';
import 'package:pokemon_app/views/screens/home/widgets/background_logo.dart';
import 'package:pokemon_app/views/screens/home/widgets/content_shimmer.dart';
import 'package:pokemon_app/views/screens/home/widgets/item_pokemon.dart';
import 'package:pokemon_app/views/widgets/common_widgets.dart';
import 'package:pokemon_app/views/widgets/drawer_navigation_widget.dart';

class FavoritePokemonScreen extends StatefulWidget {
  const FavoritePokemonScreen({Key? key}) : super(key: key);

  @override
  _FavoritePokemonScreenState createState() => _FavoritePokemonScreenState();
}

class _FavoritePokemonScreenState extends State<FavoritePokemonScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerNavigationProvider? drawerNavigationProvider;
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
    await pokemonCubit.getListFavoritePokemon();
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
    drawerNavigationProvider = context.read<DrawerNavigationProvider>();
    Size size = MediaQuery.of(context).size;
    return BlocProvider<PokemonCubit>(
      create: (context) => pokemonCubit,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: DrawerNavigationWidget(),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const BackgroundLogo(),
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
                      onPressed: () async{
                        await drawerNavigationProvider!.setCurrentMenu(0);
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
                        const BackgroundLogo(),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 100),
                          bottom: 10,
                          left: heightSliverbar,
                          child: const Text(
                            "My Favorites Pokemon ",
                            overflow: TextOverflow.ellipsis,
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
                      return const FavoriteShimmer();
                    } else if (state is PokemonLoaded) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              ListView.builder(
                                itemCount: state.listPokemon.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, i) {
                                  return ItemFavorite(
                                      pokemon: state.listPokemon[i], i: i);
                                },
                              )
                            ],
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
