import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/providers/drawer_navigation_provider.dart';
import 'package:pokemon_app/views/screens/home/widgets/img_loading_shimmer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerNavigationWidget extends StatelessWidget {
  DrawerNavigationWidget({Key? key}) : super(key: key);

  DrawerNavigationProvider? drawerNavigationProvider;

  @override
  Widget build(BuildContext context) {
    drawerNavigationProvider = context.read<DrawerNavigationProvider>();
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFF48d0b0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://freepngimg.com/thumb/pokemon/110381-ketchum-ash-pokemon-download-hq-thumb.png",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const ImgLoadingShimmer(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Satoshi",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "sathosi@gmail.com",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Consumer<DrawerNavigationProvider>(builder: (context, data, i) {
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  itemMenuListTile(
                    iconData: Icons.home_outlined,
                    nameMenu: "Home",
                    isActive: data.currentMenu == 0 ? true : false,
                    onTap: () async {
                      await drawerNavigationProvider!.setCurrentMenu(0);
                      Navigator.pop(context);
                    },
                  ),
                  itemMenuListTile(
                    iconData: Icons.favorite_border_rounded,
                    nameMenu: "Favorites",
                    isActive: data.currentMenu == 1 ? true : false,
                    onTap: () async {
                      await drawerNavigationProvider!.setCurrentMenu(1);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget itemMenuListTile(
      {required IconData iconData,
      required String nameMenu,
      required bool isActive,
      required Function onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.withOpacity(0.3) : Colors.white,
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.black87,
        ),
        title: Align(
          alignment: const Alignment(-1.2, 0),
          child: Text(
            nameMenu,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
