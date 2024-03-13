import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import 'widgets.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        if (state is Empty) {
          return const MessageDisplay(message: 'Start searching!');
        } else if (state is Loading) {
          return const LoadingWidget();
        } else if (state is Loaded) {
          return TriviaDisplay(numberTrivia: state.trivia);
        } else if (state is Error) {
          return MessageDisplay(message: state.message);
        } else {
          return const MessageDisplay(message: 'Start searching!');
        }
      },
    );
  }
}
