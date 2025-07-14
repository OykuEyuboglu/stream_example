import 'package:flutter/material.dart';
import 'home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();
  int? _currentNumber;

  @override
  void initState() {
    super.initState();
    _viewModel.startStreaming();

    _viewModel.randomNumberStream.listen((number) {
      setState(() {
        _currentNumber = number;
      });
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastNumbers = _viewModel.lastFiveNumbers;

    return Scaffold(
      appBar: AppBar(title: const Text("Rastgele Sayılar")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Gelen Sayı:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                _currentNumber?.toString() ?? '',
                key: ValueKey<int?>(_currentNumber),
                style:
                    const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Son 5 Sayı:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ...List.generate(lastNumbers.length, (index) {
              final label = index == 0 ? 'Sonuncu' : 'Sondan ${index + 1}';
              return Text(
                '$label: ${lastNumbers[index]}',
                style: const TextStyle(fontSize: 18),
              );
            }),
          ],
        ),
      ),
    );
  }
}
