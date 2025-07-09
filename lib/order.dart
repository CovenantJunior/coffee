import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';

class CoffeeOrderScreen extends StatefulWidget {
  const CoffeeOrderScreen({super.key});

  @override
  _CoffeeOrderScreenState createState() => _CoffeeOrderScreenState();
}

class _CoffeeOrderScreenState extends State<CoffeeOrderScreen> with TickerProviderStateMixin {
  String selectedSize = 'Large';
  double cupSize = 70.0;
  int quantity = 1;
  int orders = 0;
  bool filling = false;
  bool filled = false;
  bool ordering = false;
  double _progress = 0.0;
  Timer? _timer;
  late AudioPlayer clink;
  late AudioPlayer drip;
  late AudioPlayer pouring;
  late AudioPlayer slide;
  late AudioPlayer swoosh;

  late AnimationController dropletController;

  final Map<String, double> sizeToCupSize = {
    'Small': 40.0,
    'Medium': 50.0,
    'Large': 70.0,
    'XLarge': 80.0,
    'Custom': 90.0,
  };

  final Map<String, double> sizeToPrice = {
    'Small': 3.50,
    'Medium': 4.25,
    'Large': 5.00,
    'XLarge': 5.75,
    'Custom': 6.50,
  };

  void dripSound() async {
    Future.delayed(const Duration(seconds: 1), () async {
      dropletController.forward(from: 0.0);
      drip = AudioPlayer();
      await drip.setAsset('sfx/drip.mp3');
      drip.setVolume(1.0);
      drip.play();
    });
  }

  void fillUpCup() async {
    pouring = AudioPlayer();
    await pouring.setAsset('sfx/pouring.mp3');
    pouring.setVolume(1.0);
    pouring.play();
    setState(() {
      filling = true;
      _progress = 0.0;
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        pouring.setVolume(1 - _progress);
        setState(() {
          _progress += 1/cupSize/5;
          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
            filling = false;
            filled = true;
            pouring.stop();
            dripSound();
          }
        });
      });
    });
  }

  void addToOrder() async{
    setState(() {
      ordering = true;
    });
    swoosh = AudioPlayer();
    await swoosh.setAsset('sfx/swoosh.mp3');
    await swoosh.setVolume(1);
    await swoosh.play();
    setState(() {
      filling = false;
      filled = false;
      _progress = 0.0;
      orders +=1;
    });
    await swoosh.play();
    setState(() {
      ordering = false;
    });
  }

  @override
  void initState() {
    super.initState();
    dropletController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Caramel Frappuccino',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
          ),
          onPressed: () {},
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.coffee_outlined),
                onPressed: () {},
              ),
              orders > 0 ? Positioned(
                right: 10,
                top: 3,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.brown, // Red background for the badge
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    orders.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ): const SizedBox()
            ]
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'images/coffee_machine.png',
                    height: 500,
                  ),
                ),
                filling ? Positioned(
                  bottom: 240,
                  child: Transform.rotate(
                    angle: -270 * 3.14159 / 180,
                    child: LottieBuilder.asset(
                      'lotties/faucet.json',
                      height: 3,
                      // width: 20,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ) : const SizedBox(),
                Positioned(
                  bottom: 260,
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.brown,
                    size: 10,
                  ),
                ).animate(
                  controller: dropletController,
                ).slideY(
                  begin: 0.5,
                  end: 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
                Positioned(
                  bottom: 185,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: cupSize,
                    width: 200,
                    child: PageView.builder(
                      itemCount: 3,
                      controller: PageController(viewportFraction: 0.7),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Image.asset(
                            'images/cup${index + 1}.png',
                            height: 80,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                      'Size Options',
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand'
                    )
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${sizeToPrice[selectedSize]!.floor()}',
                        ),
                        TextSpan(
                          text:
                              '.${(sizeToPrice[selectedSize]! % 1).toStringAsFixed(2).substring(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSizeButton('Small'),
                _buildSizeButton('Medium'),
                _buildSizeButton('Large'),
                _buildSizeButton('XLarge'),
                _buildSizeButton('Custom'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      quantity = 1;
                    });
                  },
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    width: 50,
                    child: !filling && !filled
                        ? ElevatedButton(
                            onPressed: () {
                            if (filling || filled) return;
                              fillUpCup();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Tap to fill',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                                color: Colors.white,
                              ),
                            ),
                          )
                        : !filled ? LiquidLinearProgressIndicator(
                        value: _progress,
                        valueColor: const AlwaysStoppedAnimation(Colors.brown),
                        backgroundColor: Colors.white,
                        borderColor: Colors.brown,
                        borderWidth: 5.0,
                        borderRadius: 12.0,
                        direction: Axis.horizontal,
                        center: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text(
                            "Filling your cup",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ) : ElevatedButton(
                        onPressed: () {
                          if (ordering) return;
                          addToOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: !ordering ? const Text(
                          'Add to order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            color: Colors.white,
                          ),
                        ) : SizedBox(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () async {
        clink = AudioPlayer();
        await clink.setAsset('sfx/clink.mp3');
        await clink.setVolume(1);
        await clink.play();
        if (filling) return;
        setState(() {
          selectedSize = size;
          cupSize = sizeToCupSize[size]!;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.brown.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.local_drink,
              color: isSelected ? Colors.brown : Colors.black54,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.brown : Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
            ),
          ),
        ],
      ),
    );
  }
}