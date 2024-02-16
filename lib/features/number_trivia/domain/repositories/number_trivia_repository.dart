import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      {required int number});

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
