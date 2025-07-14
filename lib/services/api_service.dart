import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: Duration.zero,
    responseType: ResponseType.stream,
  ));

  Stream<int> getRandomNumberStream() async* {
    final response = await _dio.get<ResponseBody>('/random-stream');

    await for (var line in response.data!.stream
        .transform(StreamTransformer.fromBind(utf8.decoder.bind))
        .transform(const LineSplitter())) {
      if (line.startsWith('data:')) {
        final value = int.tryParse(line.replaceFirst('data:', '').trim());
        if (value != null) yield value;
      }
    }
  }
}
