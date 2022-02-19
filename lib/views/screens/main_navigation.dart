import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/providers/drawer_navigation_provider.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerNavigationProvider>(
      builder: (context, data, chid) => data.currentScreen
    );
  }
}