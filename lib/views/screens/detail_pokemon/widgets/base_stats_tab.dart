import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';

class BaseStatsTab extends StatelessWidget {
  BaseStatsTab({Key? key, required this.pokemon}) : super(key: key);
  PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                itemCount: pokemon.stats!.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              pokemon.stats![i].name! == "special-attack"
                                  ? "SP Attack"
                                  : pokemon.stats![i].name! == "special-defense"
                                      ? "SP Defense"
                                      : pokemon.stats![i].name!,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              "${pokemon.stats![i].amount}",
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: LinearPercentIndicator(
                            barRadius: const Radius.circular(30),
                            lineHeight: 8.0,
                            percent: (pokemon.stats![i].amount! / 100),
                            progressColor:
                                i % 2 == 0 ? Colors.redAccent : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: size.width,
                    child: Text(
                      "Total",
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: size.width,
                    child: Text(
                      "317",
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Type Defense",
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "The effectiveness of each type on ${pokemon.name}",
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
