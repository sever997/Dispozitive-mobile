import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StressReliefPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Relief Duck'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            context.go('/main'); // Navigate back to main page using GoRouter
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Feeling stressed? Pet the duck!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quack! Feeling better? 🦆'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/duck.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quack! Feeling better? 🦆'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Click the duck for a surprise!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
