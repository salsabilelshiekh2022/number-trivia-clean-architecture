import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDatasource datasource;
  late MockClient mockHttpClient;
  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something went wrong ', 404));
  }

  setUp(() {
    mockHttpClient = MockClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });
  group('get concrete number trivia ', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('Should perform a get request on url with number being the endpoint',
        () async {
      //arrange
      setupMockHttpClientSuccess200();

      //act

      datasource.getConcreteNumberTrivia(number: tNumber);

      //assert
      verify(mockHttpClient.get(Uri.parse("http://numbersapi.com/$tNumber"),
          headers: {'contant-type': 'application/json'}));
    });
    test('Should return number trivia model if the responce code is 200',
        () async {
      //arrange
      setupMockHttpClientSuccess200();

      //act

      final result = await datasource.getConcreteNumberTrivia(number: tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('Should return server exception if the responce code is 404 or other',
        () async {
      //arrange
      setupMockHttpClientFailure404();

      //act

      result() async => datasource.getConcreteNumberTrivia(number: tNumber);

      //assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('get random number trivia ', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('Should perform a get request on url with number being the endpoint',
        () async {
      //arrange
      setupMockHttpClientSuccess200();

      //act

      datasource.getRandomNumberTrivia();

      //assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'contant-type': 'application/json'}));
    });
    test('Should return number trivia model if the responce code is 200',
        () async {
      //arrange
      setupMockHttpClientSuccess200();

      //act

      final result = await datasource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('Should return server exception if the responce code is 404 or other',
        () async {
      //arrange
      setupMockHttpClientFailure404();

      //act

      result() async => datasource.getRandomNumberTrivia();

      //assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
