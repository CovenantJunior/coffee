import 'package:flutter/material.dart';

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

  final Map<String, double> sizeToCupSize = {
    'Small': 40.0,
    'Medium': 50.0,
    'Large': 60.0,
    'XLarge': 70.0,
    'Custom': 80.0,
  };

  final Map<String, double> sizeToPrice = {
    'Small': 25.0,
    'Medium': 27.0,
    'Large': 30.0,
    'XLarge': 35.0,
    'Custom': 40.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Caramel Frappuccino',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon
            (Icons.arrow_back_ios_rounded,
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
            Center(
              child: Image.asset(
                'images/coffee_machine.png',
                height: 500,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Text('Size Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '\$${sizeToPrice[selectedSize]!.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
              ),
            ),
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
            const Spacer(),
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
                  style: const TextStyle(fontSize: 18, fontFamily: 'Quicksand'),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
                const Spacer(),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.local_drink,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
            ),
          ),
        ],
      ),
    );
  }
}
