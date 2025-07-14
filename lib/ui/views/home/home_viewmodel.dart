import 'dart:async';
import '../../../services/api_service.dart';

class HomeViewModel {
  final ApiService _apiService = ApiService();
  final StreamController<int> _controller = StreamController<int>.broadcast();
  final List<int> _lastFiveNumbers = [];

  Stream<int> get randomNumberStream => _controller.stream;
  List<int> get lastFiveNumbers => List.unmodifiable(_lastFiveNumbers);

  void startStreaming() {
    _apiService.getRandomNumberStream().listen((number) {
      _controller.add(number);

      _lastFiveNumbers.insert(0, number);
      if (_lastFiveNumbers.length > 5) {
        _lastFiveNumbers.removeLast();
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}
