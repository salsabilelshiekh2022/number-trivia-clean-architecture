import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDatasource localDatasource;
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTriviaModel>> getConcreteNumberTrivia(
      {required int number}) async {
    return await _getTrivia(() {
      return remoteDatasource.getConcreteNumberTrivia(number: number);
    });
  }

  @override
  Future<Either<Failure, NumberTriviaModel>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDatasource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaModel>> _getTrivia(
      Future<NumberTriviaModel> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDatasource.cacheNumberTrivia(triviaToCache: remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDatasource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
