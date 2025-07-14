import 'dart:async';
import 'package:stacked/stacked.dart';

import '../../../services/api_service.dart';

class HomeViewModel extends FutureViewModel {
  final ApiService _apiService = ApiService();
  final StreamController<int> _controller = StreamController<int>.broadcast();
  final List<int> _lastFiveNumbers = [];

  int get currentNumber => _lastFiveNumbers.isEmpty ? 0 : _lastFiveNumbers.first;

  Stream<int> get randomNumberStream => _controller.stream;
  List<int> get lastFiveNumbers => List.unmodifiable(_lastFiveNumbers);

  void startStreaming() {
    _apiService.getRandomNumberStream().listen((number) {
      _controller.add(number);

      _lastFiveNumbers.insert(0, number);
      if (_lastFiveNumbers.length > 5) {
        _lastFiveNumbers.removeLast();
      }

      rebuildUi();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Future futureToRun() async {
    startStreaming();
  }
}
