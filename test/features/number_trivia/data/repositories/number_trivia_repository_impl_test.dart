import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDatasource, NumberTriviaLocalDatasource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNumberTriviaLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockNumberTriviaLocalDatasource();
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        localDatasource: mockLocalDatasource,
        remoteDatasource: mockRemoteDatasource,
        networkInfo: mockNetworkInfo);
  });

  group('get concrete number trivia ', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(textModel: 'test text', numberModel: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when we call remote data source succesful',
          () async {
        //arrange
        when(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act

        final result =
            await repository.getConcreteNumberTrivia(number: tNumber);

        //assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache data when call remote data source successful',
          () async {
        //arrange
        when(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act

        await repository.getConcreteNumberTrivia(number: tNumber);

        //assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber));
        verify(mockLocalDatasource.cacheNumberTrivia(
            triviaToCache: tNumberTriviaModel));
      });

      test(
          'should return server failure when we call remote data source unsuccesful',
          () async {
        //arrange
        when(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber))
            .thenThrow(ServerException());

        //act

        final result =
            await repository.getConcreteNumberTrivia(number: tNumber);

        //assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(number: tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return late cached data when the cached data is present ',
          () async {
        //arrange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act

        final result =
            await repository.getConcreteNumberTrivia(number: tNumber);

        //assert

        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return cache failure when there is no cached data',
          () async {
        //arrange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act

        final result =
            await repository.getConcreteNumberTrivia(number: tNumber);

        //assert

        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('get random number trivia ', () {
    final tNumberTriviaModel =
        NumberTriviaModel(textModel: 'test text', numberModel: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when we call remote data source succesful',
          () async {
        //arrange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act

        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache data when call remote data source successful',
          () async {
        //arrange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act

        await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verify(mockLocalDatasource.cacheNumberTrivia(
            triviaToCache: tNumberTriviaModel));
      });

      test(
          'should return server failure when we call remote data source unsuccesful',
          () async {
        //arrange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        //act

        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return late cached data when the cached data is present ',
          () async {
        //arrange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act

        final result = await repository.getRandomNumberTrivia();

        //assert

        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return cache failure when there is no cached data',
          () async {
        //arrange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act

        final result = await repository.getRandomNumberTrivia();

        //assert

        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
