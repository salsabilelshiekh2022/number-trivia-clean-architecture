// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';

import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  GetConcreteNumberTrivia getConcreteNumberTrivia;
  GetRandomNumberTrivia getRandomNumberTrivia;
  InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        await inputEither.fold((failure) async {
          emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        }, (integer) async {
          emit(Loading());
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          failureOrTrivia.fold((failure) async {
            emit(Error(message: mapFailureToMessage(failure)));
          }, (trivia) async {
            emit(Loaded(trivia: trivia));
          });
        });
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        failureOrTrivia.fold((failure) async {
          emit(Error(message: mapFailureToMessage(failure)));
        }, (trivia) async {
          emit(Loaded(trivia: trivia));
        });
      }
    });
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
