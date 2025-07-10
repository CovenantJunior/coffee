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
  bool on = false;
  bool filling = false;
  bool filled = false;
  bool ordering = false;
  bool showDrip = false;
  double _progress = 0.0;
  Timer? _timer;
  late AudioPlayer clink;
  late AudioPlayer drip;
  late AudioPlayer pouring;
  late AudioPlayer slide;
  late AudioPlayer swoosh;

  bool showFlyingCup = false;
  late AnimationController cupFlyController;
  late Animation<Offset> cupOffsetAnimation;
  late Animation<double> cupScaleAnimation;

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
    final random = (2000 + (3000 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)).toInt();
    await Future.delayed(Duration(milliseconds: random));
    setState(() {
      showDrip = true;
    });
    drip = AudioPlayer();
    await drip.setAsset('sfx/drip.mp3');
    await drip.setVolume(1.0);
    await drip.play();
    dropletController.forward(from: 0.0);
    setState(() {
      showDrip = false;
      filled = true;
      on = false;
    });
  }

  void fillUpCup() async {
    setState(() {
      on = true;
    });
    pouring = AudioPlayer();
    await pouring.setAsset('sfx/pouring.mp3');
    pouring.setVolume(1.0);
    pouring.play();
    setState(() {
      filling = true;
      _progress = 0.0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        pouring.setVolume(1 - _progress);
        setState(() {
          _progress += 1 / cupSize / 5;
          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
            pouring.stop();
            filling = false;
            filled = false;
            dripSound();
          }
        });
      });
    });
  }

  void addToOrder() async {
    setState(() {
      ordering = true;
      quantity = 1;
      showFlyingCup = true;
    });

    await cupFlyController.forward(from: 0.0);

    swoosh = AudioPlayer();
    await swoosh.setAsset('sfx/swoosh.mp3');
    await swoosh.setVolume(1);
    await swoosh.play();

    setState(() {
      filling = false;
      filled = false;
      _progress = 0.0;
      orders += 1;
      showFlyingCup = false;
    });

    await Future.delayed(const Duration(milliseconds: 200));
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

    cupFlyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    cupOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.8, -3.0), // adjust for direction to badge
    ).animate(CurvedAnimation(
      parent: cupFlyController,
      curve: Curves.easeInOut,
    ));

    cupScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: cupFlyController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    cupFlyController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () {},
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.coffee_outlined),
                onPressed: () {},
              ),
              orders > 0
                  ? Positioned(
                      right: 10,
                      top: 3,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.brown,
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
                      ),
                    ).animate().scale(
                      begin: const Offset(2.0, 2.0),
                      end: const Offset(1.0, 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(child: Image.asset('images/coffee_machine.png', height: 500)),
                if (on)
                  Positioned(
                    bottom: 350,
                    child: Row(
                      children: [
                        Image.asset('images/indicator.png', height: 70),
                        const SizedBox(width: 33),
                        Image.asset('images/indicator.png', height: 70),
                      ],
                    ),
                  ),
                if (filling)
                  Positioned(
                    bottom: 240,
                    child: Transform.rotate(
                      angle: -270 * 3.14159 / 180,
                      child: LottieBuilder.asset(
                        'lotties/faucet.json',
                        height: 3,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                  ),
                if (showDrip)
                  Positioned(
                    bottom: 200,
                    child: Icon(
                      Icons.water_drop,
                      color: Colors.blueGrey,
                      size: 10,
                    ),
                  ).animate(controller: dropletController).slideY(
                        begin: -7,
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
                      physics: filling ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Image.asset('images/cup${index + 1}.png', height: 80),
                        );
                      },
                    ),
                  ),
                ),
                if (showFlyingCup)
                  Positioned(
                    bottom: 185,
                    left: MediaQuery.of(context).size.width / 2 - cupSize / 2,
                    child: SlideTransition(
                      position: cupOffsetAnimation,
                      child: ScaleTransition(
                        scale: cupScaleAnimation,
                        child: Image.asset(
                          'images/cup1.png',
                          height: cupSize,
                          width: cupSize,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Size Options',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Quicksand', color: Colors.black),
                      children: [
                        TextSpan(text: '\$${sizeToPrice[selectedSize]!.floor()}'),
                        TextSpan(
                          text: '.${(sizeToPrice[selectedSize]! % 1).toStringAsFixed(2).substring(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Small', 'Medium', 'Large', 'XLarge', 'Custom']
                  .map((size) => _buildSizeButton(size))
                  .toList(),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => quantity = 1),
                ),
                Text('$quantity',
                    style: const TextStyle(fontSize: 18, fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => quantity++)),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: !filling && !filled
                        ? ElevatedButton(
                            onPressed: () {
                              if (filling || filled || on) return;
                              fillUpCup();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Tap to fill',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand',
                                  color: Colors.white,
                                )),
                          )
                        : !filled
                            ? LiquidLinearProgressIndicator(
                                value: _progress,
                                valueColor: const AlwaysStoppedAnimation(Colors.brown),
                                backgroundColor: Colors.white,
                                borderColor: Colors.brown,
                                borderWidth: 5.0,
                                borderRadius: 12.0,
                                direction: Axis.horizontal,
                                center: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Filling your cup",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Quicksand',
                                          color: Colors.white)),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: ordering ? null : addToOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: ordering
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : const Text('Add to order',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Quicksand',
                                          color: Colors.white,
                                        )),
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
              color: isSelected ? Colors.brown.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.local_drink, color: isSelected ? Colors.brown : Colors.black54),
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
