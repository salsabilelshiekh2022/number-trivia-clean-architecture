import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDatasource datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDatasourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia ', () {
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return number trivia from shared preferences when there is one in cached ',
        () async {
      //arrange

      when(mockSharedPreferences.getString('Cached'))
          .thenReturn(fixture('trivia_cached.json'));

      //act

      final result = await datasource.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString('Cached'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw cached exception when there is not a cached value',
        () async {
      //arrange

      when(mockSharedPreferences.getString('Cached')).thenReturn(null);

      //act

      result() => datasource.getLastNumberTrivia();

      //assert

      expect(result, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cached number trivia ', () {
    final tNumberTriviaModel =
        NumberTriviaModel(numberModel: 1, textModel: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) => Future.value(true));
        // act
        datasource.cacheNumberTrivia(triviaToCache: tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
          'Cached',
          expectedJsonString,
        ));
      },
    );
  });
}
