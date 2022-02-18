import 'package:flutter/material.dart';
import 'package:pokemon_app/business_logic/models/response_model.dart';
import 'package:pokemon_app/business_logic/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var params = {'offset': 0, 'limit': 20};
                        ResponseModel responseModel = await apiService
                            .getRequest("pokemon", params: params);

                        print(responseModel.data[0]['name']);
                      },
                      child: const Text("TEST API"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
