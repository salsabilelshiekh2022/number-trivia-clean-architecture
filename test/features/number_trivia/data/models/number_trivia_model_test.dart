import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final tNumberTrivia =
      NumberTriviaModel(textModel: 'test text', numberModel: 1);
  test('number trivia model ...', () async {
    //assert
    expect(tNumberTrivia, isA<NumberTrivia>());
  });
}
