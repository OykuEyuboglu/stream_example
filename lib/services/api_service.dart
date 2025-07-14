import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'dart:html' as html;

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: Duration.zero,
    responseType: ResponseType.stream,
  ));

 Stream<int> getRandomNumberStream() {
  if (kIsWeb) {
    final controller = StreamController<int>();
    final source = html.EventSource('http://localhost:3000/random-stream');

    source.onMessage.listen((event) {
      final value = int.tryParse(event.data?.toString() ?? '');
      if (value != null) controller.add(value);
    });

    source.onError.listen((event) {
      controller.addError('SSE bağlantı hatası: $event');
      source.close();
    });

    return controller.stream;
  } else {
    return _dio
        .get<ResponseBody>('/random-stream')
        .asStream()
        .asyncExpand((response) => response.data!.stream
            .transform(StreamTransformer.fromBind(utf8.decoder.bind))
            .transform(const LineSplitter())
            .where((line) => line.startsWith('data:'))
            .map((line) => int.tryParse(line.replaceFirst('data:', '').trim()))
            .where((value) => value != null)
            .map((value) => value!));
  }

  }
}
