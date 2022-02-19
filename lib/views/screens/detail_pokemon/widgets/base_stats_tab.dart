import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokemon_app/business_logic/models/pokemon_model.dart';

// ignore: must_be_immutable
class BaseStatsTab extends StatefulWidget {
  BaseStatsTab({Key? key, required this.pokemon}) : super(key: key);
  PokemonModel? pokemon;

  @override
  _BaseStatsTabState createState() => _BaseStatsTabState();
}

class _BaseStatsTabState extends State<BaseStatsTab> {
  int total = 0;

  void countTotal(int value) {
    total += value;
  }

  @override
  void initState() {
    super.initState();
    firstAction();
  }

  Future<void> firstAction() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

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
                itemCount: widget.pokemon!.stats!.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  countTotal(widget.pokemon!.stats![i].amount!);
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              widget.pokemon!.stats![i].name! ==
                                      "special-attack"
                                  ? "SP Attack"
                                  : widget.pokemon!.stats![i].name! ==
                                          "special-defense"
                                      ? "SP Defense"
                                      : widget.pokemon!.stats![i].name!,
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
                              "${widget.pokemon!.stats![i].amount}",
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
                            percent:
                                (widget.pokemon!.stats![i].amount! / 100) >= 1
                                    ? 1.0
                                    : (widget.pokemon!.stats![i].amount! / 100),
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
                  flex: 2,
                  child: SizedBox(
                    width: size.width,
                    child: const Text(
                      "Total",
                      style: TextStyle(
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
                      "$total",
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
                    percent: double.parse(
                                ((total / widget.pokemon!.stats!.length) / 100)
                                    .toStringAsFixed(2)) >=
                            1
                        ? 1.0
                        : double.parse(
                            ((total / widget.pokemon!.stats!.length) / 100)
                                .toStringAsFixed(2)),
                    progressColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Type Defense",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "The effectiveness of each type on ${widget.pokemon!.name}",
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
