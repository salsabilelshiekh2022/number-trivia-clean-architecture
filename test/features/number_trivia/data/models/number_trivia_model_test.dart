import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTrivia =
      NumberTriviaModel(textModel: 'test text', numberModel: 1);
  test('number trivia model ...', () async {
    //assert
    expect(tNumberTrivia, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTrivia);
      },
    );
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTrivia);
      },
    );
  });

  group('to json', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tNumberTrivia.toJson();
        // assert
        final expectedMap = {
          "text": "test text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
