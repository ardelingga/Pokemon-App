import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_app/business_logic/constants/path_assets.dart';

class BackgroundLogo extends StatelessWidget {
  const BackgroundLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      right: -132,
      top: -110,
      child: SizedBox(
        child: SvgPicture.asset(
          PathAssets.icons + "icon_pokemon.svg",
          width: size.width / 1.2,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
