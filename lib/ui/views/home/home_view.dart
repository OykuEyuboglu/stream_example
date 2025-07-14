import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rastgele Sayılar")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Gelen Sayı:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Text(
                viewModel.currentNumber.toString(),
                key: ValueKey<int?>(viewModel.currentNumber),
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Son 5 Sayı:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ...List.generate(viewModel.lastFiveNumbers.length, (index) {
              final label = index == 0 ? 'Sonuncu' : 'Sondan ${index + 1}';
              return Text(
                '$label: ${viewModel.lastFiveNumbers[index]}',
                style: const TextStyle(fontSize: 18),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
