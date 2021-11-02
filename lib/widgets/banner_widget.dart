import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      borderRadius: 10,
      curveType: CurveType.convex,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .27,
        color: Colors.cyan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "CARS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 45.0,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            isRepeatingAnimation: true,
                            animatedTexts: [
                              FadeAnimatedText(
                                'Reach 10 Lakh+\nInterested Buyers',
                                duration: const Duration(seconds: 4),
                              ),
                              FadeAnimatedText(
                                'New Way to \nBuy or sell cars',
                                duration: const Duration(seconds: 4),
                              ),
                              FadeAnimatedText(
                                'Over 1 Lakh\nCar to Buy',
                                duration: const Duration(seconds: 4),
                              ),
                            ],
                            onTap: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                  ClayContainer(
                    color: Colors.white,
                    borderRadius: 10,
                    spread: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/adds-2fe42.appspot.com/o/banner%2Fcar.png?alt=media&token=bb66159a-6ae5-487b-ba38-3219bbe55a4c"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: ClayContainer(
                        color: Colors.white,
                        spread: 0,
                        borderRadius: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: ClayText(
                              "Buy",
                              //  size: 20,
                              textColor: Colors.black,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: ClayContainer(
                        color: Colors.white,
                        spread: 0,
                        borderRadius: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: ClayText(
                              "Sell",
                              textColor: Colors.black,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
