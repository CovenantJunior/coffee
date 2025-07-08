import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoffeeOrderScreen(),
    );
  }
}

class CoffeeOrderScreen extends StatefulWidget {
  const CoffeeOrderScreen({super.key});

  @override
  _CoffeeOrderScreenState createState() => _CoffeeOrderScreenState();
}

class _CoffeeOrderScreenState extends State<CoffeeOrderScreen> {
  String selectedSize = 'Large';
  double cupSize = 60.0;
  int quantity = 1;
  bool filling = false;
  bool filled = false;
  double _progress = 0.0;
  Timer? _timer;

  final Map<String, double> sizeToCupSize = {
    'Small': 60.0,
    'Medium': 75.0,
    'Large': 90.0,
    'XLarge': 105.0,
    'Custom': 120.0,
  };

  final Map<String, double> sizeToPrice = {
    'Small': 3.50,
    'Medium': 4.25,
    'Large': 5.00,
    'XLarge': 5.75,
    'Custom': 6.50,
  };

  void fillUpCup() {
    setState(() {
      filling = true;
      _progress = 0.0;
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _progress += 1/cupSize/5;
          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
            filling = false;
            filled = true;
          }
        });
      });
    });
  }

  void addToOrder() {
    setState(() {
      filling = false;
      filled = false;
      _progress = 0.0;
      quantity = 1;
    });
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
          IconButton(
            icon: const Icon(Icons.coffee_outlined),
            onPressed: () {},
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
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: Image.asset(
                    'images/coffee_machine.png',
                    height: 500,
                  ),
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
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Size Options',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand')),
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
                          addToOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add to order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            color: Colors.white,
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
      onTap: () {
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