import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/blocs/pokemon/pokemon_cubit.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
          ],
        ),
      ),
    );
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
