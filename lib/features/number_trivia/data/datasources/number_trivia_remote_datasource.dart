import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTrivia> getConcreteNumberTrivia({required int number});
  Future<NumberTrivia> getRandomNumberTrivia();
}
