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

  Stream<int> getRandomNumberStream() {
    return _dio.get<ResponseBody>('/random-stream').asStream().asyncExpand((response) => response.data!.stream
        .transform(StreamTransformer.fromBind(utf8.decoder.bind))
        .transform(const LineSplitter())
        .where((line) => line.startsWith('data:'))
        .map((line) => int.tryParse(line.replaceFirst('data:', '').trim()))
        .where((value) => value != null)
        .map((value) => value!));
  }
}
