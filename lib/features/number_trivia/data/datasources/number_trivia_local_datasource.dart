import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTrivia> getLastNumberTrivia();
  Future<void> cacheNumberTrivia({required NumberTrivia triviaToCache});
}
