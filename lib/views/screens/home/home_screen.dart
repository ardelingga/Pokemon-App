import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/views/screens/home/widgets/background_logo.dart';
import 'package:pokemon_app/views/screens/home/widgets/content_shimmer.dart';
import 'package:pokemon_app/views/screens/home/widgets/item_pokemon.dart';
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
                        const BackgroundLogo(),
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
                      return const ContentShimmer();
                    } else if (state is PokemonLoaded) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return ItemPokemon(
                                  pokemon: state.listPokemon[i], i: i);
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
